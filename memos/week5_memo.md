# Memo de Progreso - Semana 5

**Fecha**: 16/02/2026  \
**Equipo**: Equipo X  \
**Semana**: 5 de 8

## Objetivos de la semana
- Definir un **quality gate** alineado a riesgos priorizados (Semana 3).
- Implementar el gate en CI para ejecutar checks confiables y producir evidencia descargable.
- Mantener el gate con foco en **alta señal / bajo ruido** (evitar falsos positivos).

## Logros
- Documento del gate creado: `ci/quality_gates.md` (checks, oráculos y relación con riesgos/oráculos previos).
- Script de ejecución local del gate: `ci/run_quality_gate.sh` (genera `evidence/week5/`).
- Workflow de CI agregado: `.github/workflows/ci.yml` (ejecuta el gate en push/PR y publica artifacts).
- Makefile extendido con target `quality-gate` para reproducir localmente el flujo de CI.
- README actualizado con instrucciones y ubicación de evidencias.

## Evidencia principal
- Definición del gate: `ci/quality_gates.md`.
- Ejecución local del gate: `ci/run_quality_gate.sh` + `make quality-gate`.
- CI workflow: `.github/workflows/ci.yml`.
- Evidencia producida: `evidence/week5/` (artifact en CI).

## Retos y notas
- Se evitó usar latencia como criterio de fallo del gate para reducir ruido (variabilidad del entorno en CI).
- El gate prioriza checks deterministas basados en códigos HTTP, JSON bien formado y reglas de oráculo.

## Lecciones aprendidas
- Un gate útil es pequeño y confiable; si es ruidoso, pierde credibilidad y deja de usarse.
- Conectar gate a riesgos y oráculos existentes mejora trazabilidad y reduce discusiones subjetivas.

## Próximos pasos (Semana 6) - (Potenciales pasos, a ser discutidos con el equipo)
- Definir cómo reportar estabilidad del gate (sin introducir ruido).
- Revisar criterios de aceptación por iteración y declaración de riesgo residual.

---

**Preparado por**: Equipo X  \
**Próxima revisión**: Semana 6
