import RPi.GPIO as GPIO
from MFRC522_IOT import MFRC522_IOT
import time

reader = MFRC522_IOT()

try:
        print("place your tag for reading (bytes)")
        id, textbytes = reader.readbytes() # read bytes
        print("id:", id)
        print("byte:", textbytes)
        time.sleep(1.0)
finally:
        GPIO.cleanup()
