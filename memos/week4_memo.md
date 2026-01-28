# Memo de Progreso - Semana 4

**Fecha**: 28/01/2026  \
**Equipo**: Equipo X  \
**Semana**: 4 de 8

## Objetivos de la semana
- Seleccionar un endpoint/función del SUT como objeto de prueba.
- Diseñar casos de prueba sistemáticos (EQ/BV o combinatoria) y definir reglas de oráculo.
- Implementar ejecución reproducible para generar evidencia versionada.
- Documentar el método y límites (validez) del diseño.

## Logros
- Endpoint seleccionado: `GET /api/v3/pet/{id}`.
- Reglas de oráculo definidas en `design/oracle_rules.md` (mínimas y estrictas).
- Casos sistemáticos (≥12) derivados de EQ/BV documentados en `design/test_cases.md`.
- Script de ejecución reproducible implementado: `scripts/systematic_cases.sh`.
- Evidencia organizada en `evidence/week4/` con resultados agregados y evidencia por caso.
- Reporte metodológico producido en `reports/week4_report.md`.

## Evidencia principal
- Oráculos: `design/oracle_rules.md`.
- Casos sistemáticos: `design/test_cases.md`.
- Ejecución: `scripts/systematic_cases.sh`.
- Evidencia: `evidence/week4/results.csv`, `evidence/week4/summary.txt`, `evidence/week4/<TC>_response.*`, `evidence/week4/RUNLOG.md`.
- Reporte: `reports/week4_report.md`.

## Retos y notas
- Variación por datos/estado del SUT: un ID positivo puede retornar 200 o 404 según existencia.
- Para evitar suposiciones, los oráculos mínimos permiten `(200, 404)` en IDs positivos.
- La regla OR6 se mantiene como “estricta” y se reporta como nota, no como condición mínima.

## Lecciones aprendidas
- Un diseño sistemático (EQ/BV) hace explícitos los supuestos y reduce arbitrariedad.
- Separar oráculos mínimos vs estrictos ayuda a mantener falsabilidad sin depender de datos no controlados.
- Evidencia por caso + resultados agregados facilitan revisión y auditoría.

## Próximos pasos (Semana 5) - (Potenciales pasos, a ser discutidos con el equipo)
- Integrar el diseño sistemático con priorización por riesgo (Semana 3) y ampliar cobertura por atributos.
- Introducir criterios de estabilidad (repetición) para casos críticos y evaluar flakiness.
- Definir criterios de salida (exit criteria) para cada atributo de calidad priorizado.

---

**Preparado por**: Equipo X  \
**Próxima revisión**: Semana 5
