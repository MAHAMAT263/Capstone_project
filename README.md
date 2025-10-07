# Capstone_project
# ChFarmGuard: IoT and Computer Vision for Livestock Intrusion Alert

demo_link
Figma_design : https://www.figma.com/design/WYumWf9YDv29oAcgNRgp4A/Free-Banking-Mobile-App-Ui-Kit-With-light---Dark-Mode-High-Quality-Ui-43--Screen-template--Community---Copy-?node-id=1-4&p=f&t=aBZU0PfHnwVAqdsh-0

Repo_link : https://github.com/MAHAMAT263/Capstone_project

---
**Author:** Mahamat Hissein Ahmat
**Supervisor:** Bernard Odartei Lamptey
**Degree:** BSc. in Software Engineering
**Date:** 15/09/2025

---

## 📘 Overview

**ChFarmGuard** is an IoT and computer vision-based system designed to detect animal intrusions in farmlands and send real-time alerts to farmers. The system aims to prevent crop destruction and reduce farmer-herder conflicts, particularly in rural Chad, where such issues are common. Using low-cost devices such as Raspberry Pi, camera modules, and GSM/Internet communication, the system automatically identifies livestock (e.g., goats, cows, camels) and alerts farmers via mobile notifications or sound deterrents.

---

## 🧩 Objectives

* **Main Objective:**
  To design and deploy a low-cost IoT system capable of detecting, classifying, and alerting farmers about livestock intrusion in real-time.

* **Specific Objectives:**

  * Review existing literature on IoT and computer vision for intrusion detection.
  * Develop a prototype integrating Raspberry Pi, camera modules, and alert mechanisms.
  * Evaluate the system using detection accuracy, false alarm rate, and user feedback.

---

## ❓ Research Questions

1. Can a local IoT-computer vision system accurately detect and classify animals entering farmlands?
2. How do edge-based (Raspberry Pi) and cloud-based models compare in performance?
3. Can real-time notifications reduce crop loss and prevent farmer-herder conflicts?

---

## 🔍 Project Scope

The system focuses on smallholder farms, tested in Rwanda but designed for deployment in rural Chad. It targets medium-to-large livestock such as cows and goats, and can be extended for camels. The project emphasizes cost-effectiveness and offline functionality.

---

## 💡 Significance

ChFarmGuard contributes to:

* Preventing crop destruction through early intrusion alerts.
* Reducing violent farmer-herder conflicts.
* Promoting food security and peacebuilding using affordable digital technology.

---

## 💰 Research Budget (Approx.)

| Item                  | Quantity | Unit Cost (RWF) | Total           |
| --------------------- | -------- | --------------- | --------------- |
| Raspberry Pi + Camera | 1        | 117,000         | 117,000         |
| Speaker/Amplifier     | 1        | 20,000          | 20,000          |
| GSM Module            | 1        | 25,000          | 25,000          |
| **Total**             |          |                 | **162,000 RWF** |

---

## 🧠 System Design Overview

### **System Components**

* **Hardware:** Raspberry Pi 4, Camera Module, GSM/Internet Module, Speaker.
* **Software:** Python, TensorFlow Lite, OpenCV, Firebase, Flask/FastAPI, Flutter.

### **Proposed Features**

* Real-time animal detection and classification using camera input.
* Local inference using pre-trained lightweight models.
* Push notifications via Firebase Cloud Messaging (FCM).
* Optional alarm or deterrent activation (e.g., sound playback).

### **Architecture**

The system integrates IoT devices (Raspberry Pi + Camera) for real-time monitoring, a local ML model for classification, and a mobile/web interface for notifications.

---

## 🧮 Development Tools

### **Hardware**

* Raspberry Pi 4
* Pi Camera or USB Camera
* GSM Module / Wi-Fi
* Speaker or Buzzer

### **Software**

* **Languages:** Python
* **Frameworks:** TensorFlow, PyTorch, OpenCV, Flask/FastAPI
* **Database & Auth:** Firebase
* **Mobile App:** Flutter + Firebase Cloud Messaging
* **Version Control:** Git/GitHub
* **Model Training:** Google Colab / Jupyter Notebook

---

## 📈 System Flow

1. Camera captures image/video.
2. Raspberry Pi processes input with ML model.
3. Detected animal classified (e.g., goat, cow ).
4. Alert sent to farmer’s mobile via FCM.
5. Optional deterrent (sound/alarm) triggered.

---

## 🔬 Methodology

The **prototype development model** is used to allow iterative testing of each module (camera input, ML inference, alert system). This ensures adaptability to real farm conditions and efficient system refinement.



## 🧩 Conclusion

ChFarmGuard bridges the gap between traditional farm protection and modern technology. It provides a practical, scalable, and affordable solution that empowers rural farmers to safeguard their crops, reduce losses, and foster peace in conflict-prone areas.
