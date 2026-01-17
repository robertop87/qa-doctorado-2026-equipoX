#!/usr/bin/env bash
# Script de Medición de Latencia para la Aplicación Pet Store
# 
# Este script mide el tiempo de respuesta del endpoint de inventario
#
# Uso: ./measure_latency.sh [número_de_iteraciones]
# Ejemplo: ./measure_latency.sh 30
#
# Los resultados se guardan en evidence/week2/

set -euo pipefail

# Configuración
N="${1:-30}"  # Número de repeticiones (30 por defecto)
BASE_URL="http://localhost:8080/api/v3"
ENDPOINT="/store/inventory"
OUTPUT_DIR="evidence/week2"
RESULTS_FILE="${OUTPUT_DIR}/latency.csv"
SUMMARY_FILE="${OUTPUT_DIR}/latency_summary.txt"

echo "📊 Midiendo latencia para la aplicación Pet Store..."
echo ""
echo "Configuración:"
echo "  - Endpoint: ${ENDPOINT}"
echo "  - Repeticiones: ${N}"
echo "  - URL Base: ${BASE_URL}"
echo ""

# Crear directorio de evidencias si no existe
mkdir -p "${OUTPUT_DIR}"

# Inicializar archivo CSV
echo "run,time_total" > "${RESULTS_FILE}"

# ===== Medición de Latencia =====
echo "🔄 Ejecutando ${N} mediciones de latencia..."

total_time=0
min_time=""
max_time=""

for i in $(seq 1 "$N"); do
    # Medir tiempo de respuesta usando curl
    t=$(curl -s -w "%{time_total}" -o /dev/null "${BASE_URL}${ENDPOINT}")
    echo "${i},${t}" >> "${RESULTS_FILE}"
    
    # Mostrar progreso cada 5 iteraciones
    if [ $((i % 5)) -eq 0 ]; then
        echo "   Progreso: ${i}/${N} mediciones completadas..."
    fi
    
    # Calcular estadísticas en tiempo real
    total_time=$(echo "$total_time + $t" | bc -l)
    
    if [ -z "$min_time" ] || [ $(echo "$t < $min_time" | bc -l) -eq 1 ]; then
        min_time=$t
    fi
    
    if [ -z "$max_time" ] || [ $(echo "$t > $max_time" | bc -l) -eq 1 ]; then
        max_time=$t
    fi
done

echo "   ✓ ${N} mediciones completadas"

# ===== Cálculo de Estadísticas =====
echo ""
echo "📈 Calculando estadísticas..."

avg_time=$(echo "scale=6; $total_time / $N" | bc -l)
avg_time_ms=$(echo "$avg_time * 1000" | bc -l | cut -d. -f1)
min_time_ms=$(echo "$min_time * 1000" | bc -l | cut -d. -f1)
max_time_ms=$(echo "$max_time * 1000" | bc -l | cut -d. -f1)

# Guardar resumen en archivo
cat > "${SUMMARY_FILE}" << EOF
Reporte de Medición de Latencia - Pet Store API
================================================

Fecha: $(date '+%Y-%m-%d %H:%M:%S')
Endpoint: ${ENDPOINT}
URL Completa: ${BASE_URL}${ENDPOINT}

Estadísticas de Rendimiento:
-----------------------------
Total de mediciones: ${N}
Tiempo promedio:     ${avg_time_ms} ms (${avg_time} s)
Tiempo mínimo:       ${min_time_ms} ms (${min_time} s)
Tiempo máximo:       ${max_time_ms} ms (${max_time} s)

Archivos generados:
-------------------
- Datos detallados: ${RESULTS_FILE}
- Resumen: ${SUMMARY_FILE}

EOF

# Mostrar resumen en consola
echo ""
echo "================================"
echo "📊 Resumen de Latencia"
echo "================================"
echo "Total de mediciones: ${N}"
echo "Tiempo promedio:     ${avg_time_ms} ms"
echo "Tiempo mínimo:       ${min_time_ms} ms"
echo "Tiempo máximo:       ${max_time_ms} ms"
echo ""
echo "✅ Medición completada exitosamente"
echo ""
echo "📁 Archivos generados:"
echo "   - ${RESULTS_FILE}"
echo "   - ${SUMMARY_FILE}"
