from PIL import Image
import os

for f in os.listdir(r"c:\Users\Bhupesh\Desktop\Stoma Saathi"):
    if f.startswith("flutter_") and f.endswith(".png"):
        path = os.path.join(r"c:\Users\Bhupesh\Desktop\Stoma Saathi", f)
        try:
            with Image.open(path) as img:
                print(f"{f}: {img.size} aspect ratio: {img.size[0]/img.size[1]:.2f}")
        except Exception as e:
            print(f"Error reading {f}: {e}")
