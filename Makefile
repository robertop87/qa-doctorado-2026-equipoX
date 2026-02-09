# Makefile para el Proyecto QA Doctorado

.PHONY: help setup start-petstore stop-petstore healthcheck smoke Q1-contract Q2-latency Q3-invalid-inputs Q4-inventory QA-week2 clean systematic-cases quality-gate

# Objetivo por defecto
help:
	@echo "Objetivos disponibles:"
	@echo ""
	@echo "Configuración:"
	@echo "  setup          - Configurar el entorno"
	@echo "  start-petstore - Iniciar la aplicación Pet Store"
	@echo "  stop-petstore  - Detener la aplicación Pet Store"
	@echo "  healthcheck    - Verificar la salud del sistema"
	@echo ""
	@echo "Escenarios de Calidad - Semana 2:"
	@echo "  Q1-contract        - Escenario Q1: Disponibilidad mínima del contrato OpenAPI"
	@echo "  Q2-latency         - Escenario Q2: Latencia básica del endpoint de inventario"
	@echo "  Q3-invalid-inputs  - Escenario Q3: Robustez ante IDs inválidos"
	@echo "  Q4-inventory       - Escenario Q4: Respuesta bien formada en inventario"
	@echo "  QA-week2           - Ejecutar todos los escenarios Q1-Q4 de la semana 2"
	@echo ""
	@echo "Diseño sistemático - Semana 4:"
	@echo "  systematic-cases - Ejecutar casos sistemáticos (Semana 4) y generar evidencia"
	@echo ""
	@echo ""
	@echo "Quality Gate - Semana 5:"
	@echo "  quality-gate    - Ejecutar el quality gate (CI) y generar evidencia week5"
	@echo "Pruebas Legacy:"
	@echo "  smoke          - Ejecutar pruebas de humo"
	@echo ""
	@echo "Utilidades:"
	@echo "  clean          - Limpiar archivos temporales"

setup:
	@echo "Configurando entorno..."
	chmod +x setup/*.sh scripts/*.sh ci/*.sh
	./setup/run_sut.sh

start-petstore:
	./setup/run_sut.sh

stop-petstore:
	./setup/stop_sut.sh

healthcheck:
	./setup/healthcheck_sut.sh

smoke:
	./scripts/smoke.sh

Q1-contract:
	./scripts/capture_contract.sh

Q2-latency:
	./scripts/measure_latency.sh

Q3-invalid-inputs:
	./scripts/invalid_inputs.sh

Q4-inventory:
	./scripts/capture_inventory.sh

QA-week2: Q1-contract Q2-latency Q3-invalid-inputs Q4-inventory
	@echo ""
	@echo "================================"
	@echo "✅ Todos los escenarios Q1-Q4 completados"
	@echo "================================"

systematic-cases: healthcheck
	./scripts/systematic_cases.sh

quality-gate:
	./ci/run_quality_gate.sh

clean:
	rm -rf tmp/
	rm -f *.log
