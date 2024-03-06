#!/bin/bash

# Variables de configuración
COUNTRY="ES"
COUNTRY_SERVER="EN"
COUNTRY_PRODUCER="FR"
COUNTRY_CONSUMER="IT"
STATE="Alava"
STATE_SERVER="London"
STATE_PRODUCER="Paris"
STATE_CONSUMER="Roma"
LOCALITY="Vitoria"
LOCALITY_SERVER="London"
LOCALITY_PRODUCER="Paris"
LOCALITY_CONSUMER="Roma"
ORGANIZATION="Deusto"
ORGANIZATION_SERVER="Oxford"
ORGANIZATION_PRODUCER="Carrefour"
ORGANIZATION_CONSUMER="Ferrari"
COMMON_NAME_CA="172.20.207.7"
COMMON_NAME_SERVER="172.20.207.7"
COMMON_NAME_PRODUCER="172.20.207.7"
COMMON_NAME_CONSUMER="172.20.207.7"

# Entrar a la carpeta en la que se encuentran los certificados
cd mqtt_certs

# Asignación de SAN
SAN="IP:172.20.207.7"

# Generar la CA
echo "Generando CA..."
openssl req -new -x509 -days 3650 -extensions v3_ca -keyout ca.key -out ca.crt -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITY/O=$ORGANIZATION/CN=$COMMON_NAME_CA" -nodes -addext "subjectAltName=$SAN"

# Generar el certificado y la clave del servidor con SAN
echo "Generando certificado del servidor con SAN..."
openssl req -new -nodes -out server.csr -keyout server.key -subj "/C=$COUNTRY_SERVER/ST=$STATE_SERVER/L=$LOCALITY_SERVER/O=$ORGANIZATION_SERVER/CN=$COMMON_NAME_SERVER" -addext "subjectAltName=$SAN"

# Firmar el CSR con la CA, incluyendo SAN
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365

# Generar el certificado y la clave del productor con SAN
echo "Generando certificado del productor con SAN..."
openssl req -new -nodes -out producer.csr -keyout producer.key -subj "/C=$COUNTRY_PRODUCER/ST=$STATE_PRODUCER/L=$LOCALITY_PRODUCER/O=$ORGANIZATION_PRODUCER/CN=$COMMON_NAME_PRODUCER" -addext "subjectAltName=$SAN"
# Firmar el CSR con la CA, incluyendo SAN
openssl x509 -req -in producer.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out producer.crt -days 365

# Generar el certificado y la clave del consumidor con SAN
echo "Generando certificado del consumidor con SAN..."
openssl req -new -nodes -out consumer.csr -keyout consumer.key -subj "/C=$COUNTRY_CONSUMER/ST=$STATE_CONSUMER/L=$LOCALITY_CONSUMER/O=$ORGANIZATION_CONSUMER/CN=$COMMON_NAME_CONSUMER" -addext "subjectAltName=$SAN"
# Firmar el CSR con la CA, incluyendo SAN
openssl x509 -req -in consumer.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out consumer.crt -days 365