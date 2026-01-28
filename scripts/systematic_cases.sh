#!/usr/bin/env bash
set -euo pipefail

# Semana 4 — Ejecución sistemática de casos para Petstore
# Endpoint objetivo: GET /api/v3/pet/{id}
#
# Requisitos:
# - SUT corriendo localmente (por defecto): http://localhost:8080
# - curl disponible
#
# Uso:
#   ./scripts/systematic_cases.sh
#   BASE_URL=http://localhost:8080 ./scripts/systematic_cases.sh
#
# Salidas:
# - evidence/week4/results.csv
# - evidence/week4/summary.txt
# - evidence/week4/<TC_ID>_response.(json|txt)
# - evidence/week4/RUNLOG.md (si no existe, se crea)

BASE_URL="${BASE_URL:-http://localhost:8080}"
API_BASE="${BASE_URL%/}/api/v3"
OUT_DIR="evidence/week4"

mkdir -p "${OUT_DIR}"

# Crear RUNLOG si no existe
if [[ ! -f "${OUT_DIR}/RUNLOG.md" ]]; then
  cat > "${OUT_DIR}/RUNLOG.md" <<EOF
# RUNLOG — Semana 4

- Fecha/Hora: $(date -Iseconds)
- Comando: \`BASE_URL=${BASE_URL} ./scripts/systematic_cases.sh\`
- Endpoint: \`GET /api/v3/pet/{id}\`
- Oráculos: ver \`design/oracle_rules.md\`
EOF
fi

RESULTS="${OUT_DIR}/results.csv"
echo "tc_id,input_id,partition,http_code,oracle_pass,notes,response_file" > "${RESULTS}"

# Helper: trim leading whitespace and get first char
first_non_ws_char() {
  # prints first non-whitespace character (or empty)
  local file="$1"
  python3 - <<'PY' "$file"
import sys, pathlib, re
p=pathlib.Path(sys.argv[1])
s=p.read_text(errors="ignore")
m=re.search(r"\S", s)
print(s[m.start()] if m else "")
PY
}

# Apply minimal oracles based on partition
# OR1: logged
# OR2: no HTML (first non-ws char != '<')
# OR3: no 5xx
# OR4: invalid (P1/P2) => http_code != 200
# OR5: valid numeric positive (P3) => http_code in {200,404}
run_case() {
  local tc_id="$1"
  local input_id="$2"
  local partition="$3"

  local url="${API_BASE}/pet/${input_id}"
  local resp_file="${OUT_DIR}/${tc_id}_response.json"

  # Capture body + http code
  local http_code
  http_code=$(curl -s -o "${resp_file}" -w "%{http_code}" "${url}" || true)

  local notes=""
  local pass="true"

  # OR2: no HTML
  local c
  c=$(first_non_ws_char "${resp_file}")
  if [[ "${c}" == "<" ]]; then
    pass="false"
    notes="${notes}OR2_fail_html;"
    # rename to .txt to reflect non-json content
    mv "${resp_file}" "${OUT_DIR}/${tc_id}_response.txt"
    resp_file="${OUT_DIR}/${tc_id}_response.txt"
  fi

  # OR3: no 5xx
  if [[ "${http_code}" =~ ^5 ]]; then
    pass="false"
    notes="${notes}OR3_fail_5xx;"
  fi

  # Partition-specific
  if [[ "${partition}" == "P1" || "${partition}" == "P2" ]]; then
    # OR4
    if [[ "${http_code}" == "200" ]]; then
      pass="false"
      notes="${notes}OR4_fail_invalid_200;"
    fi
  elif [[ "${partition}" == "P3" ]]; then
    # OR5
    if [[ "${http_code}" != "200" && "${http_code}" != "404" ]]; then
      pass="false"
      notes="${notes}OR5_fail_unexpected_code;"
    fi
    # OR6 (estricta): si 200, reportar si no hay "id"
    if [[ "${http_code}" == "200" ]]; then
      if ! grep -q "\"id\"" "${resp_file}" 2>/dev/null; then
        notes="${notes}OR6_strict_missing_id;"
      fi
    fi
  fi

  echo "${tc_id},${input_id},${partition},${http_code},${pass},${notes},${resp_file}" >> "${RESULTS}"
}

# Casos (deben corresponder a design/test_cases.md)
run_case "TC01" "abc" "P1"
run_case "TC02" "1.5" "P1"
run_case "TC03" "-1" "P2"
run_case "TC04" "0" "P2"
run_case "TC05" "1" "P3"
run_case "TC06" "2" "P3"
run_case "TC07" "999999" "P3"
run_case "TC08" "2147483647" "P3"
run_case "TC09" "0001" "P3"
run_case "TC10" "01" "P3"
run_case "TC11" "-2147483648" "P2"
run_case "TC12" "999999999" "P3"

# Summary
total=$(tail -n +2 "${RESULTS}" | wc -l | tr -d ' ')
passed=$(tail -n +2 "${RESULTS}" | awk -F',' '$5=="true"{c++} END{print c+0}')
failed=$(( total - passed ))

cat > "${OUT_DIR}/summary.txt" <<EOF
Semana 4 — Resumen de ejecución sistemática
- Total casos: ${total}
- Pass (oráculo mínimo): ${passed}
- Fail (oráculo mínimo): ${failed}

Archivos:
- results.csv: matriz por caso (código, pass/fail, notas)
- <TC>_response.*: evidencia por caso
EOF

echo "[OK] Semana 4: evidencia generada en ${OUT_DIR}"
