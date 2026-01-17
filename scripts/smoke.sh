#!/bin/bash
# Suite de smoke test para la aplicación Pet Store

echo "Ejecutando smoke test para Pet Store..."

BASE_URL="http://localhost:8080/api/v3"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RESULTS_FILE="evidence/smoke_test_$TIMESTAMP.log"

# Crear directorio de resultados si no existe
mkdir -p evidence

# Función para probar un endpoint
test_endpoint() {
    local endpoint=$1
    local expected_status=$2
    local description=$3
    
    echo "Probando: $description"
    local status=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL$endpoint")
    
    if [ "$status" -eq "$expected_status" ]; then
        echo "✅ ÉXITO: $description (HTTP $status)"
        echo "EXITO: $description (HTTP $status)" >> "$RESULTS_FILE"
        return 0
    else
        echo "❌ FALLO: $description (Esperado $expected_status, obtenido $status)"
        echo "FALLO: $description (Esperado $expected_status, obtenido $status)" >> "$RESULTS_FILE"
        return 1
    fi
}

# Inicializar archivo de resultados
echo "Resultados de Pruebas de Humo - $TIMESTAMP" > "$RESULTS_FILE"
echo "================================" >> "$RESULTS_FILE"

# Suite de pruebas
TOTAL_TESTS=0
PASSED_TESTS=0

# Prueba 1: Especificación OpenAPI
test_endpoint "/openapi.json" 200 "Endpoint de Especificación OpenAPI"
RESULT=$?
TOTAL_TESTS=$((TOTAL_TESTS + 1))
if [ $RESULT -eq 0 ]; then
    PASSED_TESTS=$((PASSED_TESTS + 1))
fi

# Prueba 2: Obtener mascotas por estado
test_endpoint "/pet/findByStatus?status=available" 200 "Buscar mascotas por estado"
RESULT=$?
TOTAL_TESTS=$((TOTAL_TESTS + 1))
if [ $RESULT -eq 0 ]; then
    PASSED_TESTS=$((PASSED_TESTS + 1))
fi

# Prueba 3: Obtener inventario de tienda
test_endpoint "/store/inventory" 200 "Endpoint de inventario de tienda"
RESULT=$?
TOTAL_TESTS=$((TOTAL_TESTS + 1))
if [ $RESULT -eq 0 ]; then
    PASSED_TESTS=$((PASSED_TESTS + 1))
fi

# Prueba 4: Endpoint inválido (debería retornar 404)
test_endpoint "/invalid/endpoint" 404 "Endpoint inválido (prueba negativa)"
RESULT=$?
TOTAL_TESTS=$((TOTAL_TESTS + 1))
if [ $RESULT -eq 0 ]; then
    PASSED_TESTS=$((PASSED_TESTS + 1))
fi

# Resumen
echo ""
echo "================================"
echo "Resumen de Pruebas de Humo"
echo "Pruebas totales: $TOTAL_TESTS"
echo "Aprobadas: $PASSED_TESTS"
echo "Falladas: $((TOTAL_TESTS - PASSED_TESTS))"
echo "Tasa de éxito: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%"
echo "Resultados guardados en: $RESULTS_FILE"

# Resumen en archivo de resultados
echo "" >> "$RESULTS_FILE"
echo "RESUMEN: $PASSED_TESTS/$TOTAL_TESTS pruebas aprobadas" >> "$RESULTS_FILE"

if [ $PASSED_TESTS -eq $TOTAL_TESTS ]; then
    echo "✅ ¡Todas las pruebas de humo pasaron!"
    exit 0
else
    echo "❌ Algunas pruebas de humo fallaron"
    exit 1
fi
