#!/usr/bin/env bash
# Script de Pruebas de Entradas Inválidas para Pet Store
# 
# Escenario Q3: Robustez ante IDs inválidos en /pet/{id} (Robustness / Error Handling)
# 
# Este script atiende al escenario Q3 probando el manejo de entradas inválidas.
#
# Estímulo: se solicita GET /pet/{id} con valores inválidos (e.g., -1, 0, 999999, abc)
# Entorno: ejecución local, sin carga, 1 vez por caso
# Respuesta: el SUT NO debe responder 200 para entradas inválidas
# Medida (falsable): para cada caso, HTTP != 200 (se registra el código)
# Evidencia: evidence/week2/invalid_ids.csv + evidence/week2/invalid_pet_<id>.json
#
# Los resultados se guardan en evidence/week2/

set -euo pipefail

echo "🔍 Escenario Q3: Robustez ante IDs Inválidos"
echo "=============================================="
echo ""

# Configuración
OUTPUT_DIR="evidence/week2"
BASE_URL="http://localhost:8080/api/v3"
RESULTS_FILE="${OUTPUT_DIR}/invalid_ids.csv"

# IDs inválidos a probar
INVALID_IDS=(-1 0 999999 abc)

echo "Configuración:"
echo "  - URL Base: ${BASE_URL}"
echo "  - Endpoint: /pet/{id}"
echo "  - Directorio de salida: ${OUTPUT_DIR}"
echo "  - IDs inválidos a probar: ${INVALID_IDS[*]}"
echo ""

# Crear directorio de evidencias si no existe
mkdir -p "${OUTPUT_DIR}"

# ===== Inicializar Archivo de Resultados =====
echo "id,http_code" > "${RESULTS_FILE}"

# ===== Ejecutar Pruebas con Entradas Inválidas =====
echo "🧪 Probando entradas inválidas..."
echo ""

total_tests=0
failed_tests=0

for id in "${INVALID_IDS[@]}"; do
    total_tests=$((total_tests + 1))
    
    # Realizar solicitud con ID inválido
    code=$(curl -s -o "${OUTPUT_DIR}/invalid_pet_${id}.json" -w "%{http_code}" "${BASE_URL}/pet/${id}")
    echo "${id},${code}" >> "${RESULTS_FILE}"
    
    # Mostrar resultado de la prueba
    if [ "$code" = "200" ]; then
        echo "   ❌ ID '${id}': HTTP ${code} (¡ERROR! No debería retornar 200)"
        failed_tests=$((failed_tests + 1))
    else
        echo "   ✅ ID '${id}': HTTP ${code} (Rechazado correctamente)"
    fi
done

echo ""
echo "================================"

# ===== Validación del Oráculo =====
echo "🔎 Validación del Oráculo"
echo "========================="
echo ""
echo "Regla del oráculo: Ninguna entrada inválida debe retornar HTTP 200"
echo ""

# Verificar si alguna entrada inválida retornó 200
if tail -n +2 "${RESULTS_FILE}" | cut -d',' -f2 | grep -q "^200$"; then
    echo "❌ FALLO: Algunas entradas inválidas retornaron HTTP 200"
    echo ""
    echo "Resumen:"
    echo "  - Pruebas totales: ${total_tests}"
    echo "  - Pruebas fallidas: ${failed_tests}"
    echo "  - Tasa de éxito: $(( (total_tests - failed_tests) * 100 / total_tests ))%"
    echo ""
    echo "📁 Resultados guardados en: ${RESULTS_FILE}"
    exit 1
fi

# ===== Reporte de Éxito =====
echo "✅ ÉXITO: Todas las entradas inválidas fueron rechazadas correctamente"
echo ""
echo "Resumen:"
echo "  - Pruebas totales: ${total_tests}"
echo "  - Pruebas exitosas: ${total_tests}"
echo "  - Tasa de éxito: 100%"
echo ""
echo "📁 Archivos generados:"
echo "   - ${RESULTS_FILE}"
echo "   - ${OUTPUT_DIR}/pet_*.json (respuestas individuales)"
