from PIL import Image
import numpy as np

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    width, height = img.size
    y_min, y_max = 180, 276
    
    # Let's check non-white pixels in this row range
    col_has_pixels = []
    for x in range(width):
        has_pixel = False
        for y in range(y_min, y_max):
            r, g, b = rgb.getpixel((x, y))
            # Background is white (255, 255, 255)
            if r < 240 or g < 240 or b < 240:
                has_pixel = True
                break
        col_has_pixels.append(has_pixel)
        
    # Print the index and value
    ranges = []
    start = None
    for x, val in enumerate(col_has_pixels):
        if val:
            if start is None:
                start = x
        else:
            if start is not None:
                ranges.append((start, x - 1))
                start = None
    if start is not None:
        ranges.append((start, width - 1))
        
    print("Row 1 ranges of non-white pixels:", ranges)
