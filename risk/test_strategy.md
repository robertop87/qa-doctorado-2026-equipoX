# Estrategia de Pruebas Basada en Riesgo (Semana 3)

## Propósito
Aplicar *risk-based testing* para reducir incertidumbre de calidad con tiempo limitado. La estrategia prioriza riesgos de mayor severidad (impacto × probabilidad) y exige trazabilidad **Riesgo → Escenario → Evidencia → Oráculo**, dejando explícito el **riesgo residual**.

## Alcance (por ahora)
**Cubre:**
- Disponibilidad mínima del contrato OpenAPI (Q1).
- Robustez ante entradas inválidas en `/pet/{id}` (Q3).
- Baseline de latencia local en `/store/inventory` (Q2).

**No cubre todavía:**
- Seguridad (authz/authn), pruebas de carga concurrente, ni SLOs de producción.
- Persistencia/datos, consistencia funcional completa de todos los endpoints.

## Top 3 riesgos priorizados (matriz: `risk/risk_matrix.csv`)
| Riesgo (ID) | Por qué es Top | Escenario | Evidencia (Semana 3) | Oráculo mínimo | Riesgo residual |
|---|---|---|---|---|---|
| R1: Contrato OpenAPI no accesible | Sin contrato no hay consumo; bloquea validación temprana | Q1 | `evidence/week3/openapi.json` + `openapi_http_code.txt` | pass si HTTP 200 y contiene `"openapi"` | No garantiza disponibilidad sostenida (solo “punto en el tiempo”) |
| R2: Inputs inválidos aceptados como válidos | Puede ocultar defectos y generar estados incoherentes | Q3 | `evidence/week3/invalid_ids.csv` + `invalid_pet_*.json` | pass si **ningún** caso retorna HTTP 200 | No valida semántica completa del error (400 vs 404), solo “no 200” |
| R3: Latencia local alta/variable | Riesgo probable por entorno local; afecta baseline y comparabilidad | Q2 | `evidence/week3/latency.csv` + `latency_summary.txt` | pass si HTTP 200 en mediciones; (umbral opcional p95<=X) | No generaliza a producción; no evalúa concurrencia |

## Reglas de evidencia (disciplina mínima)
- Toda evidencia de la semana se guarda en `evidence/week3/` y se documenta en `evidence/week3/RUNLOG.md`.
- Cada evidencia debe indicar **cómo se generó** (script/comando) y su **oráculo** (pass/fail).
- Si un script escribe en otra carpeta (p.ej. `week2`), se permite copiar a `week3` siempre que quede registrado en `RUNLOG.md`.

## Riesgo residual (declaración)
Aun mitigando R1–R3, persiste riesgo en seguridad, estabilidad bajo carga, y validez externa (entorno local). Este riesgo residual se acepta en esta etapa porque el objetivo del módulo es construir evidencia **reproducible y defendible** sobre escenarios básicos, antes de ampliar alcance o introducir concurrencia/entornos controlados.

## Validez (amenazas y límites)
- **Interna:** warm-up/estado del contenedor puede sesgar latencia → mitigar descartando primeras corridas o reiniciando.
- **Constructo:** `time_total` local es proxy; no equivale a rendimiento de producción → declarar alcance “baseline local”.
- **Externa:** hardware/red/configuración Docker varían entre equipos → registrar entorno y evitar generalización fuerte.
