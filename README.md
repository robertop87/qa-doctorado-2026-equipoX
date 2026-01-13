# QA Doctorado 2026 - Equipo X

## Descripción del Proyecto

Este repositorio contiene todo el trabajo y documentación para el proyecto QA Doctorado 2026 del Equipo X.

## Estructura del Repositorio

- `setup/` - Scripts de configuración del entorno
- `scripts/` - Scripts de pruebas y mediciones
- `evidence/` - Recolección de evidencias semanales
- `quality/` - Escenarios de calidad y glosario
- `risk/` - Evaluación de riesgos y estrategia de pruebas
- `design/` - Diseño de casos de prueba y reglas de oráculo
- `ci/` - Configuración de integración continua
- `memos/` - Memorandums de progreso semanal
- `reports/` - Reportes de unidad
- `study/` - Materiales del estudio de investigación
- `paper/` - Paper final
- `slides/` - Materiales de presentación
- `peer_review/` - Materiales de revisión por pares

## Primeros Pasos

1. Ejecuta los scripts de configuración en `setup/`
2. Sigue los acuerdos en `AGREEMENTS.md`
3. Usa el Makefile para operaciones comunes

## Miembros del Equipo

- [Agregar nombres de los miembros del equipo aquí]

## Ejecución local del SUT

Requiere un entorno con docker instalado. [Instalación](https://docs.docker.com/engine/install)

### Arranque (reproducible)

```bash
docker pull swaggerapi/petstore3:unstable
docker run --name swaggerapi-petstore3 -d -p 8080:8080 swaggerapi/petstore3:unstable
```

### Verificación básica healthcheck

- URL: http://localhost:8080/api/v3/openapi.json
- Criterio de éxito: devuelve JSON y HTTP 200

```bash
curl http://localhost:8080/api/v3/openapi.json
```
