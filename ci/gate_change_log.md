# Gate Change Log

Registro breve y auditable de cambios del Quality Gate (Semana 5+) y su gobernanza.

## 2026-02-13 — Semana 6: Integridad del gate (anti-gaming)
- Cambio: se agrega verificación de integridad (`ci/verify_gate_integrity.sh`) basada en hashes (`ci/gate_integrity_baseline.txt`).
- Motivo: mitigar *gaming* (Goodhart) por modificación silenciosa de casos/oráculos/scripts.
- Impacto esperado: el gate falla si se alteran artefactos protegidos sin actualizar baseline y registrar el cambio.
- Evidencia: `evidence/week6/after/` (el intento de bypass queda detectado).
