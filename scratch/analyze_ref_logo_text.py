import os
from PIL import Image

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\scratch"
img = Image.open(os.path.join(output_dir, "ref_logo_section.png")).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's count non-white pixels horizontally to find where the text lines are vertically
# We'll print the Y range and the width of non-white pixels in each row
print("Vertical density of ref_logo_section.png:")
for y in range(height):
    non_white = 0
    for x in range(width):
        r, g, b = pixels[x, y]
        if not (r >= 244 and g >= 244 and b >= 244):
            non_white += 1
    if non_white > 2:
        print(f"Row Y={y}: {non_white} non-white pixels")
