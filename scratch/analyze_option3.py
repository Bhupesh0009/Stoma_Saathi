import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240779442.jpg"

if not os.path.exists(image_path):
    print("Image does not exist!")
    exit(0)

with Image.open(image_path) as img:
    w, h = img.size
    print(f"Dimensions: {w}x{h}")
    
    # We want to scan the image to find:
    # 1. Blue measuring guide: where is the blue region?
    # 2. Baseplate: where is the tan/skin-colored region?
    
    rgb_img = img.convert("RGB")
    
    # Let's find pixels that are "blue" (e.g. B > 150 and R < 100) or similar
    blue_pixels = []
    tan_pixels = []
    for x in range(w):
        for y in range(h):
            r, g, b = rgb_img.getpixel((x, y))
            # Blue card: check for blue-ish color
            if b > 150 and r < 100 and g > 100:
                blue_pixels.append((x, y))
            # Tan baseplate: check for flesh/beige tones (R around 220-245, G around 180-210, B around 150-185)
            if 200 < r < 250 and 160 < g < 220 and 130 < b < 190:
                tan_pixels.append((x, y))
                
    if blue_pixels:
        xs = [p[0] for p in blue_pixels]
        ys = [p[1] for p in blue_pixels]
        print(f"Blue region bounds: X:({min(xs)} to {max(xs)}), Y:({min(ys)} to {max(ys)})")
    else:
        print("No blue region found")
        
    if tan_pixels:
        xs = [p[0] for p in tan_pixels]
        ys = [p[1] for p in tan_pixels]
        print(f"Tan region bounds: X:({min(xs)} to {max(xs)}), Y:({min(ys)} to {max(ys)})")
    else:
        print("No tan region found")
