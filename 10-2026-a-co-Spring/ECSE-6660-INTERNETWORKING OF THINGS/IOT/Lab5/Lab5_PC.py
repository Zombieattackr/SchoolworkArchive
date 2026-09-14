import paho.mqtt.client as mqtt
import uuid
THE_BROKER = "test.mosquitto.org"
CLIENT_ID = ""

class Counter:
    def __init__(self):
        self.client = mqtt.Client(client_id=CLIENT_ID, clean_session=True, userdata=None, protocol=mqtt.MQTTv311, transport="tcp", callback_api_version=mqtt.CallbackAPIVersion.VERSION1)
        self.client.on_connect = self.on_connect
        self.client.on_publish = self.on_publish
        self.client.on_message = self.on_message
        self.client.username_pw_set(None, password=None)
        self.records = {}
    
    # The callback for when the client receives a CONNACK response from the server.
    def on_connect(self, client, userdata, flags, rc):
        print("Connected to ", client._host, "port: ", client._port)
        print("Flags: ", flags, "returned code: ", rc)
        client.subscribe("FULLEH/MFRC", qos=0)
        
    # The callback for when a message is published.
    def on_publish(self, client, userdata, mid):
        pass
    
    # The callback for when a message is received.
    def on_message(self, client, userdata, msg):
        message = str(msg.payload.decode("utf-8"))
        if msg.topic == "FULLEH/MFRC":
            pi_number, name, timestamp = message.split("#")
            if pi_number not in self.records:
                self.records[pi_number] = {}
            self.records[pi_number][name] = timestamp
            print("{} checked in on scanner {} at {}".format(name, pi_number, timestamp))
            client.publish("FULLEH/UID", payload="#".join([pi_number, name, uuid.uuid4().hex]), qos=0, retain=False)
    
    def start_tracking(self):
        self.client.connect(THE_BROKER, port=1883, keepalive=60)
        self.client.loop_forever()
    
    def stop_tracking(self):
        self.client.loop_stop()
        self.client.disconnect()

if __name__ == '__main__':
    Counter1 = Counter()
    Counter1.start_tracking()