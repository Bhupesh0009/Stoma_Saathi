from PIL import Image
import os

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240779442.jpg"

with Image.open(image_path) as img:
    w, h = img.size
    rgb_img = img.convert("RGB")
    
    # 1. Locate scissors:
    # Look in right half (X from 520 to w) and Y from 220 to 360 (below the SCISSORS badge)
    # Scissors are gray/metallic, background is white/off-white.
    # We look for pixels where R < 235, G < 235, B < 235 (not white background)
    scissors_pixels = []
    for x in range(520, w):
        for y in range(220, 360):
            r, g, b = rgb_img.getpixel((x, y))
            # check if it is darker than background
            if r < 235 and g < 235 and b < 235:
                scissors_pixels.append((x, y))
                
    if scissors_pixels:
        xs = [p[0] for p in scissors_pixels]
        ys = [p[1] for p in scissors_pixels]
        print(f"Scissors exact bounds: X:({min(xs)} to {max(xs)}), Y:({min(ys)} to {max(ys)})")
    else:
        print("No scissors pixels found")
        
    # 2. Locate baseplate:
    # Look in right half (X from 520 to w) and Y from 340 to 670 (below the scissors)
    # Baseplate is tan/beige.
    tan_pixels = []
    for x in range(520, w):
        for y in range(340, 670):
            r, g, b = rgb_img.getpixel((x, y))
            # Beige check
            if 200 < r < 250 and 160 < g < 220 and 130 < b < 190:
                tan_pixels.append((x, y))
                
    if tan_pixels:
        xs = [p[0] for p in tan_pixels]
        ys = [p[1] for p in tan_pixels]
        print(f"Baseplate exact bounds: X:({min(xs)} to {max(xs)}), Y:({min(ys)} to {max(ys)})")
    else:
        print("No baseplate pixels found")
