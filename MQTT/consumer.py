import ssl
import paho.mqtt.client as mqtt

# Esta función se llama automáticamente cuando el cliente se conecta al broker MQTT
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))
    client.subscribe("MQTT")

# Esta función se llama automáticamente cuando se recibe un mensaje en un topic suscrito
def on_message(client, userdata, msg):
    print(msg.topic+" "+str(msg.payload))

# Instancia del cliente MQTT
client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

# Configuración TLS
client.tls_set(ca_certs="/home/juan/MQTT/mqtt_certs/ca.crt",
               certfile="/home/juan/MQTT/mqtt_certs/server.crt",
               keyfile="/home/juan/MQTT/mqtt_certs/server.key",
               tls_version=ssl.PROTOCOL_TLS)

# Funciones de callback
client.on_connect = on_connect
client.on_message = on_message

# Conexión al broker MQTT
client.connect("172.20.207.7", 8883, 60)

# Bucle infinito
client.loop_forever()
