# Reporte Semana 4 — Diseño sistemático de pruebas y oráculos (Petstore)

## 1) Objeto de prueba
Endpoint: `GET /api/v3/pet/{id}`.  
Motivación: el parámetro `{id}` permite diseñar casos sistemáticos (tipos, límites y valores extremos) y observar robustez/consistencia de manejo de errores.

## 2) Técnica de diseño utilizada
**Equivalencia (EQ) + Valores Límite (BV)** sobre `{id}`.

- EQ: particiona el dominio del parámetro en clases relevantes (no numérico, numérico ≤ 0, numérico > 0).
- BV: ejercita puntos cercanos a los límites (−1/0/1) y valores extremos (IDs grandes).

La justificación es metodológica: se evita inventar casos ad-hoc y se hace explícito el criterio de selección de entradas.

## 3) Oráculos (mínimos vs estrictos)
Las reglas están en `design/oracle_rules.md`.

- **Oráculos mínimos (defendibles sin suponer datos):**
  - No HTML (evitar respuestas inesperadas tipo página web).
  - No 5xx (no fallas del servidor ante solicitudes controladas).
  - IDs inválidos (no numérico o ≤ 0) no deben retornar 200.
  - IDs numéricos > 0 deben retornar 200 o 404 (comportamiento permitido sin asumir existencia).
- **Oráculo estricto (opcional):**
  - Si retorna 200, el cuerpo debería incluir `"id"` (y idealmente concordar).

## 4) Cobertura afirmada (y lo que NO se afirma)
**Se afirma:**
- Cobertura sistemática de clases de entrada del parámetro `{id}` (EQ) y límites relevantes (BV).
- Evidencia reproducible por caso (código HTTP + cuerpo guardado) con decisión pass/fail bajo oráculo mínimo.

**No se afirma:**
- Correctitud funcional completa del recurso `pet` (depende de datos existentes).
- Seguridad, concurrencia ni performance en producción.
- Estabilidad temporal (requiere repetición controlada).

## 5) Amenazas a la validez (interno/constructo/externo)
- **Interna:** estado/datos del SUT pueden cambiar y afectar si un ID retorna 200 o 404.  
  *Mitigación:* usar oráculos que no dependan de existencia (permitir 200/404) o crear datos controlados antes de medir.
- **Constructo:** usar códigos HTTP como proxy de “robustez” no cubre otras dimensiones (seguridad, integridad).  
  *Mitigación:* declarar alcance del atributo evaluado (manejo de entradas y estabilidad de respuesta).
- **Externa:** resultados dependen del entorno (Docker/local, red, versión del SUT).  
  *Mitigación:* registrar entorno y repetir en otra máquina/instancia si se requiere generalización.

## 6) Evidencia
- Casos: `design/test_cases.md`
- Oráculos: `design/oracle_rules.md`
- Ejecución: `scripts/systematic_cases.sh`
- Evidencia: `evidence/week4/` (por caso + `results.csv` + `summary.txt`)
