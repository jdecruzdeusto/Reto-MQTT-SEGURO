
# Reto: MQTT-Seguro

Introducción a Filebeat y Análisis de Logs

## Descripción:

• Montar un bróker MQTT con o sin contendor que funcione de manera segura
utilizando una autenticación basada en certificados de cliente y servidor.

• Una aplicación de Python que pueda producir y consumir datos de manera
segura

• Que se pruebe también a producir y consumir datos desde línea de comandos

## Estructura 🏗️

![image](https://github.com/jdecruzdeusto/Reto-MQTT-SEGURO/assets/125390240/67714a8b-5d87-4677-bdc8-865648283786)

## Ejecución 🚀

1. Ejecutar los siguientes comandos en wsl para asegurarse de que los archivos son accesibles
```bash
sudo chmod 644 /home/juan/MQTT/mqtt_certs/*.crt
sudo chmod 644 /home/juan/MQTT/mqtt_certs/*.key
sudo chown mosquitto:mosquitto /home/juan/MQTT/mqtt_certs/*.crt
sudo chown mosquitto:mosquitto /home/juan/MQTT/mqtt_certs/*.key
```

2. Editar la configuración de mosquitto.conf:
```bash
sudo nano /etc/mosquitto/mosquitto.conf
```
3. Añadir lo siguiente dentro del archivo de configuración:
```nano
listener 8883
cafile /home/juan/MQTT/mqtt_certs/ca.crt
certfile /home/juan/MQTT/mqtt_certs/server.crt
keyfile /home/juan/MQTT/mqtt_certs/server.key

require_certificate true
allow_anonymous false
tls_version tlsv1.3

password_file /home/juan/MQTT/passwd
```
4. Ejecutar el archivo del consumer (.sh o .py)
```bash
sudo sh consumer.sh
python3 consumer.py
```
5. Abrir otra consola y ejecutar el archivo del productor (.sh o .py)
```bash
sudo sh productor.sh
python3 productor.py
```
6. Escribir el mensaje por consola o "salir" para finalizar la ejecución

## Pasos seguidos para realizar el reto 🚶
### CA.sh
1. Generar el "Certificate Authority" (CA)
   
2. Definir las variables para los detalles de certificados (país, estado, ciudad, organización, nombre común).
   
3. Crear el "Certificate Signing Request" (CSR)
   
4. Generar los certificados para el server, cosumer y producer
   
5. Firma de los CSR con la CA para generar los certificados correspondientes.

6. Añadir "Subject Alternative Names" (SAN)

#### mosquitto.conf
1. Abrir el puerto 8883 para escuchar:

listener 8883

2. Referenciar las rutas de nuestros certificados:

cafile /home/juan/MQTT/mqtt_certs/ca.crt
certfile /home/juan/MQTT/mqtt_certs/server.crt
keyfile /home/juan/MQTT/mqtt_certs/server.key

3. Añadir la configuración de seguridad para que no pueda escuchar peticiones sin certificados o anónimas y especificar la versión de TLS:

require_certificate true
allow_anonymous false
tls_version tlsv1.3

4. Referenciar el archivo donde se encuentran el user y el password:

password_file /home/juan/MQTT/passwd

#### psswd

1. Crear el archivo y definir el user:

sudo mosquitto_passwd -c /home/juan/MQTT/passwd juan

#### productor.py

1. Importar las bibliotecas necesarias (paho.mqtt.client, time, ssl).

2. Definir la dirección del broker, puerto y topic.
   
3. Definir la función on_connect para manejar el evento de conexión.

4. Crear una instancia del cliente MQTT.

5. Configurar el nombre de usuario y la contraseña con client.username_pw_set.
   
6. Configurar TLS con client.tls_set.

7. Asignar la función de callback on_connect al evento de conexión del cliente.
   
8. Conectar al broker MQTT con client.connect.
   
9. Iniciar el bucle de red del cliente en un nuevo hilo con client.loop_start.
    
10. Esperar 1 segundo para asegurar que la conexión se haya establecido.

11. Entrar en un bucle para publicar mensajes.

12. Finalizar el bucle y desconectar el cliente limpiamente.

#### consumer.py

1. Importar las bibliotecas necesarias (ssl y paho.mqtt.client).

2. Definir las funciones on_connect y on_message para manejar eventos de conexión y recepción de mensajes.

3. Crear una instancia del cliente MQTT.

4. Configurar TLS con client.tls_set.

5. Asignar las funciones de callback (on_connect y on_message) al cliente.

6. Conectar al broker MQTT con client.connect.

7. Iniciar el bucle infinito con client.loop_forever para mantener la conexión activa y procesar cualquier mensaje entrante.

## Posibles vías de mejora 📈
- Actualizar y adaptar el proyecto a las últimas versiones de MQTT y TLS

- Automatizar el proceso de rotación de certificados y credenciales para reducir el riesgo de compromiso.

- Hacer que la IP se reajuste a la IP necesaria

- Telegraf + InfluxDB + Grafana (TIG Stack)

## Alternativas posibles 🔜
- Explorar otros brokers MQTT

- Mutual TLS

## Problemas / Retos encontrados ❗
- Permisos en los archivos: chmod, chown

- Nunca había usado certificados

- Necesidad del SAN

- Necesidad del user/password
  
- SAN

- Conexión con los .py
