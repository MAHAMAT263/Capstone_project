# alert_manager.py
import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime

import os
os.environ["GRPC_ENABLE_FORK_SUPPORT"] = "0"
os.environ["GRPC_VERBOSITY"] = "NONE"
os.environ["GRPC_ENABLE_HTTP_PROXY"] = "0"
os.environ["GRPC_DNS_RESOLVER"] = "native"
os.environ["GRPC_POLL_STRATEGY"] = "epoll1,poll"


_db = None  # store global reference

def init_firebase():
    global _db
    if _db is not None:
        return _db  # Prevent multiple initializations

    try:
        cred = credentials.Certificate("firebase_config.json")
        firebase_admin.initialize_app(cred)
        _db = firestore.client()
        print("Firebase initialized successfully.")
        return _db
    except Exception as e:
        print(f"Firebase initialization failed: {e}")
        return None


def send_alert_to_firestore(db, animal, confidence, alert_doc_id):
    """
    Send or update alert in Firestore.
    Returns True if successful, False if offline.
    """
    if db is None:
        print(" Firebase not connected.")
        return False

    try:
        confidence_float = float(confidence)
        alert_data = {
            "alert_id": alert_doc_id,
            "animal": str(animal),
            "confidence": confidence_float,
            "timestamp": firestore.SERVER_TIMESTAMP,
            "status": "PENDING",
            "user_id": "001",
            "location": "farm_camera_1",
        }

        db.collection("alerts").document(alert_doc_id).set(alert_data)
        print(f" Firestore alert created for {animal} ({confidence_float*100:.1f}%)")
        return True
    except Exception as e:
        print(f" Failed to send alert to Firestore: {e}")
        return False


def check_alert_response(db, alert_doc_id):
    """
    Reads farmer response ("PLAY" or "NOT_PLAY") from Firestore.
    Returns: 'PLAY', 'NOT_PLAY', 'PENDING', or None.
    """
    if db is None:
        return None

    try:
        doc_ref = db.collection("alerts").document(alert_doc_id)
        doc = doc_ref.get()
        if not doc.exists:
            return None
        data = doc.to_dict()
        return data.get("status", "").upper()
    except Exception as e:
        print(f" Error checking alert response: {e}")
        return None


def update_alert_status(db, alert_doc_id, new_status):
    """Safely update alert document status."""
    if db is None:
        return
    try:
        db.collection("alerts").document(alert_doc_id).update({
            "status": new_status,
            "last_updated": datetime.utcnow().isoformat(),
        })
        print(f" Firestore alert updated → {new_status}")
    except Exception as e:
        print(f" Could not update Firestore alert: {e}")
        print(f" HIGH CONFIDENCE DETECTION: {animal} ({confidence*100:.1f}%)")