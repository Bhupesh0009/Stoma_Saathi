import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240431040.png"

if os.path.exists(image_path):
    with Image.open(image_path) as img:
        width, height = img.size
        print(f"Dimensions: {width}x{height}")
else:
    print(f"Error: {image_path} does not exist")
