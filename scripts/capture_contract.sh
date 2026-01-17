#!/usr/bin/env bash
# Script de Captura de Contrato OpenAPI para Pet Store
# 
# Escenario Q1: Disponibilidad mínima del contrato (Contract Availability)
# 
# Este script atiende al escenario Q1 capturando la especificación OpenAPI.
#
# Estímulo: un consumidor solicita el contrato OpenAPI
# Entorno: ejecución local, SUT recién iniciado
# Respuesta: el SUT entrega el documento OpenAPI
# Medida (falsable): HTTP 200 y el cuerpo contiene el campo "openapi"
# Evidencia: evidence/week2/openapi.json y evidence/week2/openapi_http_code.txt
#
# Los resultados se guardan en evidence/week2/

set -euo pipefail

echo "📄 Escenario Q1: Disponibilidad del Contrato OpenAPI"
echo "===================================================="
echo ""

# Configuración
OUTPUT_DIR="evidence/week2"
BASE_URL="http://localhost:8080/api/v3"
CONTRACT_FILE="${OUTPUT_DIR}/openapi.json"
HTTP_CODE_FILE="${OUTPUT_DIR}/openapi_http_code.txt"

echo "Configuración:"
echo "  - URL Base: ${BASE_URL}"
echo "  - Endpoint: /openapi.json"
echo "  - Directorio de salida: ${OUTPUT_DIR}"
echo ""

# Crear directorio de evidencias si no existe
mkdir -p "${OUTPUT_DIR}"

# ===== Captura de Especificación OpenAPI =====
echo "🔄 Capturando especificación OpenAPI..."

code=$(curl -s -o "${CONTRACT_FILE}" -w "%{http_code}" "${BASE_URL}/openapi.json")
echo "${code}" > "${HTTP_CODE_FILE}"

# Verificar que el archivo contiene datos válidos de OpenAPI
if grep -q "\"openapi\"" "${CONTRACT_FILE}"; then
    echo "   ✅ Especificación OpenAPI capturada"
else
    echo "   ❌ ERROR: El archivo no contiene el campo 'openapi'"
    exit 1
fi

echo ""
echo "================================"
echo "📊 Resultados de Validación"
echo "================================"
echo "Código HTTP: ${code}"
echo "Validación oráculo: HTTP ${code} + campo 'openapi' encontrado"

if [ "${code}" = "200" ]; then
    echo ""
    echo "✅ ÉXITO: El contrato OpenAPI está disponible"
    echo ""
    echo "📁 Archivos generados:"
    echo "   - ${CONTRACT_FILE}"
    echo "   - ${HTTP_CODE_FILE}"
else
    echo ""
    echo "❌ FALLO: Se esperaba HTTP 200, se recibió HTTP ${code}"
    exit 1
fi
