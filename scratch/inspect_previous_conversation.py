import os
from PIL import Image

prev_dir = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7"
for f in os.listdir(prev_dir):
    if f.lower().endswith(('.png', '.jpg', '.jpeg')):
        path = os.path.join(prev_dir, f)
        try:
            with Image.open(path) as img:
                print(f"{f}: {img.size}")
        except Exception as e:
            pass
