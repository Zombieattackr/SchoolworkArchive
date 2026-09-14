import spidev
import RPi.GPIO as GPIO
import time
import paho.mqtt.client as mqtt
import json


from DHT11_lib import DHT11


# Pin Definitions (BCM Numbering)
CS_PIN = 22          # Physical Pin 15
DATA_READY_PIN = 27  # Physical Pin 13
DHT_PIN = 17         # Physical Pin 11

# MQTT Configuration
MQTT_BROKER = "test.mosquitto.org"
MQTT_PORT = 1883
MQTT_TOPIC = "fpga/aes_ctr/encrypted_data"

# AES-CTR Variables
# 12-byte Nonce + 4-byte Counter = 16 bytes
nonce = [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xAA, 0xBB]
counter = 0

def get_counter_block(n, c):
    """Combines a 12-byte nonce and a 4-byte counter into a 16-byte block."""
    c_bytes = [(c >> 24) & 0xFF, (c >> 16) & 0xFF, (c >> 8) & 0xFF, c & 0xFF]
    return n + c_bytes

def get_16byte_dht_payload(dht_sensor):
    """
    Reads the DHT11 and packs the data into a 16-byte array.
    Byte 0: Temperature (C)
    Byte 1: Humidity (%)
    Bytes 2-15: 0x00 (Padding)
    """
    result = dht_sensor.read()
    if result.is_valid():
        t = int(result.temperature) & 0xFF
        h = int(result.humidity) & 0xFF
        print(f"    [Sensor] Temp: {t}C, Humidity: {h}%")
        # Return the 16-byte payload
        return [t, h] + [0x00] * 14
    else:
        print("    [Sensor] Warning: Invalid read. Sending error payload.")
        # Return an obvious error block (all 1s) if the read fails
        return [0xFF] * 16

# --- Initialization ---
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)

GPIO.setup(CS_PIN, GPIO.OUT)
GPIO.output(CS_PIN, GPIO.HIGH) 
GPIO.setup(DATA_READY_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)

# Initialize Sensor
print("Initializing DHT11 Sensor...")
dht = DHT11(pin=DHT_PIN)

# Initialize SPI
print("Initializing SPI...")
spi = spidev.SpiDev()
spi.open(0, 0)             
spi.max_speed_hz = 500000  
spi.mode = 0b00            
spi.no_cs = True           

# Initialize MQTT
print("Connecting to MQTT Broker...")
mqtt_client = mqtt.Client()
mqtt_client.connect(MQTT_BROKER, MQTT_PORT, 60)
mqtt_client.loop_start()

print("====================================")
print("Raspberry Pi SPI Master - AES-CTR w/ DHT11")
print("====================================")

# --- Boot-up Sequence (Pipeline Priming) ---
print("Initializing FPGA pipeline with Counter 0...")
initial_counter_block = get_counter_block(nonce, counter)

GPIO.output(CS_PIN, GPIO.LOW)
spi.xfer2(initial_counter_block[:])
GPIO.output(CS_PIN, GPIO.HIGH)

# Read the first sensor payload to associate with this counter block
print("Taking initial sensor reading...")
previous_plaintext = get_16byte_dht_payload(dht)
counter += 1

# Let the initial counter block encrypt
time.sleep(0.1) 

try:
    while True:
        print(f"\n[1] Initiating SPI Transfer for Counter: {counter}...")
        current_counter_block = get_counter_block(nonce, counter)
        
        # Send the current nonce+counter.
        # Simultaneously receive the KEYSTREAM (encrypted counter) from the previous loop.
        GPIO.output(CS_PIN, GPIO.LOW)
        keystream = spi.xfer2(current_counter_block[:])
        GPIO.output(CS_PIN, GPIO.HIGH)
        
        # AES-CTR step: XOR the received keystream with our previous plaintext
        ciphertext = [k ^ p for k, p in zip(keystream, previous_plaintext)]
        
        # Format for printing
        hex_ciphertext = "".join([f"{byte:02X}" for byte in ciphertext])
        
        print("[2] Ciphertext calculated (Keystream ^ Plaintext): ", end="")
        for byte in ciphertext:
            print(f"{byte:02X} ", end="")
        print()
        
        # Create a JSON payload.  
        # actually belongs to the PREVIOUS counter block.
        payload_data = {
            "ciphertext": hex_ciphertext,
            "counter": counter - 1
        }
        
        json_payload = json.dumps(payload_data)
        
        # Publish to MQTT
        print(f"[*] Publishing JSON payload to MQTT '{MQTT_TOPIC}'...")
        print(f"    Payload: {json_payload}")
        mqtt_client.publish(MQTT_TOPIC, json_payload)
        
        print("[3] Waiting for FPGA to encrypt the current counter block...")
        timeout_start = time.time()
        
        # Wait for the FPGA to signal it is done
        while GPIO.input(DATA_READY_PIN) == GPIO.LOW:
            if (time.time() - timeout_start) > 1.0: 
                print("ERROR: Timeout waiting for FPGA data_ready signal.")
                break
                
        print("[4] FPGA Ready! (Data will be collected on the next loop)")
        
        # Update states for the next loop iteration: Read new sensor data
        previous_plaintext = get_16byte_dht_payload(dht) 
        counter += 1
        
        # DHT11 sensors generally require at least 2 seconds between reads
        time.sleep(3)

except KeyboardInterrupt:
    print("\nTest terminated by user.")
finally:

    mqtt_client.loop_stop()
    mqtt_client.disconnect()
    spi.close()
    GPIO.cleanup()
    print("Cleanup complete.")