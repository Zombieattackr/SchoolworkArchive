import RPi.GPIO as GPIO
from MFRC522_IOT import MFRC522_IOT
import time

reader = MFRC522_IOT()

try:
        text = bytearray(b'Hello Hayden byte')
        text.extend([0x01, 0x02, 0x03])

        print("Now place your tag to write")
        reader.writebytes(text) # write bytes
        print("Written")
        time.sleep(1.0)
finally:
        GPIO.cleanup()
