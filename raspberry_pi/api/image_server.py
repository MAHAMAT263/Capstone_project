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
    app.run(host="0.0.0.0", port=5000, debug=False)# fastapi_server.py
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import FileResponse, JSONResponse
import os
import shutil

app = FastAPI()

UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

@app.get("/")
def home():
    return {"status": "FastAPI server running globally!"}

@app.get("/latest.jpg")
def latest_image():
    """Serve the latest uploaded image."""
    latest_path = os.path.join(UPLOAD_DIR, "latest.jpg")
    if os.path.exists(latest_path):
        return FileResponse(latest_path, media_type="image/jpeg")
    return JSONResponse(content={"error": "No image found"}, status_code=404)

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    """Receive an image from Raspberry Pi and save it."""
    try:
        save_path = os.path.join(UPLOAD_DIR, "latest.jpg")
        with open(save_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return {"status": "success", "message": "Image uploaded successfully"}
    except Exception as e:
        return JSONResponse(content={"status": "error", "detail": str(e)}, status_code=500)