import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Background is generally #F8FAFA, let's check what RGB is in this image.
# We'll sample a few white-ish areas.
bg_color = (248, 250, 250)
def is_bg(rgb, thresh=242):
    r, g, b = rgb
    return r >= thresh and g >= thresh and b >= thresh

# Let's write a function to find the tight bounding box of non-background pixels in a given search box.
def find_tight_box(x_range, y_range):
    left, right = x_range[1], x_range[0]
    top, bottom = y_range[1], y_range[0]
    
    for y in range(y_range[0], y_range[1]):
        for x in range(x_range[0], x_range[1]):
            if not is_bg(pixels[x, y]):
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = bottom = y
                
    # Return tight box with 2px padding if found
    if right >= left and bottom >= top:
        return (max(0, left-2), max(0, top-2), min(width, right+2), min(height, bottom+2))
    return None

# 1. Top Shield (Y: 30 to 120, X: 280 to 400)
top_shield_box = find_tight_box((280, 400), (30, 120))
print("Top Shield Box:", top_shield_box)

# 2. Card 1 Info Book (Y: 215 to 330, X: 45 to 160)
info_book_box = find_tight_box((45, 160), (215, 330))
print("Info Book Box:", info_book_box)

# 3. Card 2 Stethoscope 'x' (Y: 335 to 455, X: 45 to 160)
steth_x_box = find_tight_box((45, 160), (335, 455))
print("Stethoscope 'x' Box:", steth_x_box)

# 4. Card 3 Nurse '+' (Y: 455 to 580, X: 45 to 160)
nurse_plus_box = find_tight_box((45, 160), (455, 580))
print("Nurse '+' Box:", nurse_plus_box)

# 5. Card 4 Hands Heart (Y: 825 to 945, X: 45 to 160)
hands_heart_box = find_tight_box((45, 160), (825, 945))
print("Hands Heart Box:", hands_heart_box)

# 6. The 6 emergency circular icons:
# Let's divide the width into 6 zones and find tight boxes in Y: 685 to 810
em_boxes = []
zone_width = width // 6
for i in range(6):
    x_start = i * zone_width
    x_end = (i + 1) * zone_width
    # Search within the zone
    box = find_tight_box((x_start, x_end), (685, 810))
    em_boxes.append(box)
    print(f"Emergency Icon {i+1} Box:", box)
