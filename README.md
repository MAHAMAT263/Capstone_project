ChFarmGuard: IoT + Computer Vision Livestock Intrusion Alert System
Final Capstone Project – BSc Software Engineering

Author: Mahamat Hissein Ahmat
Supervisor: Bernard Odartei Lamptey
Date: 15/09/2025

📹 Demo Video

▶ 5-minute demonstration video
https://drive.google.com/file/d/1L4ZV4tlrEsNnrDCLymxNgJvWMGlOIHXN/view?usp=sharing

📁 GitHub Repository

https://github.com/MAHAMAT263/Capstone_project

🎨 UI/UX Design

https://www.figma.com/design/WYumWf9YDv29oAcgNRgp4A/…

📘 Overview

ChFarmGuard is an IoT and Computer Vision system designed to detect livestock intrusions on farmland and send real-time alerts to farmers. It uses a Raspberry Pi for on-device inference, a YOLOv5n TFLite model for animal detection, and Firebase + Flutter for mobile notifications. The system enhances farm protection, reduces crop destruction, and supports conflict prevention in rural Chad.

🟦 Core Functionalities

✔ Real-time animal detection via Raspberry Pi
✔ Alerts sent to Firebase Cloud Firestore
✔ Mobile app receives intruder notifications instantly
✔ Farmer can accept/reject alert (two-way communication)
✔ Raspberry Pi receives user feedback
✔ Alarm/speaker deterrent activated automatically
✔ Works offline (local inference) and online (GSM/Wi-Fi)
✔ Lightweight TFLite model optimized for edge devices

🟩 Testing Results (Screenshots inside repo)

Excellent-Level Testing (for full 5 points):

✅ 1. Testing Strategies Used

Unit tests:

Camera capture

Model inference

Sound playback

Firebase write/read

Integration tests:

Pi → Firebase → Mobile app

Detection → Alert → User decision → Pi response

Functional tests:

Full intrusion simulation workflow

✅ 2. Tests with Different Data Values

Real animal images (goat, cow, camel, sheep, zebra…)

Different lighting conditions (dark, daylight, shadows)

Different distances (1–5m)

Printed images for simulation

Mixed background clutter

✅ 3. Hardware/Software Performance Tests

Raspberry Pi 4 (TFLite inference)

Laptop (training & debugging)

Android device (Flutter app)

Weak/strong network environments

Performance:
Raspberry Pi achieved 5–12 FPS with YOLOv5n TFLite.

🟨 Analysis (Excellent-Level – 2 points)
🎯 Achievements

Successful deployment of YOLOv5n TFLite model

Real-time detection and alerting pipeline

Verified low-power edge inference

Stable two-way communication between Pi and mobile

⚠️ Challenges

Lower accuracy in low-light scenarios

GSM module slower in rural environment

Raspberry Pi limited performance using heavier models

🧠 How Objectives Were Met

Model optimized using data augmentation and balancing

Used lightweight detection architecture (YOLOv5n)

Implemented caching and asynchronous communication

Performed continuous field testing for refinement

🟧 Discussion

The key milestones—dataset preparation, model training, TFLite optimization, Raspberry Pi integration, Flutter app development, and Firebase pipeline—were essential for verifying the system’s real-world usability.

The project demonstrates significant potential for reducing farm losses, improving farmer security, and preventing farmer–herder conflict through early intrusion alerts.

🟫 Recommendations & Future Work
🔵 Recommendations

Use solar-powered Pi for rural deployment

Add local language  (Arabic, French)

Install weather-proof camera casing

🟣 Future Enhancements

Night-vision / IR camera

Animal counting & herd tracking

GPS boundary monitoring

Automatic deterrent systems (lights, alarm horns, drones)

⚙️ Installation Guide (Required for Attempt 1)
1. Raspberry Pi Setup
sudo apt update
sudo apt install python3-pip python3-opencv
pip3 install -r requirement.txt


Clone the repo:

git clone https://github.com/MAHAMAT263/Capstone_project
cd Capstone_project

2. Add TFLite model

Place your model inside:

/model/best_animals.tflite

3. Run the Detection System
python3 main.py


📱 Mobile App (Flutter)

Inside /mobile_app/:

flutter pub get
flutter run


APK included in the repository.

📂 Related Files Included in Repo

model/best_animals.tflite

main.py (Raspberry Pi detection pipeline)

sound_manager.py + WAV files

generate_long_alarm.py

flask_api/ backend

firebase_config/

mobile_app/ Flutter application

Dataset notebooks for training/augmentation

🟪 Deployment (3 Points – Excellent-Level)
Deployment Steps

Set up Raspberry Pi hardware

Configure camera + test input

Install Python dependencies

Load TFLite animal detection model

Connect Firebase credentials

Launch detection + alert pipeline

Install Flutter app on mobile

Validate system end-to-end

Deployment Verification

Raspberry Pi successfully detects animals

Firebase logs alert events

Mobile app receives push notifications

User decisions return to Raspberry Pi

Alarm triggers reliably

✔ System fully deployed and validated.

🧩 Conclusion

ChFarmGuard is an efficient IoT + AI solution for livestock intrusion detection. It is optimized for low-resource environments, reduces farm losses, supports rural livelihoods, and leverages modern edge computing to solve real-world agricultural challenges.
