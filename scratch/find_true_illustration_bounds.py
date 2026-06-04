import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

with Image.open(image_path) as img:
    w, h = img.size
    rgb_img = img.convert("RGB")
    
    search_ranges = [
        ("module6_sports_walking.png", 183, 276),
        ("module6_sports_yoga_stretch.png", 243, 376),
        ("module6_sports_swimming.png", 353, 436),
        ("module6_sports_sports.png", 418, 546),
        ("module6_sports_hydration.png", 493, 578),
        ("module6_avoid_lifting.png", 585, 676),
        ("module6_avoid_pressure.png", 668, 756),
        ("module6_avoid_contact.png", 743, 846),
        ("module6_avoid_symptoms.png", 793, 903)
    ]
    
    print("True bounds (excluding card borders):")
    for filename, y_min, y_max in search_ranges:
        pixels = []
        # Search X from 250 to 650 (exclude right card border)
        for x in range(250, 650):
            for y in range(y_min, y_max):
                r, g, b = rgb_img.getpixel((x, y))
                # Check for non-white/non-bg pixels
                if r < 242 or g < 242 or b < 242:
                    pixels.append((x, y))
                    
        if pixels:
            xs = [p[0] for p in pixels]
            ys = [p[1] for p in pixels]
            pad_xmin = max(250, min(xs) - 2)
            pad_ymin = max(y_min, min(ys) - 2)
            pad_xmax = min(650, max(xs) + 2)
            pad_ymax = min(y_max, max(ys) + 2)
            print(f"'{filename}': ({pad_xmin}, {pad_ymin}, {pad_xmax}, {pad_ymax}), size=({pad_xmax - pad_xmin}x{pad_ymax - pad_ymin})")
        else:
            print(f"'{filename}': no pixels found")
