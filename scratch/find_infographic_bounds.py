import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

with Image.open(image_path) as img:
    w, h = img.size
    rgb_img = img.convert("RGB")
    
    # 9 rows and the bottom character
    # We define rough Y boundaries to search within for each group
    search_ranges = [
        ("can_do_walking", 185, 275),
        ("can_do_yoga_stretch", 245, 375),
        ("can_do_swimming", 355, 435),
        ("can_do_sports", 420, 545),
        ("can_do_hydration", 495, 580),
        ("avoid_lifting", 580, 675),
        ("avoid_pressure", 670, 755),
        ("avoid_contact", 745, 845),
        ("avoid_symptoms", 795, 905),
        ("remember_character", 880, 1024)
    ]
    
    print("Detected bounds for each infographic element:")
    for name, y_min, y_max in search_ranges:
        pixels = []
        # For character, search X from 500 to w. For others, search X from 250 to w.
        x_start = 500 if name == "remember_character" else 250
        for x in range(x_start, w):
            for y in range(y_min, y_max):
                r, g, b = rgb_img.getpixel((x, y))
                # If pixel is not white background (using a threshold of 244)
                if r < 244 or g < 244 or b < 244:
                    pixels.append((x, y))
                    
        if pixels:
            xs = [p[0] for p in pixels]
            ys = [p[1] for p in pixels]
            # Print with a small 2px padding
            pad_xmin = max(0, min(xs) - 2)
            pad_ymin = max(0, min(ys) - 2)
            pad_xmax = min(w, max(xs) + 2)
            pad_ymax = min(h, max(ys) + 2)
            print(f"'{name}': crop_box = ({pad_xmin}, {pad_ymin}, {pad_xmax}, {pad_ymax})")
        else:
            print(f"'{name}': no pixels found")
