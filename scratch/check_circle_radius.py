import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")

print("Icon 1 pixels:")
for dy in [-20, -10, 0, 10, 20]:
    for dx in [-20, -10, 0, 10, 20]:
        r, g, b = img.getpixel((56 + dx, 734 + dy))
        print(f"dx={dx}, dy={dy}: ({r}, {g}, {b})")

print("\nIcon 3 pixels:")
for dy in [-20, -10, 0, 10, 20]:
    for dx in [-20, -10, 0, 10, 20]:
        r, g, b = img.getpixel((283 + dx, 734 + dy))
        print(f"dx={dx}, dy={dy}: ({r}, {g}, {b})")
