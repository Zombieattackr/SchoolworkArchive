import RPi.GPIO as GPIO
from DHT11_lib import DHT11
import time
import datetime

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.cleanup()
instance = DHT11(pin=17) #Pin 11

while True:
    result = instance.read()
    if result.is_valid():
        print("time: " + str(datetime.datetime.now()))
        print("temp: %d" % result.temperature)
        print("humidity: %d" % result.humidity)
    time.sleep(1)
