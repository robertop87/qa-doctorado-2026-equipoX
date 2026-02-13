#!/usr/bin/env bash
set -euo pipefail

WEEK6_DIR="evidence/week6"
BEFORE_DIR="${WEEK6_DIR}/before"
AFTER_DIR="${WEEK6_DIR}/after"
mkdir -p "${BEFORE_DIR}" "${AFTER_DIR}"

RUNLOG="${WEEK6_DIR}/RUNLOG.md"
SUMMARY="${WEEK6_DIR}/summary.txt"

ORIGINAL="scripts/systematic_cases.sh"
BACKUP="${WEEK6_DIR}/systematic_cases.sh.bak"
CHEAT="${WEEK6_DIR}/systematic_cases_cheat.sh"

# --- cheat script: generate 'PASS' evidence without exercising the SUT ---
cat > "${CHEAT}" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
OUT_DIR="evidence/week4"
mkdir -p "${OUT_DIR}"
# Evidencia engañosa: resultados "PASS" sin llamadas al SUT
cat > "${OUT_DIR}/results.csv" <<CSV
test_case,http_code,pass,notes
TC01,200,true,cheat
TC02,200,true,cheat
TC03,200,true,cheat
TC04,200,true,cheat
TC05,200,true,cheat
TC06,200,true,cheat
TC07,200,true,cheat
TC08,200,true,cheat
TC09,200,true,cheat
TC10,200,true,cheat
TC11,200,true,cheat
TC12,200,true,cheat
CSV
echo "CHEAT: systematic_cases bypass" > "${OUT_DIR}/summary.txt"
echo "⚠️  CHEAT: evidencia generada sin ejecutar el SUT."
EOF
chmod +x "${CHEAT}"

{
  echo "# RUNLOG - Semana 6 (Gaming Drill)"
  echo ""
  echo "- Fecha: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
  echo "- Comando: ci/run_gate_gaming_drill.sh"
  echo ""
  echo "## Táctica"
  echo "- Reemplazo temporal de scripts/systematic_cases.sh por un script que genera evidencia 'PASS' sin ejecutar el SUT."
  echo ""
} > "${RUNLOG}"

# Backup original
cp -f "${ORIGINAL}" "${BACKUP}"

echo "## BEFORE: gate sin verificación de integridad" >> "${RUNLOG}"
echo "- Acción: aplicar cheat y ejecutar gate legacy (week5)" >> "${RUNLOG}"

# Apply cheat
cp -f "${CHEAT}" "${ORIGINAL}"

set +e
./ci/legacy/run_quality_gate_week5.sh > "${BEFORE_DIR}/gate_output.txt" 2>&1
BEFORE_RC=$?
set -e

# Collect key evidence (even if scripts did not run fully)
cp -f evidence/week5/SUMMARY.md "${BEFORE_DIR}/SUMMARY.md" 2>/dev/null || true
cp -f evidence/week4/summary.txt "${BEFORE_DIR}/systematic_summary.txt" 2>/dev/null || true
cp -f evidence/week4/results.csv "${BEFORE_DIR}/systematic_results.csv" 2>/dev/null || true

echo "- Resultado (rc=${BEFORE_RC}). Revisar BEFORE_DIR." >> "${RUNLOG}"

echo "## AFTER: gate con verificación de integridad" >> "${RUNLOG}"
echo "- Acción: intentar el mismo cheat y ejecutar gate actual (debe detectar)" >> "${RUNLOG}"

set +e
./ci/run_quality_gate.sh > "${AFTER_DIR}/gate_output.txt" 2>&1
AFTER_RC=$?
set -e

# Restore original script no matter what
cp -f "${BACKUP}" "${ORIGINAL}"

# Collect output
cp -f evidence/week5/SUMMARY.md "${AFTER_DIR}/SUMMARY.md" 2>/dev/null || true

{
  echo "Semana 6 — Resultado del Gaming Drill"
  echo ""
  echo "BEFORE (sin integridad): rc=${BEFORE_RC}"
  echo "- Esperado: el gate puede completar/parecer exitoso aunque la evidencia de systematic cases sea engañosa."
  echo ""
  echo "AFTER (con integridad): rc=${AFTER_RC}"
  echo "- Esperado: el gate detecta cambio en artefactos protegidos y falla (anti-gaming)."
  echo ""
  echo "Evidencia:"
  echo "- ${BEFORE_DIR}/systematic_summary.txt"
  echo "- ${AFTER_DIR}/gate_output.txt"
} > "${SUMMARY}"

echo "✅ Gaming drill completado. Ver evidencia en ${WEEK6_DIR}/"
exit 0
