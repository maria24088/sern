#!/bin/bash
echo "--- GUARDANDO PROGRESO EN GITHUB ---"

# 1. Añadir todos los archivos nuevos o modificados
git add .

# 2. Guardar con un mensaje automático con la fecha
FECHA=$(date +"%Y-%m-%d %H:%M")
git commit -m "Backup del servidor: $FECHA"

# 3. Subir a la nube
echo "> Subiendo archivos... (Esto puede tardar si el mundo pesa mucho)"
git push

echo "--- ¡TODO GUARDADO! ---"
