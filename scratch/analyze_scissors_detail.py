from PIL import Image
import os

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240779442.jpg"

with Image.open(image_path) as img:
    w, h = img.size
    rgb_img = img.convert("RGB")
    
    # Let's scan from Y=120 to Y=380, and X from 520 to 1010
    # Find all dark pixels (R < 240, G < 240, B < 240)
    dark_pixels = []
    for x in range(520, w):
        for y in range(120, 380):
            r, g, b = rgb_img.getpixel((x, y))
            if r < 240 and g < 240 and b < 240:
                dark_pixels.append((x, y))
                
    if dark_pixels:
        xs = [p[0] for p in dark_pixels]
        ys = [p[1] for p in dark_pixels]
        print(f"Dark pixels bounds: X:({min(xs)} to {max(xs)}), Y:({min(ys)} to {max(ys)})")
        
        # Let's print out the min X and max X for each Y row to see the shape
        print("Vertical profile of dark pixels:")
        row_bounds = {}
        for x, y in dark_pixels:
            if y not in row_bounds:
                row_bounds[y] = [x, x]
            else:
                row_bounds[y][0] = min(row_bounds[y][0], x)
                row_bounds[y][1] = max(row_bounds[y][1], x)
                
        for y in sorted(row_bounds.keys()):
            # Only print every 5th row to keep output short
            if y % 5 == 0:
                print(f"y={y}: X-range={row_bounds[y]}")
    else:
        print("No dark pixels found")
