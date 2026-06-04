import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

if not os.path.exists(image_path):
    print("Reference image not found!")
    exit(0)

with Image.open(image_path) as img:
    w, h = img.size
    print(f"Image dimensions: {w}x{h}")
    
    # Let's save a copy with a horizontal coordinate grid (lines every 20 pixels)
    # so we can visually read the coordinates if we want.
    # We will write the coordinates on the image or just output color changes.
    
    # Let's also scan the center column (x = w // 2) for background color changes.
    # The background of Section 1 is white. Section 2 is light pink/red. Remember is light yellow.
    rgb_img = img.convert("RGB")
    
    # We can print pixel colors along a column to find background shifts
    # Let's check x = 100 (left side text area)
    x = 100
    for y in range(0, h, 10):
        color = rgb_img.getpixel((x, y))
        print(f"y={y:4d}: RGB={color}")
