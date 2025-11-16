import numpy as np
from scipy.io.wavfile import write
import os

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SOUND_DIR = os.path.join(BASE_DIR, "sounds")
os.makedirs(SOUND_DIR, exist_ok=True)

def create_long_alarm(filename, frequency=1000, duration=60, volume=0.7):
    rate = 44100  # Sample rate

    # Time line for 60 seconds
    t = np.linspace(0, duration, int(rate * duration), False)

    # Create tone
    tone = np.sin(2 * np.pi * frequency * t)

    # Make pulsing effect (1 second ON, 0.2 off)
    envelope = ((np.sin(2 * np.pi * (1/1.2) * t) > 0) * 1.0).astype(float)

    # Apply envelope & volume
    audio = (tone * envelope * volume * 32767).astype(np.int16)

    write(filename, rate, audio)

print("🔧 Creating 60-second continuous alarm WAV...")
create_long_alarm(os.path.join(SOUND_DIR, "alarm_long.wav"))
print("alarm_long.wav created in /sounds/")
