#!/usr/bin/env bash
# Script de Captura de Inventario para Pet Store
# 
# Escenario Q4: Respuesta "bien formada" en inventario (Data Shape Sanity)
# 
# Este script atiende al escenario Q4 capturando el inventario de la tienda
# y validando que sea una respuesta JSON bien formada.
#
# Estímulo: se solicita GET /store/inventory
# Entorno: ejecución local, sin carga, 1 vez
# Respuesta: el cuerpo es JSON (no HTML / texto inesperado)
# Medida (falsable): el cuerpo comienza con '{' y el request devuelve HTTP 200
# Evidencia: evidence/week2/inventory.json y evidence/week2/inventory_http_code.txt
#
# Los resultados se guardan en evidence/week2/

set -euo pipefail

echo "📦 Escenario Q4: Respuesta Bien Formada en Inventario"
echo "====================================================="
echo ""

# Configuración
OUTPUT_DIR="evidence/week2"
BASE_URL="http://localhost:8080/api/v3"
INVENTORY_FILE="${OUTPUT_DIR}/inventory.json"
HTTP_CODE_FILE="${OUTPUT_DIR}/inventory_http_code.txt"

echo "Configuración:"
echo "  - URL Base: ${BASE_URL}"
echo "  - Endpoint: /store/inventory"
echo "  - Directorio de salida: ${OUTPUT_DIR}"
echo ""

# Crear directorio de evidencias si no existe
mkdir -p "${OUTPUT_DIR}"

# ===== Captura del Inventario =====
echo "🔄 Capturando inventario de tienda..."

code=$(curl -s -o "${INVENTORY_FILE}" -w "%{http_code}" "${BASE_URL}/store/inventory")
echo "${code}" > "${HTTP_CODE_FILE}"

# ===== Validación de Formato JSON =====
echo "🔎 Validando formato JSON..."

# Verificar que el archivo comienza con '{'
first_char=$(head -c 1 "${INVENTORY_FILE}")

if [ "${first_char}" != "{" ]; then
    echo "   ❌ ERROR: El archivo no comienza con '{'  (primer carácter: '${first_char}')"
    exit 1
fi

echo "   ✓ Archivo comienza con '{' (JSON válido)"

echo ""
echo "================================"
echo "📊 Resultados de Validación"
echo "================================"
echo "Código HTTP: ${code}"
echo "Formato JSON: Válido (comienza con '{')"
echo "Validación oráculo: HTTP ${code} + JSON bien formado"

if [ "${code}" = "200" ]; then
    echo ""
    echo "✅ ÉXITO: El inventario es accesible y bien formado"
    echo ""
    echo "📁 Archivos generados:"
    echo "   - ${INVENTORY_FILE}"
    echo "   - ${HTTP_CODE_FILE}"
else
    echo ""
    echo "❌ FALLO: Se esperaba HTTP 200, se recibió HTTP ${code}"
    exit 1
fi
