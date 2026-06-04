import os
from PIL import Image

brain_dir = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7"

files = [
    "media__1780241053510.png",
    "media__1780241061404.png",
    "media__1780241182565.png",
    "media__1780241417268.jpg"
]

for filename in files:
    filepath = os.path.join(brain_dir, filename)
    if os.path.exists(filepath):
        with Image.open(filepath) as img:
            print(f"{filename}: size={img.size}, format={img.format}")
    else:
        print(f"{filename} does not exist")
