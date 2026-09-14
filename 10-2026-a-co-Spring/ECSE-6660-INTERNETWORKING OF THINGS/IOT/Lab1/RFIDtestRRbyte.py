import RPi.GPIO as GPIO
from MFRC522_IOT import MFRC522_IOT
import time

reader = MFRC522_IOT()

try:
        while True:
                text = bytearray(b'RFID-TAG-013|')
                text.extend([0x01, 0x02, 0x03])

                print("Now place your tag to write")
                #reader.writebytes(text) # write bytes
                print("Written")
                time.sleep(1.0)

                print("place your tag for reading")
                id, text = reader.read()
                print("place your tag for reading again")
                id, textbytes = reader.readbytes() # read bytes
                print("id  :", id)
                print("text:", text)
                print("byte:", textbytes)
                time.sleep(1.0)
finally:
        GPIO.cleanup()
