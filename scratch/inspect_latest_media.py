import os
import glob

brain_dir = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b"
files = glob.glob(os.path.join(brain_dir, "media__*"))
files.sort(key=os.path.getmtime)

print("Media files sorted by modification time:")
for f in files:
    print(f"{os.path.basename(f)}: size={os.path.getsize(f)} bytes, modified={os.path.getmtime(f)}")
