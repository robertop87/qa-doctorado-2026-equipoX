# Casos de prueba sistemáticos — Semana 4 (Petstore)

**Técnica usada:** Equivalencia (EQ) + Valores Límite (BV) sobre el parámetro `{id}` en `GET /api/v3/pet/{id}`.

## Particiones (EQ)
- **P1 (No numérico):** `{id}` contiene caracteres no numéricos (ej. `abc`, `1.5`).
- **P2 (Numérico ≤ 0):** `{id}` es numérico y no positivo (ej. `0`, `-1`).
- **P3 (Numérico > 0):** `{id}` es numérico positivo (ej. `1`, `2`, `999999`).

## Valores límite (BV) considerados
- Cercanos a 0: `-1`, `0`, `1`
- Entero grande típico: `2147483647`
- ID grande: `999999`

## Formato de evidencia
Cada caso genera:
- `evidence/week4/<TC_ID>_response.json` (o `.txt` si aplica)
- Registro agregado: `evidence/week4/results.csv` + `evidence/week4/summary.txt`

## Casos (≥ 12)
> Referencias a reglas: ver `design/oracle_rules.md`

| TC-ID | Input `{id}` | Partición | Expected (oráculo mínimo) | Evidencia esperada |
|---|---:|---|---|---|
| TC01 | `abc` | P1 | OR1, OR2, OR3, OR4 | `TC01_response.*` |
| TC02 | `1.5` | P1 | OR1, OR2, OR3, OR4 | `TC02_response.*` |
| TC03 | `-1` | P2 | OR1, OR2, OR3, OR4 | `TC03_response.*` |
| TC04 | `0` | P2 | OR1, OR2, OR3, OR4 | `TC04_response.*` |
| TC05 | `1` | P3 (BV) | OR1, OR2, OR3, OR5 | `TC05_response.*` |
| TC06 | `2` | P3 | OR1, OR2, OR3, OR5 | `TC06_response.*` |
| TC07 | `999999` | P3 (BV) | OR1, OR2, OR3, OR5 | `TC07_response.*` |
| TC08 | `2147483647` | P3 (BV) | OR1, OR2, OR3, OR5 | `TC08_response.*` |
| TC09 | `0001` | P3 (formato) | OR1, OR2, OR3, OR5 | `TC09_response.*` |
| TC10 | `01` | P3 (formato) | OR1, OR2, OR3, OR5 | `TC10_response.*` |
| TC11 | `-2147483648` | P2 (BV) | OR1, OR2, OR3, OR4 | `TC11_response.*` |
| TC12 | `999999999` | P3 | OR1, OR2, OR3, OR5 | `TC12_response.*` |

**Nota:** La regla OR6 puede reportarse como “estricta” (no obligatoria) cuando ocurra `http_code == 200`.
