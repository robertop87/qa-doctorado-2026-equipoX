#!/usr/bin/env bash
# Script de Pruebas de Entradas Inválidas para Pet Store
# 
# Este script prueba el manejo de entradas inválidas de la API,
# verificando que el sistema rechace correctamente IDs inválidos
# y retorne códigos de error apropiados.
#
# Pruebas incluidas:
# - ID negativo (-1)
# - ID cero (0)
# - ID fuera de rango (999999)
# - ID no numérico (abc)
#
# Oráculo: Ninguna entrada inválida debe retornar HTTP 200
#
# Los resultados se guardan en evidence/week2/

set -euo pipefail

echo "🔍 Ejecutando pruebas de entradas inválidas para Pet Store..."
echo ""

# Configuración
OUTPUT_DIR="evidence/week2"
BASE_URL="http://localhost:8080/api/v3"
RESULTS_FILE="${OUTPUT_DIR}/invalid_ids.csv"

# IDs inválidos a probar
INVALID_IDS=(-1 0 999999 abc)

echo "Configuración:"
echo "  - URL Base: ${BASE_URL}"
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
echo "🔎 Validando oráculo de prueba..."
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
echo "   - ${OUTPUT_DIR}/invalid_pet_*.json (respuestas individuales)"
