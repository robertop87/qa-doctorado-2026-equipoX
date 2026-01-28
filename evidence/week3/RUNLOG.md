# RUNLOG — Semana 3

**Fecha**: 2026-01-31 (referencial)  
**SUT**: Swagger Petstore (Docker local)  
**Objetivo**: recopilar evidencia para los Top 3 riesgos (R1–R3) definidos en `risk/risk_matrix.csv`.

## Comandos ejecutados (reproducibles)
> Nota: Los scripts del repositorio generan evidencia en `evidence/week2/`. Para mantener trazabilidad semanal,
> en Semana 3 se **copiaron** los artefactos generados hacia `evidence/week3/` (misma ejecución, distinta carpeta).

1) Disponibilidad del contrato (Q1 / Riesgo R1)
- Comando: `./scripts/capture_contract.sh`
- Oráculo: HTTP 200 y contiene `"openapi"`
- Artefactos: `openapi.json`, `openapi_http_code.txt`

2) Robustez ante inputs inválidos (Q3 / Riesgo R2)
- Comando: `./scripts/invalid_inputs.sh`
- Oráculo: ningún caso retorna HTTP 200
- Artefactos: `invalid_ids.csv`, `invalid_pet_*.json`

3) Baseline de latencia local (Q2 / Riesgo R3)
- Comando: `./scripts/measure_latency.sh 30`
- Oráculo: registrar `time_total` (y verificar que responde 200 durante mediciones)
- Artefactos: `latency.csv`, `latency_summary.txt`

## Copia a carpeta de semana
- Acción: `cp -r evidence/week2/* evidence/week3/`
- Motivo: trazabilidad de entregables por semana (sin cambiar scripts en este ejemplo).
