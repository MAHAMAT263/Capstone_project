import cv2
import numpy as np
import time
import traceback
import os
import subprocess
import sys
import requests
from tflite_runtime.interpreter import Interpreter
from alert_manager import (
    init_firebase,
    send_alert_to_firestore,
    check_alert_response,
    update_alert_status
)
from sound_manager import play_sound

import serial

# ---------------- Configuration ---------------- #
MODEL_PATH = "models/best_animals.tflite"
LABELS_PATH = "models/classes.txt"
THREAT_ANIMALS = ["cattle", "camel", "sheep", "goat"]
MOTION_THRESHOLD = 2500
DETECTION_INTERVAL = 10  # detect every 10 frames
FONT = cv2.FONT_HERSHEY_SIMPLEX
INPUT_SIZE = (320, 320)
ALERT_COOLDOWN = 30
ALERT_DOC_ID = "alert_test_001"

# ---------- GSM configuration ----------
GSM_SERIAL_PORT = "/dev/serial0"
GSM_BAUDRATE = 115200
GSM_PHONE_NUMBER = "+250791348732"
GSM_POLL_INTERVAL = 10
GSM_REPLY_TIMEOUT = 300  # 5 minutes

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
CAPTURE_DIR = os.path.join(BASE_DIR, "captured_image")
CAPTURE_PATH = os.path.join(CAPTURE_DIR, "latest.jpg")
os.makedirs(CAPTURE_DIR, exist_ok=True)

FLASK_URL = "http://127.0.0.1:5000"
FASTAPI_UPLOAD_URL = "https://capstone-project-hbck.onrender.com/upload"

# ---------------- Start Flask Image Server ---------------- #
def start_image_server():
    try:
        server_path = os.path.join(BASE_DIR, "image_server.py")
        print("Launching Flask server from:", server_path)

        process = subprocess.Popen(
            [sys.executable, server_path],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            universal_newlines=True
        )

        start_time = time.time()
        flask_ready = False

        while time.time() - start_time < 20:
            try:
                response = requests.get(f"{FLASK_URL}/status", timeout=2)
                if response.status_code == 200:
                    flask_ready = True
                    print("Flask image server is reachable at http://127.0.0.1:5000")
                    break
            except:
                pass

            line = process.stdout.readline()
            if line:
                print("[Flask]", line.strip())
            time.sleep(1)

        if not flask_ready:
            print("Flask server did not respond in time.")
        return process

    except Exception as e:
        print("Could not start image server:", e)
        return None

# ---------------- FastAPI Upload Helper ---------------- #
def upload_to_flask(image_path):
    try:
        print("Uploading captured image to local Flask server...")
        response = requests.post(f"{FLASK_URL}/upload", timeout=10)
        if response.status_code == 200:
            print("Image successfully forwarded to FastAPI.")
        else:
            print(f"Upload failed: {response.status_code}, {response.text}")
    except Exception as e:
        print("Upload error:", e)

# ---------------- Model & Labels ---------------- #
with open(LABELS_PATH, "r") as f:
    LABELS = [line.strip().lower() for line in f.readlines()]

interpreter = Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("Model loaded successfully")

# ---------------- Firebase ---------------- #
db = init_firebase()

# ---------------- Detection Memory ---------------- #
detected_animals = {}

# ---------------- GSM helper functions ---------------- #
def clear_all_sms(ser):
    try:
        ser.write(b'AT+CMGD=1,4\r')
        time.sleep(0.4)
        ser.read(ser.in_waiting or 64)
        print("All old SMS cleared from SIM800L inbox")
    except:
        print("Failed to clear SMS (ignored)")

def init_gsm(port=GSM_SERIAL_PORT, baud=GSM_BAUDRATE, timeout=1):
    try:
        ser = serial.Serial(port, baud, timeout=timeout)
        time.sleep(0.5)
        ser.flushInput()
        ser.flushOutput()
        ser.write(b'AT\r')
        time.sleep(0.3)
        ser.read(ser.in_waiting or 64)
        ser.write(b'AT+CMGF=1\r')
        time.sleep(0.3)
        ser.read(ser.in_waiting or 64)
        # set CNMI to store incoming SMS (2,1) so poll can read them
        ser.write(b'AT+CNMI=2,1,0,0,0\r')
        time.sleep(0.3)
        ser.read(ser.in_waiting or 64)

        clear_all_sms(ser)

        print("GSM modem initialized")
        return ser
    except Exception as e:
        print("Could not initialize GSM:", e)
        return None

