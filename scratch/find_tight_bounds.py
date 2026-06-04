import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

def color_dist(c1, c2):
    return sum(abs(a - b) for a, b in zip(c1, c2))

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
    
    print("New tight crop boxes:")
    for filename, y_min, y_max in search_ranges:
        sample_x = 252
        sample_y = (y_min + y_max) // 2
        bg_color = rgb_img.getpixel((sample_x, sample_y))
        
        pixels = []
        # Exclude 6px top and bottom to avoid horizontal dividers/lines
        for x in range(250, 655):
            for y in range(y_min + 6, y_max - 6):
                color = rgb_img.getpixel((x, y))
                if color_dist(color, bg_color) > 15:
                    pixels.append((x, y))
                    
        if pixels:
            xs = [p[0] for p in pixels]
            ys = [p[1] for p in pixels]
            xmin = max(250, min(xs) - 2)
            ymin = max(y_min, min(ys) - 2)
            xmax = min(655, max(xs) + 2)
            ymax = min(y_max, max(ys) + 2)
            print(f"'{filename}': ({xmin}, {ymin}, {xmax}, {ymax}), size=({xmax-xmin}x{ymax-ymin})")
        else:
            print(f"'{filename}': no pixels found")
