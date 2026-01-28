# Reglas de Oráculo — Semana 4 (Petstore)

**Objeto de prueba:** `GET /api/v3/pet/{id}`

Estas reglas definen criterios **pass/fail** para evaluar casos sistemáticos.  
Se distinguen reglas **mínimas** (seguras, poco asumidas) y reglas **estrictas** (cuando aplique).

## Reglas mínimas (aplican a todos los casos)

- **OR1 (Registro):** cada ejecución debe registrar `http_code` y guardar el cuerpo de respuesta como evidencia.
- **OR2 (No HTML):** la respuesta **no** debe ser HTML (si el primer carácter no vacío es `<`, se considera fallo del oráculo).
- **OR3 (No 5xx):** la respuesta no debe retornar **5xx**. (5xx implica fallo del servicio ante la solicitud).

## Reglas por partición (EQ)

- **OR4 (ID inválido no aceptado):** si `{id}` es **no numérico** o numérico **≤ 0**, entonces `http_code != 200`.
- **OR5 (ID numérico positivo — comportamiento permitido):** si `{id}` es numérico **> 0**, entonces `http_code` debe estar en `{200, 404}`.

## Reglas estrictas (opcional / reportar como “estrictas”)

- **OR6 (Consistencia semántica cuando hay 200):** si `http_code == 200` para `{id}` numérico, el cuerpo debería incluir un campo `"id"` (idealmente con el mismo valor).  
  > Nota: se reporta como chequeo estricto porque depende de datos/estado del SUT.