def send_sms_via_gsm(ser, to_number, message, write_timeout=5):
    if ser is None:
        print("GSM serial unavailable")
        return False

    try:
        clear_all_sms(ser)

        ser.write(b'AT+CMGF=1\r')
        time.sleep(0.2)
        ser.read(ser.in_waiting or 64)

        cmd = f'AT+CMGS="{to_number}"\r'.encode()
        ser.write(cmd)
        time.sleep(0.5)
        ser.write(message.encode() + b'\x1A')

        t0 = time.time()
        buf = b""
        while time.time() - t0 < write_timeout:
            time.sleep(0.5)
            buf += ser.read(ser.in_waiting or 1)
            if b"OK" in buf or b"+CMGS" in buf or b"ERROR" in buf:
                break

        out = buf.decode(errors='ignore')
        if "ERROR" in out:
            print("GSM send ERROR:", out)
            return False

        print("GSM send response:", out.strip().splitlines()[-1] if out.strip() else "<no response>")
        return True
    except Exception as e:
        print("SMS send exception:", e)
        return False

def poll_gsm_for_reply(ser, timeout=GSM_REPLY_TIMEOUT, poll_interval=GSM_POLL_INTERVAL):
    if ser is None:
        return None

    print(f"Waiting for SMS reply for up to {timeout} seconds...")

    t_start = time.time()
    while time.time() - t_start < timeout:
        try:
            ser.write(b'AT+CMGF=1\r')
            time.sleep(0.2)
            ser.read(ser.in_waiting or 64)

            # first read any pushed URC that might have arrived
            pushed = ser.read(ser.in_waiting or 0)
            raw = b""
            if pushed:
                raw += pushed
            ser.write(b'AT+CMGL="ALL"\r')
            time.sleep(0.6)

            t0 = time.time()
            while time.time() - t0 < 1.0:
                raw += ser.read(ser.in_waiting or 1)
                time.sleep(0.05)

            text = raw.decode(errors='ignore')

            if "+CMGL:" in text or "+CMT:" in text:
                lines = text.splitlines()
                i = 0
                while i < len(lines):
                    line = lines[i].strip()
                    if line.startswith("+CMGL:"):
                        try:
                            idx = int(line.split(":")[1].split(",")[0].strip())
                        except:
                            idx = None

                        body = ""
                        if i + 1 < len(lines):
                            body = lines[i + 1].strip()

                        if not body.strip():
                            i += 2
                            continue

                        if body.startswith("1"):
                            clear_all_sms(ser)
                            return "1"
                        elif body.startswith("0"):
                            clear_all_sms(ser)
                            return "0"

                        if idx is not None:
                            ser.write(f'AT+CMGD={idx}\r'.encode())

                        i += 2
                    elif line.startswith("+CMT:"):
                        # pushed SMS format: +CMT: "<sender>",... then next line body
                        body = ""
                        if i + 1 < len(lines):
                            body = lines[i + 1].strip()
                        if not body.strip():
                            i += 2
                            continue
                        if body.startswith("1"):
                            clear_all_sms(ser)
                            return "1"
                        elif body.startswith("0"):
                            clear_all_sms(ser)
                            return "0"
                        i += 2
                    else:
                        i += 1

            time.sleep(poll_interval)

        except Exception as e:
            print("GSM poll exception:", e)
            time.sleep(poll_interval)

    return None

# ---------------- Helper Functions ---------------- #
def detect_animal(frame):
    img_resized = cv2.resize(frame, INPUT_SIZE)
    input_data = np.expand_dims(img_resized.astype(np.float32) / 255.0, axis=0)
    interpreter.set_tensor(input_details[0]['index'], input_data)
    interpreter.invoke()

    if len(output_details) == 1:
        output_data = interpreter.get_tensor(output_details[0]['index'])
        return process_single_output(output_data)
    else:
        return process_multiple_outputs(interpreter, output_details)

def process_single_output(output_data):
    output = np.transpose(output_data[0])
    scores = output[:, 4:]
    best_conf, best_class = 0.0, "unknown"

    for i in range(output.shape[0]):
        class_scores = scores[i]
        best_idx = np.argmax(class_scores)
        conf = class_scores[best_idx]

        if conf > best_conf and conf > 0.4:
            best_conf = conf
            best_class = LABELS[best_idx] if best_idx < len(LABELS) else f"class_{best_idx}"

    return best_class, best_conf

