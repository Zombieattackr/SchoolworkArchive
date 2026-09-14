#!/usr/bin/env python3

# ECSE 6660
# Edgar Muniz, munize@rpi.edu
# Hayden Fuller, fulleh@rpi.edu

# make sure to install node-red-dashboard and crypto-js
# npm install node-red-dashboard
# npm install crypto-js
# http://127.0.0.1:1880/ui

import RPi.GPIO as GPIO
import time
import datetime
import json

# Sensor libraries
from DHT11_lib import DHT11
from HCSR04_lib import HCSR04
import spidev

# MQTT
import paho.mqtt.client as mqtt

# GPIO SETUP
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.cleanup()

# SENSOR SETUP
# DHT11
dht = DHT11(pin=17) #pin 11

# HC-SR04
TRIG = 4
ECHO = 27 #pin 13
ultrasonic = HCSR04(TRIG_pin=TRIG, ECHO_pin=ECHO)
ultrasonic.init_HCSR04()

# Potentiometer (via ADC, MCP3008 assumed)
spi = spidev.SpiDev()
spi.open(0, 0)
# MCP3008 pin > function > RPI pin
# 13 > CLK > 23
# 12 > DOUT/MISO > 21
# 11 > DIN/MOSI > 19
# 10 > CS/SHDN/SPI CE0 > 24

def read_adc(channel):
    adc = spi.xfer2([1, (8 + channel) << 4, 0])
    value = ((adc[1] & 3) << 8) + adc[2]
    return value

# MQTT Setup
BROKER = "test.mosquitto.org"
TOPIC = "MUNIZEFULLEH/SENSORS"
CLIENT_ID = "pi_sensor_node"

client = mqtt.Client(client_id=CLIENT_ID)

def on_connect(client, userdata, flags, rc):
    print("Connected to broker:", BROKER, "RC:", rc)

client.on_connect = on_connect

client.connect(BROKER, 1883, 60)
client.loop_start()

# MAIN LOOP
while True:
    timestamp = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")

    # Read DHT11
    dht_result = dht.read()
    if dht_result.is_valid():
        temperature = dht_result.temperature
        humidity = dht_result.humidity
    else:
        temperature = None
        humidity = None

    # Read HC-SR04
    distance = ultrasonic.measure_distance()

    # Read Potentiometer
    pot_value = read_adc(0) #pot to CH0, MCP3008 pin 1

    # Compile Data
    sensor_data = {
        "timestamp": timestamp,
        "temperature_C": temperature,
        "humidity_percent": humidity,
        "distance_cm": distance,
        "potentiometer": pot_value
    }

    # FPGA SIGNATURE PLACEHOLDER!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    # TODO:
    # Send sensor_data to FPGA
    # Receive signature
    # sensor_data["signature"] = returned_signature

    # Convert to JSON
    payload = json.dumps(sensor_data)

    # Publish
    client.publish(TOPIC, payload)
    print("Published:", payload)

    time.sleep(2)