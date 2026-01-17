#!/usr/bin/env bash
# Script de Captura de Contrato e Inventario para Pet Store
# 
# Este script captura:
# - Especificación OpenAPI (contrato de la API)
# - Inventario actual de la tienda
#
# Los resultados se guardan en evidence/week2/

set -euo pipefail

echo "Capturando contrato e inventario de Pet Store..."
echo ""

# Crear directorio de evidencias si no existe
mkdir -p evidence/week2
base="http://localhost:8080/api/v3"

# ===== Captura de Especificación OpenAPI =====
echo "📄 Capturando especificación OpenAPI..."
code=$(curl -s -o evidence/week2/openapi.json -w "%{http_code}" "${base}/openapi.json")
echo "${code}" > evidence/week2/openapi_http_code.txt

# Verificar que el archivo contiene datos válidos de OpenAPI
grep -q "\"openapi\"" evidence/week2/openapi.json
echo "   ✓ Especificación OpenAPI capturada (HTTP $code)"

# ===== Captura de Inventario =====
echo "📦 Capturando inventario de tienda..."
code2=$(curl -s -o evidence/week2/inventory.json -w "%{http_code}" "${base}/store/inventory")
echo "${code2}" > evidence/week2/inventory_http_code.txt

# Verificar que el archivo contiene JSON válido
head -c 1 evidence/week2/inventory.json | grep -q "{"
echo "   ✓ Inventario capturado (HTTP $code2)"

echo ""
echo "================================"
echo "✅ Captura completada exitosamente"
echo ""
echo "📁 Archivos generados:"
echo "   - evidence/week2/openapi.json"
echo "   - evidence/week2/openapi_http_code.txt"
echo "   - evidence/week2/inventory.json"
echo "   - evidence/week2/inventory_http_code.txt"
