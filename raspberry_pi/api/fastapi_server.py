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
    latest_path = os.path.join(UPLOAD_DIR, "latest.jpg")
    if os.path.exists(latest_path):
        return FileResponse(latest_path, media_type="image/jpeg")
    return JSONResponse(content={"error": "No image found"}, status_code=404)

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):
    try:
        save_path = os.path.join(UPLOAD_DIR, "latest.jpg")
        with open(save_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
        return {"status": "success", "message": "Image uploaded successfully"}
    except Exception as e:
        return JSONResponse(content={"status": "error", "detail": str(e)}, status_code=500)