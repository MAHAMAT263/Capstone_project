ChFarmGuard: IoT + Computer Vision Livestock Intrusion Alert System
Final Capstone Project – BSc Software Engineering

Author: Mahamat Hissein Ahmat
Supervisor: Bernard Odartei Lamptey
Date: 15/09/2025

📹 Demo Video

5-minute demonstration:
https://drive.google.com/file/d/1L4ZV4tlrEsNnrDCLymxNgJvWMGlOIHXN/view?usp=sharing

📱 Repository

GitHub Repository:
https://github.com/MAHAMAT263/Capstone_project

🎨 UI/UX Prototype

Figma design:
https://www.figma.com/design/WYumWf9YDv29oAcgNRgp4A/…

📘 Project Overview

ChFarmGuard is a smart, low-cost IoT and Computer Vision system for detecting livestock intrusions in farmlands and sending real-time alerts to farmers.
The system uses:

Raspberry Pi

Camera (USB/Pi Camera)

TensorFlow Lite animal detection model

Firebase for real-time alerts

Flutter mobile application

Optional alarm (sound deterrent)

The goal is to prevent crop damage and reduce farmer-herder conflict using affordable technology deployable in rural Chad.

🟦 Core Functionalities (Demonstrated in the Video)

✔ Live video feed processed on Raspberry Pi
✔ Animal detection using YOLOv5n → TFLite model
✔ Alert automatically sent to Firebase
✔ Mobile app receives alert instantly
✔ User can accept/reject alert → Raspberry Pi receives response
✔ Alarm sound triggered on Raspberry Pi as deterrent
✔ System runs offline + online (GSM module or Wi-Fi)
✔ App displays past alerts and status updates

🟩 Testing Results (Required for Full Marks – 5 Points)

Screenshots and video demonstrations included in the repo.

1. Testing Strategies Used

Unit Testing:

Camera input test

Model inference test

Sound playback test

Firebase send/receive test

Integration Testing:

Raspberry Pi → Firebase → Mobile App

Detection → Alert → User decision → Raspberry Pi action

Functional Testing:

Full use-case simulation (animal enters farm → alarm + app alert)

2. Tests with Different Data Values

Real animal images (goat, cow, camel, sheep…)

Different lighting (dark, bright, shadows)

Different distances (1m, 3m, 5m)

Printed animal images to simulate testing

Videos and random test images

3. Tests on Different Hardware/Software

Raspberry Pi 4 (edge inference)

Laptop (training + evaluation)

Android phone (Flutter app)

Different internet conditions (Wi-Fi & GSM module)

Result:
The system performs with 5–12 FPS on Raspberry Pi 4 when using YOLOv5n-TFLite.

🟨 Analysis (Required for Full Marks – 2 Points)
Achievements

Accurate livestock detection model trained using YOLOv5n (mAP50 = 0.759)

Efficient edge inference on Raspberry Pi

Verified real-time push notifications via Firebase

Two-way communication implemented (Farmer ↔ Device)

Challenges

Low-light detection accuracy lower than daytime

Raspberry Pi is slower with heavy models (necessitated YOLOv5n choice)

Network latency when the GSM module signal is weak

How objectives were met

Optimized model to TFLite

Used image augmentations and dataset balancing

Caching and lightweight communication protocol improved responsiveness

🟧 Discussion (Required – Impact & Importance)

Milestones like model training, edge optimization, Raspberry Pi integration, and mobile alerting were essential to validate real-world feasibility.

The use of TFLite ensures the system can run locally without internet dependency, which is critical for rural Chad.

System showed strong potential for preventing crop loss and reducing conflicts by notifying farmers early.

🟫 Recommendations & Future Work
Recommendations to community

Deploy the system using solar power for remote farms

Integrate local language  (Arabic, French)

Use motion sensors for even lower power consumption

Future Enhancements

Night-vision IR camera support

Animal counting and tracking

GPS-based farm intrusion map

Auto-deterrent mechanisms (lights, alarms, drone trigger)

🟦 Installation & Running Guide (Required for Attempt 1)
⚙️ 1. Raspberry Pi Setup
sudo apt update
sudo apt install python3-opencv python3-pip
pip3 install numpy scipy tensorflow-lite


Clone the project:

git clone https://github.com/MAHAMAT263/Capstone_project
cd Capstone_project

🎯 2. Run the detection system
python3 main_detection.py

🔔 3. Trigger Alarm (Optional)
python3 -c "from sound_manager import play_long_alarm; play_long_alarm()"

📱 4. Flutter App

Inside /mobile_app/, run:

flutter pub get
flutter run


APK available inside repo or deployed link.

📁 Related Files Included

model/best_animals.tflite

sound_manager.py + WAV sounds

main_detection.py

flask_api/

mobile_app/

firebase_config/

Dataset preprocessing notebooks

🟪 Deployment (Required – 3 Points)
Deployment Steps (Clear & Fully Structured)

Install Raspberry Pi dependencies

Copy TFLite model and project files

Run detection script

Configure Firebase environment variables

Install Flutter app on Android

System validation:

Detect → Alert

User confirms → Pi receives response

Alarm triggers

Deployment Success Verification:

Detection logs printed

App receives live alerts

Firebase dashboard shows data updates

Raspberry Pi actions confirmed

Status: System deployed successfully and validated.

🧩 Conclusion

ChFarmGuard is a practical, scalable, and cost-efficient livestock intrusion detection system designed for real-world rural communities. It successfully integrates IoT, mobile notifications, computer vision, and edge AI to prevent farm losses and conflict.
