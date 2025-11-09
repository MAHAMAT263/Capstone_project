from fastapi import FastAPI, UploadFile, File
from fastapi.responses import FileResponse, JSONResponse
import os
import shutil
import uvicorn

app = FastAPI(title="ChFarmGuard Cloud API")

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
    """Receive an image from Raspberry Pi and replace the latest one."""
    try:
        # --- Auto-clean before saving new file ---
        for filename in os.listdir(UPLOAD_DIR):
            file_path = os.path.join(UPLOAD_DIR, filename)
            try:
                if os.path.isfile(file_path):
                    os.remove(file_path)
            except Exception:
                pass

        save_path = os.path.join(UPLOAD_DIR, "latest.jpg")
        with open(save_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        print(f"✅ New image uploaded: {save_path}")
        return {"status": "success", "message": "Image uploaded successfully"}

    except Exception as e:
        return JSONResponse(content={"status": "error", "detail": str(e)}, status_code=500)


# ---------------- Run (for Render deployment) ---------------- #
if __name__ == "__main__":
    port = int(os.environ.get("PORT", 8000))  # Render assigns dynamic port
    uvicorn.run("fastapi_server:app", host="0.0.0.0", port=port)