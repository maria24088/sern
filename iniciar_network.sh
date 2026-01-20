#!/bin/bash
echo "--- INICIANDO LA NETWORK (MODO 16GB) ---"

# Parámetro de Zona Horaria
TIMEZONE="-Duser.timezone=America/Argentina/Buenos_Aires"

# 1. Iniciar PROXY (Velocity)
echo "> Encendiendo Velocity (Proxy)..."
cd Proxy
java $TIMEZONE -Xms1G -Xmx1G -jar velocity.jar > log.txt 2>&1 &
PID_PROXY=$!
cd ..

# 2. Iniciar LOBBY
echo "> Encendiendo Lobby..."
cd Lobby
java $TIMEZONE -Xms1G -Xmx1G -jar paper.jar --nogui > log.txt 2>&1 &
PID_LOBBY=$!
cd ..

# 3. Iniciar SURVIVAL
echo "> Encendiendo Survival..."
echo "> NOTA: Escribe 'stop' aquí para apagar toda la network."
cd Survival
# Aquí aplicamos el parámetro a "la bestia"
java $TIMEZONE -Xms6G -Xmx6G -jar paper.jar --nogui

# Apagado
echo "--- APAGANDO EL RESTO DE LA NETWORK ---"
kill $PID_PROXY
kill $PID_LOBBY
echo "Todo apagado correctamente."