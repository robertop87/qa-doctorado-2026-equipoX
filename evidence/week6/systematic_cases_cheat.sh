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
