import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's search for the title "DISCLAIMER" in Y: 10..150, X: 150..530
# The title has dark teal color Color(0xFF073940) or similar.
title_pixels = []
for y in range(10, 150):
    for x in range(150, 530):
        r, g, b = pixels[x, y]
        # Dark teal check
        if r < 50 and g > 50 and g < 120 and b > 50 and b < 120:
            title_pixels.append((x, y))

if title_pixels:
    xs = [p[0] for p in title_pixels]
    ys = [p[1] for p in title_pixels]
    print(f"Title bounding box in ref image: X: {min(xs)}..{max(xs)} (w={max(xs)-min(xs)}), Y: {min(ys)}..{max(ys)} (h={max(ys)-min(ys)})")
else:
    print("Title not found in Y: 10..150")
