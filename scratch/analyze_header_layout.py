import os
from PIL import Image

image_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\scratch\ref_header.png"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's find distinct colored regions in the header
# wave: color #D5EAE8 (r ~ 213, g ~ 234, b ~ 232)
# title/shield: dark teal (r < 50, 50 < g < 120, 50 < b < 120)
# branding text/logo: we already know it's in X: 480..662, Y: 16..179

wave_pixels = []
teal_pixels = []

for y in range(height):
    for x in range(width):
        r, g, b = pixels[x, y]
        # wave check
        if 205 <= r <= 220 and 225 <= g <= 240 and 220 <= b <= 238:
            wave_pixels.append((x, y))
        # teal check
        elif r < 60 and 50 <= g <= 120 and 50 <= b <= 120:
            teal_pixels.append((x, y))

if wave_pixels:
    xs = [p[0] for p in wave_pixels]
    ys = [p[1] for p in wave_pixels]
    print(f"Wave bounding box: X: {min(xs)}..{max(xs)}, Y: {min(ys)}..{max(ys)}")

if teal_pixels:
    # Let's filter out pixels in the branding region (X > 480)
    teal_left = [p for p in teal_pixels if p[0] < 470]
    if teal_left:
        xs = [p[0] for p in teal_left]
        ys = [p[1] for p in teal_left]
        print(f"Left/Center Teal bounding box (Title/Shield): X: {min(xs)}..{max(xs)}, Y: {min(ys)}..{max(ys)}")
