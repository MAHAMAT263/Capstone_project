# image_server.py
from flask import Flask, send_file, jsonify, request
import os
import requests

app = Flask(__name__)
IMAGE_PATH = "captured_image/latest.jpg"

# --- Optional: your FastAPI (or cloud) endpoint ---
FASTAPI_UPLOAD_URL = "https://your-fastapi-domain.onrender.com/upload"  # change to your deployed URL

@app.route("/latest.jpg")
def latest_image():
    """Serve the latest captured image locally (LAN testing)."""
    if os.path.exists(IMAGE_PATH):
        return send_file(IMAGE_PATH, mimetype="image/jpeg")
    return jsonify({"error": "No image found"}), 404

@app.route("/upload_to_fastapi", methods=["POST"])
def upload_to_fastapi():
    """Manually push the image to your FastAPI cloud endpoint."""
    if not os.path.exists(IMAGE_PATH):
        return jsonify({"error": "No local image found"}), 404

    try:
        with open(IMAGE_PATH, "rb") as f:
            files = {"file": f}
            response = requests.post(FASTAPI_UPLOAD_URL, files=files)
        if response.status_code == 200:
            return jsonify({"status": "uploaded", "response": response.json()})
        return jsonify({"status": "error", "detail": response.text}), 500
    except Exception as e:
        return jsonify({"status": "failed", "error": str(e)}), 500

@app.route("/status")
def status():
    """Simple health check."""
    return jsonify({
        "status": "running",
        "image_exists": os.path.exists(IMAGE_PATH)
    })

if __name__ == "__main__":
    print("📡 Image server running at http://0.0.0.0:5000/latest.jpg")
    app.run(host="0.0.0.0", port=5000, debug=False)