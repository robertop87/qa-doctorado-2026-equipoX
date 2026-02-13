# Semana 6 — Gaming Drill del Quality Gate (Goodhart) + Endurecimiento

## Táctica de gaming elegida (ejemplo)
**Táctica:** "Debilitar la evidencia sin declararlo” mediante reemplazo de `scripts/systematic_cases.sh` para que genere resultados "PASS" sin ejecutar casos reales.

**Por qué es plausible:** si el gate solo revisa que existe evidencia y no verifica integridad, un cambio pequeño puede mantener el gate "verde" sin mejorar calidad.

## Qué demuestra este drill
- **Before:** con un gate sin verificación de integridad, el bypass puede "pasar” (señal engañosa).
- **After:** con verificación de integridad, el bypass queda **detectado** y el gate falla.

## Cómo ejecutar (local)
1) Asegúrate de tener Docker y `make`.
2) Ejecuta:
   - `make gaming-drill`
3) Revisa:
   - `evidence/week6/before/`
   - `evidence/week6/after/`
   - `evidence/week6/summary.txt`

## Artefactos protegidos por integridad (baseline)
- `scripts/systematic_cases.sh`
- `design/oracle_rules.md`
- `design/test_cases.md`

> Si se cambian intencionalmente, actualizar `ci/gate_integrity_baseline.txt` y registrar el cambio en `ci/gate_change_log.md`.
