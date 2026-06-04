import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Search for red banner pixels (R high, G and B low) in Y: 600 to 710
print("Finding red banner:")
red_pixels = []
for y in range(600, 710):
    for x in range(width):
        r, g, b = pixels[x, y]
        if r >= 180 and g <= 80 and b <= 80:
            red_pixels.append((x, y))

if red_pixels:
    xs = [p[0] for p in red_pixels]
    ys = [p[1] for p in red_pixels]
    print(f"Red banner box: X: {min(xs)}..{max(xs)}, Y: {min(ys)}..{max(ys)}")
else:
    print("No red banner pixels found")
