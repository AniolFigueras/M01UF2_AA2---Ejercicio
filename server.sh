#!/bin/bash

PORT="2022"

echo "Servidor Dragon Magia Abuelita Miedo 2022"

echo "0. ESPERANDO CONEXIÓN EN PUERTO 2022"

DATA=`nc -l $PORT`

echo "2. VERIFICANDO CABECERA"

if [ "$DATA" != "DMAM" ]
then
    echo "ERROR 1: HEADER INCORRECTO"
    echo "KO_HEADER" | nc localhost $PORT
    exit 1
fi

echo "3. RESPUESTA CORRECTA - Enviando OK_HEADER"

echo "OK_HEADER" | nc localhost $PORT

echo "6. PROCESANDO PREFERENCIAS DE ARCHIVO"

DATA=`nc -l $PORT`

PREFIJO=`echo "$DATA" | cut -d ' ' -f1`
ARCHIVO=`echo "$DATA" | cut -d ' ' -f3`
MD5SUMARCHIVO=`echo -n dragon.txt | md5sum`
MD5SUM=`echo "$MD5SUMARCHIVO" | cut -d ' ' -f1`

if [ "$PREFIJO" != "FILE_NAME" ]
then
    echo "ERROR 2: PREFIJO INCORRECTO"
    echo "KO_FILE_NAME" | nc localhost $PORT
    exit 2
fi

echo "7. COMPROBANDO EL MD5"

if [ "$MD5SUM" != "$ARCHIVO" ]
then
    echo "ERROR 3: MD5 INCORRECTO"
    echo "KO_FILE_NAME_MD5" | nc localhost $PORT
    exit 2
fi

echo "8. ENVIANDO OK_FILE_NAME"

echo "OK_FILE_NAME" | nc localhost $PORT

echo "11. RECIBIENDO ARCHIVO"
DATA=`nc -l $PORT > recibiendo_dragon.txt`

ARCHIVORECIBIDO=`cat recibiendo_dragon.txt`
COMPROBACIONARCHIVO=`cat dragon.txt`

echo "12. VERIFICANDO EL ARCHIVO"
if [ "$ARCHIVORECIBIDO" != "$COMPROBACIONARCHIVO" ]
then
    echo "ERROR 5: ARCHIVO ERRONEO"
    echo "KO_DATA" | nc localhost $PORT
    exit 4
fi

echo "13. ENVIANDO OK_DATA"

echo "OK_DATA" | nc localhost $PORT

echo "16. RECIBIENDO MD5 DEL ARCHIVO"

DATA=`nc -l $PORT`

PREFIJO=`echo "$DATA" | cut -d ' ' -f1`
MD5SUM=`echo "$DATA" | cut -d ' ' -f2`
PRIMERA_COMPROBACION=`echo -n "$COMPROBACIONARCHIVO" | md5sum`
SEGUNDA_COMPROBACION=`echo "$PRIMERA_COMPROBACION" | cut -d ' ' -f1`

echo "17. VERIFICANDO PREFIJO"

if [ "$PREFIJO" != "FILE_MD5" ]
then
    echo "ERROR 7: PREFIJO INCORRECTO"
    echo "KO_FILE_MD5" | nc localhost $PORT
    exit 5
fi

echo "18. VERIFICANDO MD5"

if [ "$MD5SUM" != "$SEGUNDA_COMPROBACION" ]
then
    echo "ERROR 7: MD5 ERRONEO"
    echo "KO_ARCHIVO_MD5" | nc localhost $PORT
    exit 6
fi

echo "19. RESPUESTA CORRECTA - ENVIANDO OK_ARCHIVO_MD5"

echo "OK_ARCHIVO_MD5" | nc localhost $PORT
exit 7