def process_multiple_outputs(interpreter, output_details):
    outputs = [interpreter.get_tensor(o['index'])[0] for o in output_details]
    best_class, best_conf = "unknown", 0.0

    for output in outputs:
        if output.ndim == 2 and output.shape[1] >= len(LABELS):
            best_idx = np.argmax(output)
            best_conf = np.max(output)
            best_class_idx = best_idx % len(LABELS)

            if best_conf > 0.4:
                best_class = LABELS[best_class_idx]
                break

    return best_class, best_conf

def should_detect_animal(animal, confidence):
    now = time.time()
    if confidence < 0.8:
        return False
    if animal in detected_animals and now - detected_animals[animal] < ALERT_COOLDOWN:
        return False
    detected_animals[animal] = now
    return True

# ---------------- Main Loop ---------------- #
def main():
    print("Starting ChFarmGuard Headless Mode")
    print(f"Using alert ID: {ALERT_DOC_ID}")

    start_image_server()
    time.sleep(3)

    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

    back_sub = cv2.createBackgroundSubtractorMOG2(history=100, varThreshold=50)

    frame_count = 0
    last_alert_time = 0
    gsm_serial = None

    while True:
        try:
            ret, frame = cap.read()
            if not ret:
                print("Camera read error.")
                break

            fg_mask = back_sub.apply(frame)
            motion_pixels = cv2.countNonZero(fg_mask)

            if motion_pixels > MOTION_THRESHOLD:
                frame_count += 1

                if frame_count % DETECTION_INTERVAL == 0:
                    animal, confidence = detect_animal(frame)
                    if should_detect_animal(animal, confidence):
                        print(f"Detected: {animal} ({confidence*100:.1f}%)")

                        if animal.lower() in THREAT_ANIMALS and confidence > 0.6:
                            now = time.time()

                            if now - last_alert_time > 15:
                                print(f"Threat: {animal} ({confidence*100:.1f}%)")

                                cv2.imwrite(CAPTURE_PATH, frame)
                                print(f"Image saved to {CAPTURE_PATH}")

                                upload_to_flask(CAPTURE_PATH)

                                conf_val = float(confidence)
                                online = send_alert_to_firestore(db, animal, conf_val, ALERT_DOC_ID)

                                if online:
                                    print("Waiting for farmer response (5 min)...")
                                    wait_start = time.time()
                                    responded = False

                                    while time.time() - wait_start < 300:
                                        resp = check_alert_response(db, ALERT_DOC_ID)
                                        if resp == "PLAY":
                                            play_sound("warning")
                                            update_alert_status(db, ALERT_DOC_ID, "PROCESSED")
                                            responded = True
                                            break
                                        elif resp == "NOT_PLAY":
                                            update_alert_status(db, ALERT_DOC_ID, "PROCESSED")
                                            responded = True
                                            break
                                        time.sleep(5)

                                    if not responded:
                                        print("No response -> auto-play.")
                                        update_alert_status(db, ALERT_DOC_ID, "PROCESSED")
                                        play_sound("warning")

                                else:
                                    print("Firebase offline -> GSM mode.")

                                    if gsm_serial is None:
                                        gsm_serial = init_gsm()

                                    clear_all_sms(gsm_serial)

                                    sms_message = (
                                        f"ALERT: {animal} detected Near to your farm. "
                                        f"Reply 1 to PLAY or 0 to Not play sound ."
                                    )

                                    sent = send_sms_via_gsm(gsm_serial, GSM_PHONE_NUMBER, sms_message)

                                    if not sent:
                                        print("Failed SMS -> playing sound.")
                                        play_sound("warning")
                                    else:
                                        print("SMS sent -> waiting for reply...")

                                        reply = poll_gsm_for_reply(
                                            gsm_serial,
                                            timeout=GSM_REPLY_TIMEOUT,
                                            poll_interval=GSM_POLL_INTERVAL
                                        )

                                        if reply == "1":
                                            print("Farmer replied 1 -> playing sound.")
                                            play_sound("warning")
                                        elif reply == "0":
                                            print("Farmer replied 0 -> skipping sound.")
                                        else:
                                            print("No SMS reply -> playing sound.")
                                            play_sound("warning")

                                    try:
                                        update_alert_status(db, ALERT_DOC_ID, "PROCESSED")
                                    except:
                                        pass

                                last_alert_time = now

            else:
                frame_count = 0

        except Exception as e:
            print("Error in loop:", e)
            traceback.print_exc()
            time.sleep(2)

    cap.release()

    try:
        if gsm_serial:
            gsm_serial.close()
    except:
        pass

if __name__ == "__main__":
    main()