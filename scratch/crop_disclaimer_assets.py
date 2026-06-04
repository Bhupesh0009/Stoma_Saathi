import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

img = Image.open(image_path).convert("RGB")
width, height = img.size

# Precise bounding boxes for disclaimer assets:
# 1. Top Shield (Verified check)
shield_box = (282, 32, 385, 121)

# 2. Left circular icons for cards
info_book_box = (45, 225, 153, 331)
steth_x_box = (45, 333, 153, 453)
nurse_plus_box = (45, 462, 153, 572)
hands_heart_box = (43, 823, 161, 946)

# 3. 6 Emergency icons (excluding labels underneath)
# The circles are centered in Y: 690 to 775.
# Let's crop with Y: [690, 775] and X zones:
em_y_top = 690
em_y_bottom = 775
em_width = 82

em_boxes = {
    "disclaimer_em_pain.png": (54, em_y_top, 54 + em_width, em_y_bottom),
    "disclaimer_em_bleeding.png": (158, em_y_top, 158 + em_width, em_y_bottom),
    "disclaimer_em_fever.png": (262, em_y_top, 262 + em_width, em_y_bottom),
    "disclaimer_em_leakage.png": (366, em_y_top, 366 + em_width, em_y_bottom),
    "disclaimer_em_color.png": (470, em_y_top, 470 + em_width, em_y_bottom),
    "disclaimer_em_skin.png": (574, em_y_top, 574 + em_width, em_y_bottom),
}

# Crop and save general assets
general_assets = {
    "disclaimer_shield.png": shield_box,
    "disclaimer_info_book.png": info_book_box,
    "disclaimer_steth_x.png": steth_x_box,
    "disclaimer_nurse_plus.png": nurse_plus_box,
    "disclaimer_hands_heart.png": hands_heart_box,
}

for name, box in general_assets.items():
    cropped = img.crop(box)
    cropped.save(os.path.join(output_dir, name), "PNG")
    print(f"Saved {name}")

for name, box in em_boxes.items():
    cropped = img.crop(box)
    cropped.save(os.path.join(output_dir, name), "PNG")
    print(f"Saved {name}")

# Apply transparency processing
def make_transparent(filename, threshold=245):
    filepath = os.path.join(output_dir, filename)
    img_rgba = Image.open(filepath).convert("RGBA")
    data = img_rgba.getdata()
    
    new_data = []
    for item in data:
        r, g, b, a = item
        # Make background transparent
        if r >= threshold and g >= threshold and b >= threshold:
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append(item)
            
    img_rgba.putdata(new_data)
    img_rgba.save(filepath, "PNG")
    print(f"Processed transparency for {filename}")

all_filenames = list(general_assets.keys()) + list(em_boxes.keys())
for filename in all_filenames:
    make_transparent(filename, threshold=248)
