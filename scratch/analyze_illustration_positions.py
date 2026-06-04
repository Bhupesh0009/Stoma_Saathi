import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

search_ranges = [
    ("module6_sports_walking.png", 180, 276),
    ("module6_sports_yoga_stretch.png", 243, 376),
    ("module6_sports_swimming.png", 353, 436),
    ("module6_sports_sports.png", 418, 546),
    ("module6_sports_hydration.png", 493, 578),
    ("module6_avoid_lifting.png", 585, 676),
    ("module6_avoid_pressure.png", 668, 756),
    ("module6_avoid_contact.png", 743, 846),
    ("module6_avoid_symptoms.png", 793, 903),
    ("module6_sports_character.png", 878, 1016)
]

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    width, height = img.size
    for name, y_min, y_max in search_ranges:
        print(f"--- {name} (Y: {y_min} to {y_max}) ---")
        # For each X from 0 to width-1, check if there are non-background pixels in this row range.
        # Since background of the card might be slightly tinted or white, let's look at pixel values.
        # Let's count how many non-background pixels are in each column.
        bg_pixels_count = []
        for x in range(width):
            non_bg_count = 0
            for y in range(y_min, y_max):
                r, g, b = rgb.getpixel((x, y))
                # Background is typically white (255,255,255) or very light green/red.
                # Let's see if it's far from pure white or card background color.
                # A threshold of 240 is usually safe to detect drawings.
                if r < 240 or g < 240 or b < 240:
                    non_bg_count += 1
            bg_pixels_count.append(non_bg_count)
        
        # Let's print out intervals of X where there's significant drawing content.
        # We can print X ranges where non_bg_count > 3.
        active_ranges = []
        start_x = None
        for x, count in enumerate(bg_pixels_count):
            if count > 2:
                if start_x is None:
                    start_x = x
            else:
                if start_x is not None:
                    active_ranges.append((start_x, x - 1))
                    start_x = None
        if start_x is not None:
            active_ranges.append((start_x, width - 1))
            
        print("Active X ranges:", active_ranges)
