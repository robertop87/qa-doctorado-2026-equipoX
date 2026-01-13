#!/bin/bash
# Script de Detención de la Aplicación Pet Store

echo "Deteniendo aplicación Pet Store..."

# Detener y eliminar el contenedor de Pet Store
if docker ps | grep -q petstore; then
    echo "Deteniendo contenedor de Pet Store..."
    docker stop petstore
    echo "Eliminando contenedor de Pet Store..."
    docker rm petstore
    echo "Pet Store detenido exitosamente"
else
    echo "El contenedor de Pet Store no está en ejecución"
fi

# Limpiar imágenes huérfanas (opcional)
echo "Limpiando..."
docker image prune -f > /dev/null 2>&1

echo "Limpieza completada"