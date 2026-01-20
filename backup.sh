#!/bin/bash
echo "--- INICIANDO BACKUP (MODO REEMPLAZO) ---"

# 1. Definir un nombre fijo (Sin fecha) para que siempre sea el mismo archivo
NOMBRE_ZIP="server_backup_actual.tar.gz"

# 2. Comprimir el servidor
echo "> Creando paquete de archivos..."
tar -czf "$NOMBRE_ZIP" --exclude=".git" --exclude="$NOMBRE_ZIP" .

# 3. Subir a Google Drive
# Al usar el mismo nombre, rclone sobrescribirá el archivo anterior en Drive
echo "> Actualizando backup en la nube..."
if rclone copyto "$NOMBRE_ZIP" gdrive:BackupsServer/server_backup_actual.tar.gz; then
    echo "--- ¡BACKUP ACTUALIZADO CON ÉXITO! ---"
    # 4. Borrar el temporal local
    rm "$NOMBRE_ZIP"
else
    echo "xxx ERROR: No se pudo subir el backup xxx"
fi