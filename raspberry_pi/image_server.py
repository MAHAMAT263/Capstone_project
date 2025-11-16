# image_server.py
from flask import Flask, send_file, jsonify
import os
import requests

app = Flask(__name__)

# Get absolute path to the image directory
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
IMAGE_PATH = os.path.join(BASE_DIR, "captured_image", "latest.jpg")

# Your FastAPI endpoint
FASTAPI_UPLOAD_URL = "https://capstone-project-hbck.onrender.com/upload"

@app.route("/")
def home():
    return """
    <h2> ChFarmGuard Image Server</h2>
    <p>Server is running locally on port 5000.</p>
    <ul>
        <li><a href='/status'>Check Status</a></li>
        <li><a href='/latest.jpg'>View Latest Captured Image</a></li>
    </ul>
    """


@app.route("/latest.jpg")
def latest_image():
    """Serve the latest image locally."""
    print(" Checking image at:", IMAGE_PATH)
    if os.path.exists(IMAGE_PATH):
        print(" Image found, sending it.")
        return send_file(IMAGE_PATH, mimetype="image/jpeg")
    print(" Image not found at:", IMAGE_PATH)
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
            print(" Uploaded image to FastAPI cloud successfully.")
            return jsonify({"status": "success"})
        return jsonify({"status": "error", "detail": response.text}), 500
    except Exception as e:
        print(" Upload error:", e)
        return jsonify({"status": "failed", "error": str(e)}), 500


@app.route("/status")
def status():
    return jsonify({
        "status": "running",
        "image_exists": os.path.exists(IMAGE_PATH)
    })


if __name__ == "__main__":
    print(" Local image server running at http://0.0.0.0:5000")
    print(f" Watching for image: {IMAGE_PATH}")
    app.run(host="0.0.0.0", port=5000, debug=True)
