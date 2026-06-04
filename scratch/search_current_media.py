import os
from PIL import Image

curr_dir = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b"
print(f"Listing files in current brain dir: {curr_dir}")
if os.path.exists(curr_dir):
    for root, dirs, files in os.walk(curr_dir):
        for f in files:
            if f.lower().endswith(('.png', '.jpg', '.jpeg')):
                path = os.path.join(root, f)
                try:
                    with Image.open(path) as img:
                        print(f"Found image: {f} size: {img.size}")
                except Exception as e:
                    print(f"Error {f}: {e}")
else:
    print("Current brain dir does not exist!")
