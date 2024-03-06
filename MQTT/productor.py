import paho.mqtt.client as mqtt
import time
import ssl

# Configuración del cliente MQTT
broker_address = "172.20.207.7"
port = 8883
topic = "MQTT"

# Esta función se llama automáticamente cuando el cliente se conecta al broker MQTT
def on_connect(client, userdata, flags, rc, properties=None):
    if rc == 0:
        print("Conectado exitosamente al broker")
    else:
        print(f"Fallo en la conexion, codigo de retorno {rc}")


# Instancia del cliente MQTT
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

client.username_pw_set(username="juan", password="1412")

# Configuración TLS
client.tls_set(ca_certs="/home/juan/MQTT/mqtt_certs/ca.crt",
               certfile="/home/juan/MQTT/mqtt_certs/server.crt",
               keyfile="/home/juan/MQTT/mqtt_certs/server.key",
               tls_version=ssl.PROTOCOL_TLS)

# Funciones de callback
client.on_connect = on_connect

# Conexión al broker MQTT
client.connect(broker_address, port=port)

# Bucle infinito
client.loop_start()

# Espera de 1s para establecer la conexión
time.sleep(1)

# Publicación de mensajes
try:
    while True:
        mensaje = input("Introduce un mensaje o escribe 'salir': ")
        if mensaje.lower() == 'salir':
            break
        client.publish(topic, mensaje)
        print(f"Mensaje '{mensaje}' enviado al topic '{topic}'")
finally:
    client.loop_stop()
    client.disconnect()

print("Publicador MQTT finalizado.")