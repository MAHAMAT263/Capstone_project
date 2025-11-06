import cv2
import numpy as np
import tensorflow as tf
import time
import traceback
from alert_manager import (
    init_firebase,
    send_alert_to_firestore,
    check_alert_response,
    update_alert_status
)
from sound_manager import play_sound

# Configuration
MODEL_PATH = "models/best_animals.tflite"
LABELS_PATH = "models/classes.txt"
THREAT_ANIMALS = ["cattle" , "camel" , "sheep" , "goat" ]
MOTION_THRESHOLD = 2500
DETECTION_INTERVAL = 10  # detect every 10 frames
FONT = cv2.FONT_HERSHEY_SIMPLEX
INPUT_SIZE = (320, 320)

# Load labels
with open(LABELS_PATH, "r") as f:
    LABELS = [line.strip().lower() for line in f.readlines()]

# Load TensorFlow Lite model
interpreter = tf.lite.Interpreter(model_path=MODEL_PATH)
interpreter.allocate_tensors()
input_details = interpreter.get_input_details()
output_details = interpreter.get_output_details()

print("Model input details:", input_details[0]['shape'])
print("Model output details:", [out['shape'] for out in output_details])

# Initialize Firebase
db = init_firebase()

# Track detected animals
detected_animals = {}
ALERT_COOLDOWN = 30
ALERT_DOC_ID = "alert_test_001"


# ---------- Detection helpers ----------

def detect_animal(frame):
    """Run inference on a frame."""
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
    """Avoid duplicates within cooldown period."""
    now = time.time()
    if confidence < 0.8:
        return False
    if animal in detected_animals and now - detected_animals[animal] < ALERT_COOLDOWN:
        return False
    detected_animals[animal] = now
    return True


# ---------- Main logic ----------

def main():
    print(" Starting Real-Time Animal Detection with Live View...")
    print(" Only showing detections above 80% confidence")
    print(f" Using fixed alert document ID: {ALERT_DOC_ID}")

    cap = cv2.VideoCapture(0)
    cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
    cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)
    back_sub = cv2.createBackgroundSubtractorMOG2(history=100, varThreshold=50)

    frame_count = 0
    last_alert_time = 0

    while True:
        try:
            ret, frame = cap.read()
            if not ret:
                print(" Camera read error.")
                break

            fg_mask = back_sub.apply(frame)
            motion_pixels = cv2.countNonZero(fg_mask)
            frame_disp = frame.copy()

            if motion_pixels > MOTION_THRESHOLD:
                frame_count += 1
                cv2.putText(frame_disp, "Motion Detected", (20, 40), FONT, 1, (0, 255, 255), 2)

                if frame_count % DETECTION_INTERVAL == 0:
                    animal, confidence = detect_animal(frame)
                    if should_detect_animal(animal, confidence):
                        
                        if animal.lower() in THREAT_ANIMALS and confidence > 0.6:
                            now = time.time()
                            if now - last_alert_time > 15:
                                print(" Threat detected! Sending alert...")
                                conf_val = float(confidence)
                                online = send_alert_to_firestore(db, animal, conf_val, ALERT_DOC_ID)

                                if online:
                                    print(" Alert created → waiting up to 5 min for response...")
                                    wait_start = time.time()
                                    responded = False
                                    while time.time() - wait_start < 300:  # 5 minutes
                                        resp = check_alert_response(db, ALERT_DOC_ID)
                                        if resp == "PLAY":
                                            print(" Farmer chose PLAY.")
                                            play_sound("warning")
                                            update_alert_status(db, ALERT_DOC_ID, "PROCESSED")
                                            responded = True
                                            break
                                        elif resp == "NOT_PLAY":
                                            print("Farmer chose NOT_PLAY.")
                                            update_alert_status(db, ALERT_DOC_ID, "PROCESSED")
                                            responded = True
                                            break
                                        time.sleep(5)

                                    # No response after 5 min
                                    if not responded:
                                        print(" No response in 5 min → self-processing.")
                                        update_alert_status(db, ALERT_DOC_ID, "PROCESSED")
                                        play_sound("warning")
                                else:
                                    print(" Firebase offline → play sound locally.")
                                    play_sound("warning")

                                last_alert_time = now
                            else:
                                print(" Duplicate alert skipped.")

            else:
                frame_count = 0
                cv2.putText(frame_disp, "No Motion", (20, 40), FONT, 1, (150, 150, 150), 2)

            # show frame
            blended = cv2.addWeighted(frame_disp, 0.8,
                                      cv2.applyColorMap(fg_mask, cv2.COLORMAP_JET), 0.4, 0)
            cv2.imshow(" ChFarmGuard Detection", blended)

            if cv2.waitKey(1) & 0xFF == ord("q"):
                print(" Exiting system...")
                break

        except Exception as e:
            print(" Error in main loop:", e)
            traceback.print_exc()
            time.sleep(2)

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()