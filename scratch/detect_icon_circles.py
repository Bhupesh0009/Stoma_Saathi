import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's search for icon pixels (pink circle background or red graphic) in Y: 680 to 820
def is_icon_pixel(rgb):
    r, g, b = rgb
    # check if it is red/pink (the circle or its contents)
    return r > 110 and r > g * 1.07 and r > b * 1.07

print("Detecting icon boundaries:")
for i in range(6):
    x_start = int(i * (width / 6))
    x_end = int((i + 1) * (width / 6))
    
    icon_pixels = []
    for y in range(680, 810):
        for x in range(x_start, x_end):
            if is_icon_pixel(pixels[x, y]):
                icon_pixels.append((x, y))
                
    if icon_pixels:
        xs = [p[0] for p in icon_pixels]
        ys = [p[1] for p in icon_pixels]
        x_min, x_max = min(xs), max(xs)
        y_min, y_max = min(ys), max(ys)
        w = x_max - x_min + 1
        h = y_max - y_min + 1
        cx = (x_min + x_max) / 2
        cy = (y_min + y_max) / 2
        print(f"Icon {i+1}: X: {x_min}..{x_max} (w={w}), Y: {y_min}..{y_max} (h={h}) | Center: ({cx:.1f}, {cy:.1f})")
    else:
        print(f"Icon {i+1}: No pixels found")
