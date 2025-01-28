#!/bin/bash

PORT="2022"

echo "Cliente Dragon Magia Abuelita Miedo 2022"

echo "1. INICIO DE CONEXIÓN"

echo "DMAM" | nc localhost $PORT

echo "4. ESPERANDO OK_HEADER"

RESPUESTA=`nc -l $PORT`

if [ "$RESPUESTA" != "OK_HEADER" ]
then
    echo "ERROR 1: HEADER INCORRECTO"
    exit 1
fi

echo "5. ENVIANDO NOMBRE DE ARCHIVO"

MD5SUM=`echo -n dragon.txt | md5sum`

echo -n "FILE_NAME dragon.txt $MD5SUM" | nc localhost $PORT

echo "9. ESPERANDO OK_ARCHIVO"

RESPUESTA=`nc -l $PORT`

if [ "$RESPUESTA" != "OK_FILE_NAME" ]
then
    echo "ERROR 4: EL MD5 NO SE HA ENVIADO CORRECTAMENTE"
    exit 2
fi

echo "10. ENVÍO DE ARCHIVO"

DRAGON=`cat dragon.txt`
MD5SUM=`echo -n "$DRAGON" | md5sum`

echo "$DRAGON" | nc localhost $PORT

echo "14. RECIBIENDO OK_DATA"

RESPUESTA=`nc -l $PORT`

if [ "$RESPUESTA" != "OK_DATA" ]
then
    echo "ERROR 6: EL DRAGON NO ES CORRECTO"
    exit 3
fi

echo "15. ENVIANDO MD5 ARCHIVO"

echo -n "FILE_MD5 $MD5SUM" | nc localhost $PORT

echo "20. RECIBIENDO OK_ARCHIVO_MD5"

RESPUESTA=`nc -l $PORT`

if [ "$RESPUESTA" != "OK_ARCHIVO_MD5" ]
then
    echo "ERROR 8: ARCHIVO MD5 INCORRECTO"
    exit 4
fi

echo "21. ARCHIVO ENVIADO CORRECTAMENTE, FIN DEL PROCESO"
exit 5