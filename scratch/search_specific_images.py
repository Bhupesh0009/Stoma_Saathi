import os
from PIL import Image

keywords = ['patient', 'nurse', 'warning', 'everyday', 'module7', 'home_7']
print("Matching images in assets/images:")
for root, dirs, files in os.walk(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"):
    for f in files:
        if f.lower().endswith(('.png', '.jpg', '.jpeg')):
            match = any(kw in f.lower() for kw in keywords) or '7' in f
            if match:
                path = os.path.join(root, f)
                try:
                    with Image.open(path) as img:
                        print(f"{f}: {img.size}")
                except Exception as e:
                    print(f"Error {f}: {e}")
