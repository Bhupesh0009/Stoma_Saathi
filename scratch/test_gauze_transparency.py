import os
from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
crop = img.convert("RGBA").crop((660, 755, 805, 915))
w, h = crop.size

# Let's count how many pixels inside the gauze area have very high brightness
# The gauze area is roughly in the center of the crop
pixels = crop.load()
high_pixels = 0
for y in range(30, h - 30):
    for x in range(30, w - 30):
        r, g, b, a = pixels[x, y]
        if (r + g + b) / 3 >= 248:
            high_pixels += 1

print(f"Total interior pixels: {(w-60)*(h-60)}")
print(f"Interior pixels with brightness >= 248: {high_pixels}")
