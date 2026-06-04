import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's find the bounding box of non-white pixels in X: 480..670, Y: 10..180
non_white_x = []
non_white_y = []
for y in range(10, 180):
    for x in range(480, 670):
        r, g, b = pixels[x, y]
        # Check for non-white/non-bg pixel
        if not (r >= 244 and g >= 244 and b >= 244):
            non_white_x.append(x)
            non_white_y.append(y)

if non_white_x:
    print(f"Branding block in ref image: X: {min(non_white_x)}..{max(non_white_x)} (w={max(non_white_x)-min(non_white_x)}), Y: {min(non_white_y)}..{max(non_white_y)} (h={max(non_white_y)-min(non_white_y)})")
else:
    print("No branding block found")
