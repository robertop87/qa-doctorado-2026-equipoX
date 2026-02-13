#!/usr/bin/env bash
set -euo pipefail

# Semana 6: verificacion de integridad (anti-gaming / Goodhart)
./ci/verify_gate_integrity.sh

OUT_DIR="evidence/week5"
mkdir -p "${OUT_DIR}"

RUNLOG="${OUT_DIR}/RUNLOG.md"
{
  echo "# RUNLOG - Semana 5"
  echo ""
  echo "- Fecha: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
  echo "- Comando: ci/run_quality_gate.sh"
  echo ""
  echo "## Pasos ejecutados"
} > "${RUNLOG}"

echo "- Iniciar SUT (Docker)" >> "${RUNLOG}"
./setup/run_sut.sh

echo "- Healthcheck" >> "${RUNLOG}"
./setup/healthcheck_sut.sh

echo "- Capturar contrato (OpenAPI)" >> "${RUNLOG}"
./scripts/capture_contract.sh

echo "- Capturar inventario" >> "${RUNLOG}"
./scripts/capture_inventory.sh

echo "- Robustez: entradas inválidas" >> "${RUNLOG}"
./scripts/invalid_inputs.sh

echo "- Casos sistemáticos (Semana 4)" >> "${RUNLOG}"
./scripts/systematic_cases.sh

# Copiar evidencia generada por scripts existentes hacia week5 (sin modificar scripts)
cp -f evidence/week2/openapi.json "${OUT_DIR}/openapi.json"
cp -f evidence/week2/openapi_http_code.txt "${OUT_DIR}/openapi_http_code.txt"
cp -f evidence/week2/inventory.json "${OUT_DIR}/inventory.json"
cp -f evidence/week2/inventory_http_code.txt "${OUT_DIR}/inventory_http_code.txt"
cp -f evidence/week2/invalid_ids.csv "${OUT_DIR}/invalid_ids.csv"
cp -f evidence/week2/invalid_pet_*.json "${OUT_DIR}/" 2>/dev/null || true

cp -f evidence/week4/results.csv "${OUT_DIR}/systematic_results.csv"
cp -f evidence/week4/summary.txt "${OUT_DIR}/systematic_summary.txt"

SUMMARY="${OUT_DIR}/SUMMARY.md"
{
  echo "# Resumen - Semana 5 (Quality Gate)"
  echo ""
  echo "## Evidencia generada"
  echo "- Contrato: ${OUT_DIR}/openapi.json"
  echo "- Inventario: ${OUT_DIR}/inventory.json"
  echo "- Entradas inválidas: ${OUT_DIR}/invalid_ids.csv"
  echo "- Casos sistemáticos: ${OUT_DIR}/systematic_results.csv"
  echo ""
  echo "## Nota"
  echo "Este gate prioriza checks deterministas (alta señal / bajo ruido)."
} > "${SUMMARY}"

echo "" >> "${RUNLOG}"
echo "## Evidencia producida" >> "${RUNLOG}"
echo "- ${SUMMARY}" >> "${RUNLOG}"
echo "- ${OUT_DIR}/openapi.json" >> "${RUNLOG}"
echo "- ${OUT_DIR}/inventory.json" >> "${RUNLOG}"
echo "- ${OUT_DIR}/invalid_ids.csv" >> "${RUNLOG}"
echo "- ${OUT_DIR}/systematic_results.csv" >> "${RUNLOG}"

echo "✅ Quality gate completado. Evidencia en ${OUT_DIR}/"
