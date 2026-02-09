# Quality Gate (Semana 5)

## Propósito
Ejecutar un conjunto **mínimo y confiable** de chequeos automatizados en cada cambio para reducir incertidumbre sobre los **riesgos priorizados** (Semana 3) usando oráculos y casos sistemáticos (Semana 4).
Este gate **no** pretende certificar “calidad total”, sino entregar **evidencia reproducible** y frenar regresiones obvias.

## Checks del gate (3–5)
1) **Contrato disponible (OpenAPI)**
- Claim: el SUT expone su contrato.
- Evidencia: `evidence/week5/openapi.json` y `evidence/week5/openapi_http_code.txt`
- Oráculo: HTTP 200 y el JSON contiene la clave `"openapi"`.
- Relación: `risk/test_strategy.md` (disponibilidad/contrato).

2) **Inventario responde con JSON válido**
- Claim: endpoint clave responde de forma bien formada.
- Evidencia: `evidence/week5/inventory.json` y `evidence/week5/inventory_http_code.txt`
- Oráculo: HTTP 200 y cuerpo JSON bien formado.
- Relación: escenarios Semana 2 / robustez operativa.

3) **Robustez ante entradas inválidas**
- Claim: entradas inválidas no deben ser aceptadas como válidas.
- Evidencia: `evidence/week5/invalid_ids.csv` + respuestas `evidence/week5/invalid_pet_*.json`
- Oráculo: para cada caso, `http_code != 200`.
- Relación: `design/oracle_rules.md` (oráculo mínimo).

4) **Casos sistemáticos (Semana 4)**
- Claim: conjunto sistemático derivado por método, evaluado con oráculos explícitos.
- Evidencia: `evidence/week5/systematic_results.csv` y `evidence/week5/systematic_summary.txt`
- Oráculo: el script produce resumen y evidencia; cualquier `FAIL` requiere explicación/acción del equipo.
- Relación: `design/test_cases.md` y `design/oracle_rules.md`.

## Alta señal / bajo ruido (confiabilidad)
- El gate debe preferir checks **deterministas** (códigos HTTP, JSON bien formado, oráculos explícitos).
- Evitar depender de métricas sensibles al entorno (p. ej., umbrales estrictos de latencia) como criterio de fallo.
- Mantener evidencia trazable: **riesgo → escenario → evidencia → oráculo**.

## Cómo ejecutar localmente (equivalente a CI)
- `make quality-gate` (genera `evidence/week5/`).
