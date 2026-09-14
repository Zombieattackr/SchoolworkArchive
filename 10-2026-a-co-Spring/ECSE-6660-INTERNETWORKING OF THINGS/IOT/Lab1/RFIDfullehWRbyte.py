import RPi.GPIO as GPIO
from MFRC522_IOT import MFRC522_IOT
import time

reader = MFRC522_IOT()

try:
        text = bytearray(b'Hello Hayden!')
        text.extend([0x4F, 0x57, 0x4F])
        print("Ready to Write")
        reader.writebytes(text)
        print("Wrote")
        time.sleep(1.0)
        print("Ready to Read")
        id, textbytes = reader.readbytes()
        print("id: ", id)
        print("byte: ", textbytes)
        time.sleep(1.0)
finally:
        GPIO.cleanup()
