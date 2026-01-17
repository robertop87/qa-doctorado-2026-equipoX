#!/bin/bash
# Script de Verificación de Salud para la Aplicación Pet Store

echo "Realizando verificación de salud en la aplicación Pet Store..."

# Verificar si el contenedor de Docker está en ejecución
if ! docker ps | grep -q petstore; then
    echo "❌ El contenedor de Pet Store no está en ejecución"
    exit 1
fi

# Verificar si la aplicación está respondiendo
echo "Verificando salud de la aplicación..."
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/api/v3/openapi.json)

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ Pet Store está saludable y respondiendo"
    echo "📊 Estado de la aplicación: En ejecución"
    echo "🌐 Endpoint: http://localhost:8080"
    
    # Verificaciones adicionales
    echo "🔍 Estado del contenedor:"
    docker stats --no-stream petstore | tail -n 1
    
    exit 0
else
    echo "❌ Pet Store no está respondiendo (HTTP $HTTP_STATUS)"
    echo "🔧 Verificando logs del contenedor..."
    docker logs petstore --tail 10
    exit 1
fi