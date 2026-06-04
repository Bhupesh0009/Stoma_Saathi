import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")

print("Horizontal line profile at Y = 735:")
for x in range(20, 130, 2):
    r, g, b = img.getpixel((x, 735))
    print(f"X={x}: RGB=({r}, {g}, {b})")
