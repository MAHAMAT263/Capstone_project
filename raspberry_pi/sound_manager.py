import platform
import time
import os
import subprocess

# ---------------------------------------------------------
# BASE DIRECTORY
# ---------------------------------------------------------
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
SOUND_DIR = os.path.join(BASE_DIR, "sounds")
os.makedirs(SOUND_DIR, exist_ok=True)

# WAV files (must exist)
WARNING_WAV = os.path.join(SOUND_DIR, "warning.wav")
ALERT_WAV = os.path.join(SOUND_DIR, "alert.wav")
NOTIF_WAV = os.path.join(SOUND_DIR, "notification.wav")
ALARM_LONG_WAV = os.path.join(SOUND_DIR, "alarm_long.wav")  # 60-second alarm!


# ---------------------------------------------------------
# MAIN PLAY SOUND
# ---------------------------------------------------------
def play_sound(sound_type="warning"):
    """General sound function with OS detection."""
    try:
        system = platform.system()
        print(f" Playing {sound_type} sound...")

        if system == "Linux":
            play_linux_sound(sound_type)
        elif system == "Windows":
            play_windows_beep(sound_type)
        else:
            play_console_bell(sound_type)

        return True

    except Exception as e:
        print(f" Sound failed: {e}")
        play_console_bell(sound_type)
        return True


# ---------------------------------------------------------
# RASPBERRY PI SOUND VIA APLAY
# ---------------------------------------------------------
def play_linux_sound(sound_type):
    """Play sounds using WAV files + aplay (flawless on Raspberry Pi)."""

    sound_map = {
        "warning": WARNING_WAV,
        "alert": ALERT_WAV,
        "notification": NOTIF_WAV,
    }

    sound_file = sound_map.get(sound_type, NOTIF_WAV)

    if not os.path.isfile(sound_file):
        print(f" Missing WAV file: {sound_file}")
        play_console_bell(sound_type)
        return

    try:
        subprocess.run(["aplay", "-q", sound_file])
    except Exception as e:
        print(f" aplay error: {e}")
        play_console_bell(sound_type)


# ---------------------------------------------------------
#  LONG CONTINUOUS 60-SECOND ALARM
# ---------------------------------------------------------
def play_long_alarm():
    """
    Plays the 60-second alarm sound file (alarm_long.wav)
    No loops, no gaps — perfect continuous alarm.
    """
    print(" Playing 60-second continuous alarm...")

    if not os.path.isfile(ALARM_LONG_WAV):
        print(" Missing alarm_long.wav! Cannot play alarm.")
        play_console_bell("warning")
        return

    try:
        subprocess.run(["aplay", "-q", ALARM_LONG_WAV])
    except Exception as e:
        print(" Alarm playback failed:", e)
        play_console_bell("warning")


# ---------------------------------------------------------
# WINDOWS BEEP
# ---------------------------------------------------------
def play_windows_beep(sound_type):
    try:
        import winsound

        if sound_type == "warning":
            winsound.Beep(1500, 800)

        elif sound_type == "alert":
            winsound.Beep(800, 600)

        elif sound_type == "notification":
            winsound.Beep(1000, 400)

        else:
            winsound.Beep(440, 500)

    except:
        play_console_bell(sound_type)


# ---------------------------------------------------------
# FALLBACK
# ---------------------------------------------------------
def play_console_bell(sound_type):
    print("\a")  # simple fallback beep


# ---------------------------------------------------------
# VISUAL ALERT WHEN AUDIO FAILS
# ---------------------------------------------------------
def show_visual_alert(sound_type):
    print(f"\n VISUAL ALERT: {sound_type.upper()}")
