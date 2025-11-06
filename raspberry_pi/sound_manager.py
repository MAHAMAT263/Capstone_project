import platform
import time

def play_sound(sound_type="warning"):
    """
    Built-in sound system - No PyGame, No MP3 files, Never crashes!
    Now with longer, more persistent sounds for warnings
    """
    try:
        print(f" Playing {sound_type} sound...")
        
        # Get the operating system
        system = platform.system()
        
        if system == "Windows":
            # Use Windows built-in beeps
            play_windows_beep(sound_type)
        elif system == "Linux":
            # Use Linux beep command or console bell
            play_linux_beep(sound_type)
        else:
            # Mac or other systems - use console bell
            play_console_bell(sound_type)
            
        print(f" {sound_type.capitalize()} sound played successfully!")
        return True
        
    except Exception as e:
        # Even if sound fails, we don't crash - just show visual alert
        print(f" Sound couldn't play, but continuing: {e}")
        show_visual_alert(sound_type)
        return True  # Always return True to prevent crashes

def play_windows_beep(sound_type):
    """Play beeps on Windows using winsound - LONGER VERSION"""
    try:
        import winsound
        
        if sound_type == "warning":
            # LONG URGENT WARNING: Repeated pattern for 5+ seconds
            print(" Playing extended warning pattern...")
            for i in range(6):  # Repeat 6 times for about 6 seconds
                winsound.Beep(1500, 600)  # Longer beep (600ms)
                time.sleep(0.2)           # Shorter pause
                winsound.Beep(1500, 600)
                time.sleep(0.5)           # Longer pause between pairs
                
        elif sound_type == "alert":
            # Extended alert: pulsating pattern
            print(" Playing extended alert pattern...")
            for i in range(4):  # Repeat 4 times
                winsound.Beep(800, 400)
                winsound.Beep(1200, 400)
                winsound.Beep(1000, 400)
                time.sleep(0.3)
                
        elif sound_type == "notification":
            # Longer notification
            winsound.Beep(1000, 800)  # Longer single beep
        else:
            # Default longer beep
            winsound.Beep(440, 1000)  # 1 second beep
            
    except ImportError:
        print(" winsound not available - using console bell")
        play_console_bell(sound_type)

def play_linux_beep(sound_type):
    """Play longer sounds on Linux"""
    try:
        import subprocess
        
        if sound_type == "warning":
            # Extended warning pattern
            print("🔊 Playing extended Linux warning...")
            for i in range(5):
                subprocess.run(['beep', '-f', '1500', '-l', '800'])
                time.sleep(0.3)
        else:
            subprocess.run(['beep', '-f', '1000', '-l', '600'])
    except:
        # Fallback to console bell
        play_console_bell(sound_type)

def play_console_bell(sound_type):
    """Universal fallback using ASCII bell character - EXTENDED"""
    if sound_type == "warning":
        print(" Playing extended console warning...")
        for i in range(8):  # More repetitions
            print("\a", end='', flush=True)
            time.sleep(0.5)
        print()  # New line after all bells
    elif sound_type == "alert":
        for i in range(4):
            print("\a\a", end='', flush=True)
            time.sleep(0.7)
        print()
    else:
        print("\a")      # Single bell for notification

def show_visual_alert(sound_type):
    """Show visual feedback when sound can't play - EXTENDED"""
    if sound_type == "warning":
        print(" " * 10)
        print(" EXTENDED WARNING! THREAT DETECTED! ")
        print(" " * 10)
        # Flash the warning message
        for i in range(3):
            print("AUDIO ALERT ")
            time.sleep(0.5)
    elif sound_type == "alert":
        alerts = {
            "warning": " WARNING! THREAT DETECTED! ",
            "alert": " EXTENDED ALERT! ",
            "notification": " NOTIFICATION "
        }
        message = alerts.get(sound_type, "🔊 SOUND ALERT 🔊")
        print(message)

# Ultra-simple backup that absolutely never fails - EXTENDED
def play_sound_never_fail():
    """This function will NEVER crash your program - EXTENDED VERSION"""
    print(" " * 20)
    print(" BEEP! BEEP! BEEP! EXTENDED THREAT DETECTED! 🔊")
    print(" " * 20)
    return True

# New function for continuous alert until stopped
def play_continuous_alert(duration_seconds=10):
    """Play continuous alert sound for specified duration"""
    print(f" Playing continuous alert for {duration_seconds} seconds...")
    
    try:
        import winsound
        start_time = time.time()
        
        while time.time() - start_time < duration_seconds:
            winsound.Beep(1200, 300)
            time.sleep(0.2)
            winsound.Beep(1200, 300)
            time.sleep(0.5)  # Pattern repeats every 1 second
            
        print(" Continuous alert finished")
        
    except:
        # Fallback: visual countdown
        print(" CONTINUOUS VISUAL ALERT ACTIVATED")
        for i in range(duration_seconds):
            print(f" ALERT: {duration_seconds - i}s remaining")
            time.sleep(1)

# New function for escalating alarm
def play_escalating_alarm():
    """Play alarm that gets more intense"""
    print(" Playing escalating alarm...")
    
    try:
        import winsound
        
        # Phase 1: Gentle alert
        for i in range(2):
            winsound.Beep(800, 300)
            time.sleep(0.5)
            
        # Phase 2: Medium urgency
        for i in range(3):
            winsound.Beep(1200, 400)
            time.sleep(0.3)
            
        # Phase 3: High urgency
        for i in range(4):
            winsound.Beep(1500, 500)
            time.sleep(0.2)
            
        print(" Escalating alarm finished")
        
    except:
        print(" ESCALATING ALARM: !!! INCREASING URGENCY !!!")