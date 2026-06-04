import os
from PIL import Image

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\scratch"
img = Image.open(os.path.join(output_dir, "ref_branding.png")).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's count non-white pixels
non_white = 0
for y in range(height):
    for x in range(width):
        r, g, b = pixels[x, y]
        if not (r >= 240 and g >= 240 and b >= 240):
            non_white += 1

print(f"ref_branding.png size: {width}x{height}, non-white pixels: {non_white}")
if non_white > 0:
    # Print some non-white pixel colors and their coords
    printed = 0
    for y in range(height):
        for x in range(width):
            r, g, b = pixels[x, y]
            if not (r >= 245 and g >= 245 and b >= 245):
                print(f"Pixel at ({x}, {y}): ({r}, {g}, {b})")
                printed += 1
                if printed >= 20:
                    break
        if printed >= 20:
            break
