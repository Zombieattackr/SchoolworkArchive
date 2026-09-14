#!/usr/bin/env python3
import RPi.GPIO as GPIO
import time
from HCSR04_lib import HCSR04


#GPIO Mode (BOARD / BCM)
GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.cleanup()

TRIG = 4
ECHO = 17

GPIO.setup(TRIG, GPIO.OUT)

instance = HCSR04(TRIG_pin=TRIG, ECHO_pin=ECHO)  # BCM17

instance.init_HCSR04()

while True:
# for _ in range(1):
    distance = instance.measure_distance()
    print("distance is:", distance, "cm")
