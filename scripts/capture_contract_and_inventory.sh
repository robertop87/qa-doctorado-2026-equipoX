#!/usr/bin/env bash
set -euo pipefail

mkdir -p evidence/week2
base="http://localhost:8080/api/v3"

# OpenAPI
code=$(curl -s -o evidence/week2/openapi.json -w "%{http_code}" "${base}/openapi.json")
echo "${code}" > evidence/week2/openapi_http_code.txt
grep -q "\"openapi\"" evidence/week2/openapi.json

# Inventario
code2=$(curl -s -o evidence/week2/inventory.json -w "%{http_code}" "${base}/store/inventory")
echo "${code2}" > evidence/week2/inventory_http_code.txt
head -c 1 evidence/week2/inventory.json | grep -q "{"

echo "[OK] Contrato + Inventario capturado"
