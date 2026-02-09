#!/bin/bash
# Script de Inicio de la Aplicación Pet Store

echo "Iniciando aplicación Pet Store..."

# Verificar si Docker está en ejecución
if ! docker info > /dev/null 2>&1; then
    echo "Docker no está en ejecución. Por favor inicia Docker primero."
    exit 1
fi

# Descargar y ejecutar el contenedor de Pet Store
echo "Descargando imagen de Pet Store..."
docker pull swaggerapi/petstore3:unstable

echo "Iniciando contenedor de Pet Store..."
if docker ps -a --format '{{.Names}}' | grep -q '^petstore$'; then
    echo "Contenedor existente 'petstore' detectado. Deteniéndolo y eliminándolo..."
    docker stop petstore >/dev/null 2>&1 || true
    docker rm petstore >/dev/null 2>&1 || true
fi
docker run -d --name petstore -p 8080:8080 swaggerapi/petstore3:unstable

# Esperar un momento para que el contenedor inicie
sleep 5

# Verificar si el contenedor está en ejecución
if docker ps | grep -q petstore; then
    echo "Pet Store iniciado exitosamente en http://localhost:8080"
    echo "Documentación de la API disponible en: http://localhost:8080"
else
    echo "Falló al iniciar Pet Store"
    exit 1
fi
