# image_server.py
from flask import Flask, send_file, jsonify
import os
import requests

app = Flask(__name__)

# Path where main.py saves the latest captured image
IMAGE_PATH = "captured_image/latest.jpg"

# Your hosted FastAPI endpoint for global access
FASTAPI_UPLOAD_URL = "https://farmguard-api.onrender.com/upload"  # 🔁 replace with your real URL

@app.route("/latest.jpg")
def latest_image():
    """Serve the latest image locally for testing."""
    if os.path.exists(IMAGE_PATH):
        return send_file(IMAGE_PATH, mimetype="image/jpeg")
    return jsonify({"error": "No image found"}), 404

@app.route("/upload", methods=["POST"])
def upload_to_fastapi():
    """Manually push the latest image to your FastAPI cloud server."""
    if not os.path.exists(IMAGE_PATH):
        return jsonify({"error": "No local image found"}), 404

    try:
        with open(IMAGE_PATH, "rb") as f:
            files = {"file": f}
            response = requests.post(FASTAPI_UPLOAD_URL, files=files)
        if response.status_code == 200:
            return jsonify({"status": "success", "fastapi_response": response.json()})
        return jsonify({"status": "error", "detail": response.text}), 500
    except Exception as e:
        return jsonify({"status": "failed", "error": str(e)}), 500

@app.route("/status")
def status():
    """Health check for your local Flask server."""
    return jsonify({
        "status": "running",
        "image_exists": os.path.exists(IMAGE_PATH)
    })

if __name__ == "__main__":
    print("📡 Local image server running at http://0.0.0.0:5000")
    app.run(host="0.0.0.0", port=5000, debug=False)