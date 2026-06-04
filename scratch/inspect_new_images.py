import os
from PIL import Image

brain_dir = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7"

file1 = os.path.join(brain_dir, "media__1780240657025.png")
file2 = os.path.join(brain_dir, "media__1780240779442.jpg")

for name, filepath in [("file1", file1), ("file2", file2)]:
    if os.path.exists(filepath):
        with Image.open(filepath) as img:
            print(f"{name} ({os.path.basename(filepath)}): size={img.size}, format={img.format}")
    else:
        print(f"{name} ({filepath}) does not exist")
