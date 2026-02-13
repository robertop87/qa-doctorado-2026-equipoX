#!/usr/bin/env bash
set -euo pipefail

BASELINE_FILE="ci/gate_integrity_baseline.txt"

if [[ ! -f "${BASELINE_FILE}" ]]; then
  echo "❌ No existe ${BASELINE_FILE}. No se puede verificar integridad del gate."
  exit 2
fi

echo "== Verificación de integridad del Quality Gate =="
echo "Baseline: ${BASELINE_FILE}"

FAIL=0
while IFS= read -r line; do
  [[ -z "${line}" ]] && continue
  [[ "${line}" =~ ^# ]] && continue

  expected_hash="$(echo "${line}" | awk '{print $1}')"
  file_path="$(echo "${line}" | awk '{print $2}')"

  if [[ ! -f "${file_path}" ]]; then
    echo "❌ Falta archivo: ${file_path}"
    FAIL=1
    continue
  fi

  actual_hash="$(sha256sum "${file_path}" | awk '{print $1}')"

  if [[ "${expected_hash}" != "${actual_hash}" ]]; then
    echo "❌ Hash distinto: ${file_path}"
    echo "   esperado: ${expected_hash}"
    echo "   actual:   ${actual_hash}"
    FAIL=1
  else
    echo "✅ OK: ${file_path}"
  fi
done < "${BASELINE_FILE}"

if [[ "${FAIL}" -ne 0 ]]; then
  echo ""
  echo "➡️  El gate detectó cambios en artefactos protegidos."
  echo "   Si el cambio es intencional, actualiza el baseline y registra el cambio en ci/gate_change_log.md."
  exit 3
fi

echo "✅ Integridad verificada."
