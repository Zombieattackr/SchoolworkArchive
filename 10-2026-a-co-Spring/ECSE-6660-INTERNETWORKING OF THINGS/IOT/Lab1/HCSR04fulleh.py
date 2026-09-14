import RPi.GPIO as GPIO
import time
from HCSR04_lib import HCSR04

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BCM)
GPIO.cleanup()
TRIG = 4
#ECHO = 17 # pin 11
ECHO = 27 # pin 13
#NOTE: TRIG AND ECHO ARE BACKWARDS IN DOCUMENTATION


GPIO.setup(TRIG, GPIO.OUT)
instance = HCSR04(TRIG_pin=TRIG, ECHO_pin=ECHO)  # BCM17
instance.init_HCSR04()

while True:
    dist = instance.measure_distance()
    print("distance is: ", dist, " cm")
