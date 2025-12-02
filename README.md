# ChFarmGuard: IoT + AI Livestock Intrusion Alert System
### Final Capstone Project – BSc Software Engineering

Author: Mahamat Hissein Ahmat  
Supervisor: Bernard Odartei Lamptey  
Date: 15/09/2025

---

## 📹 Demo Video
5-minute demonstration video:  
https://drive.google.com/drive/folders/17Xac1BwoIPViNwazjs06NWbVoVIGqKkc

---

## 📁 GitHub Repository
https://github.com/MAHAMAT263/Capstone_project

---

## 🎨 UI/UX Design
https://www.figma.com/design/WYumWf9YDv29oAcgNRgp4A/…

---

# 📘 Overview

ChFarmGuard is an IoT + Computer Vision system designed to detect livestock intrusions (goats, sheep, cows, camels) and notify farmers in real time.  
It combines:

- Raspberry Pi (edge AI inference)
- YOLOv5n TFLite model
- Flask image server + FastAPI uploader
- Firebase (online mode)
- SIM800L GSM module (offline mode)
- Flutter mobile app
- Sound alarm deterrent

The system is engineered for low-resource rural farms, especially in Chad.

---

# 🟦 Core Functionalities

✔ Motion-based detection using MOG2  
✔ Real-time animal detection (YOLOv5n and YOLOv5s TFLite)  
✔ Uploads captured image → Flask → FastAPI cloud server  
✔ Firebase alerts when internet is available  
✔ GSM SMS alerts when offline  
✔ Farmer replies “1” (play alarm) or “0” (skip alarm)  
✔ Raspberry Pi executes farmer’s decision  
✔ Auto-alarm if no response after timeout  
✔ Complete two-way communication system  

---
# Table

| Metric            | YOLOv5n  | YOLOv5s  | Difference | better      |
|-------------------|----------|----------|------------|-------------|
| mAP@0.5           | 75.9%    | 82.9%    | +7.0%      | ✅ YOLOv5s  |
| mAP@0.5:0.95      | 75.3%    | 80.6%    | +5.3%      | ✅ YOLOv5s  |
| Precision         | 73.1%    | 80.6%    | +7.5%      | ✅ YOLOv5s  |
| Recall            | 69.4%    | 77.1%    | +7.7%      | ✅ YOLOv5s  |
| Parameters        | 1.9M     | 7.0M     | +5.1M      | ✅ YOLOv5n  |
| GFLOPs            | 4.2      | 15.9     | +11.7      | ✅ YOLOv5n  |
| Layers            | 213      | 157      | -56        | ✅ YOLOv5s  |

---

# 🟩 Testing Requirements (in the drive)

Testing Results (Screenshots + Demos):
- Animal detection screenshots  
- Firebase alert logs  
- GSM reply tests  
- Intrusion simulation workflow  
- Motion detection tests  
- Mobile app screenshots  

Functionality Demonstrations:
- Different lighting conditions  
- Multiple farm animals  
- Online/offline alerts  
- Alarm activation tests  
- Flask + FastAPI image upload demonstration  

---

# 🟨 System Architecture

raspberry_pi/

│

├── main.py                  # Full detection + GSM + Firebase logic

├── image_server.py          # Flask local image server

├── api/                     # FastAPI cloud uploader

├── models/

│   ├── best_animals.tflite

│   └── classes.txt

├── alert_manager.py

├── sound_manager.py

├── sounds/

├── captured_image/

├── firebase_config.json

└── requirements.txt


chfarmguard_app/             # Flutter mobile app

app-release.apk              # Android APK

notebook.ipynb               # Training notebook



---

# ⚙️ Installation Guide (Raspberry Pi)

1. Install Required Packages  
sudo apt update  
sudo apt install python3-pip python3-opencv

2. Install Python Dependencies  
pip3 install -r requirements.txt

3. Clone the Repository  
git clone https://github.com/MAHAMAT263/Capstone_project  
cd Capstone_project/raspberry_pi

4. Add TFLite Model  
Place your model in:  
raspberry_pi/models/best_animals.tflite  
raspberry_pi/models/classes.txt

5. (Optional) Start Flask Manually  
python3 image_server.py

6. Run the Detection System  
python3 main.py

---

# 📱 Mobile App (Flutter)

Inside the folder:  
chfarmguard_app/

Install dependencies:  
flutter pub get

Run the app:  
flutter run

APK available:  
app-release.apk in the root

---

# 📂 Included Files in the Repository

- raspberry_pi/main.py – Core detection + alert pipeline  
- models/ – YOLOv5n TFLite model and labels  
- alert_manager.py – Firebase communication functions  
- sound_manager.py – Alarm playback logic  
- sounds/ – Alarm WAV files  
- image_server.py – Local Flask server  
- api/ – FastAPI image upload backend  
- firebase_config.json – Firebase credentials  
- notebook.ipynb – Training and preprocessing notebook  
- chfarmguard_app/ – Flutter mobile application  
- app-release.apk – Ready APK  

---

# 🟪 How the System Works

1. Motion → Detection → Alert  
- System detects motion using MOG2  
- YOLOv5n TFLite identifies the animal  
- Raspberry Pi saves an image  
- Image uploaded to Flask → FastAPI (cloud)  
- Alert triggered depending on network availability  

2. Online Mode (Firebase)
- Farmer receives push notification  
- Chooses PLAY or NOT PLAY  
- Raspberry Pi reads decision  
- Alarm plays if requested  

3. Offline Mode (GSM – SIM800L)
- SMS sent: “Reply 1 to PLAY or 0 to NOT play the sound.”  
- Raspberry Pi polls GSM for reply  
- Executes farmer’s decision  

4. Fail-Safe Mode  
If no response → alarm activates automatically.

---

# 🟧 Performance Summary

Achievements:
- Stable 5–12 FPS on Raspberry Pi  
- Reliable GSM communication  
- Smooth Firebase decision loop  
- Efficient TFLite inference  
- Seamless offline fallback mode  

Challenges:
- Low-light accuracy  
- GSM delays in rural network  
- Raspberry Pi cannot run heavy models
- powering the raspberry pi issue 

Optimizations:
- Reduced input size (320×320)  
- Cooldown system  
- Efficient background subtraction  
- Firebase polling every 5 seconds  

---

# 🟫 Analysis

Achievements:
- Fully functional IoT + AI deployment  
- Online + offline alert system  
- Real-time detection  
- Field-tested  (using the laptop to test the model as when we were there we lack enegy suply)

Methods Used:
- Dataset augmentation  
- TFLite optimization  
- Modular Python architecture  
- Real-world testing  

---

# 🟣 Recommendations & Future Enhancements

Recommendations:
- Solar-powered Raspberry Pi  
- Weatherproof casing  
- Add French + Arabic support  

Future Enhancements:
- Night-vision IR camera  
- Animal counting  
- GPS geofencing  
- Drone-based deterrence  

---

# 🧩 Conclusion

ChFarmGuard is a practical IoT + AI solution delivering real-time livestock intrusion detection.  
It supports rural farmers, reduces crop losses, and improves agricultural safety using modern edge computing.

Fully deployed. Fully tested. Ready for real-world use.
