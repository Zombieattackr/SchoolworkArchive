from datetime import datetime
from MFRC522_IOT import MFRC522_IOT
import paho.mqtt.client as mqtt
from pytz import timezone
import time
eastern = timezone('US/Eastern')
THE_BROKER = "test.mosquitto.org"
CLIENT_ID = ""

class Clock:
    def __init__(self, serial_number):
        self.pi_number = str(serial_number)
        self.client = mqtt.Client(client_id=CLIENT_ID, clean_session=True, userdata=None, protocol=mqtt.MQTTv311, transport="tcp")
        self.client.on_connect = self.on_connect
        self.client.on_publish = self.on_publish
        self.client.on_message = self.on_message
        self.client.username_pw_set(None, password=None)
        self.reader = MFRC522_IOT()
        self.records = {}
    
    # The callback for when the client receives a CONNACK response from the server.
    def on_connect(self, client, userdata, flags, rc):
        print("Connected to ", client._host, "port: ", client._port)
        print("Flags: ", flags, "returned code: ", rc)
        client.subscribe("FULLEH/UID", qos=0)
        
    # The callback for when a message is published.
    def on_publish(self, client, userdata, mid):
        pass
    
    # The callback for when a message is received.
    def on_message(self, client, userdata, msg):
        message = str(msg.payload.decode("utf-8"))
        if msg.topic == "FULLEH/UID":
            serial_number, name, uid = message.split("#")
            if serial_number == self.pi_number:
                self.records[name] = uid
                print("{}'s check-in at scanner {} authenticated with uid: {}".format(name, serial_number, uid))
    
    def start_tracking(self):
        self.client.connect(THE_BROKER, port=1883, keepalive=60)
        self.client.loop_start()
        while True:
            id_, name = self.reader.read()
            if name != None:
                name = name.strip()
                timestamp = datetime.now(eastern).strftime("%Y-%m-%d %H:%M:%S")
                self.client.publish("FULLEH/MFRC", payload="#".join([self.pi_number, name, timestamp]), qos=0, retain=False)
            time.sleep(3)
    
    def stop_tracking(self):
        self.client.loop_stop()
        self.client.disconnect()

if __name__ == '__main__':
    Clock1 = Clock(1)
    Clock1.start_tracking()