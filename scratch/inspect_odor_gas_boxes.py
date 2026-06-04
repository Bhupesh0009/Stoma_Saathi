from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498778528.png"
img = Image.open(img_path).convert("RGBA")
w, h = img.size
print(f"Mockup size: {w}x{h}")

# Define generous search boxes
# Left Column: X in [10, 190], Y for items
# Right Column: X in [410, 590], Y for items
regions = {
    "gas_eat": (5, 90, 200, 290),
    "gas_carbonated": (5, 260, 200, 420),
    "gas_limit": (5, 410, 200, 580),
    
    "odor_curd": (400, 90, 600, 290),
    "odor_water": (400, 260, 600, 420),
    "odor_pouch": (400, 410, 600, 580),
}

def get_tight_bbox(crop_img, threshold=250):
    pixels = crop_img.load()
    cw, ch = crop_img.size
    min_x, min_y = cw, ch
    max_x = max_y = 0
    found = False
    for y in range(ch):
        for x in range(cw):
            r, g, b, a = pixels[x, y]
            # If pixel is not white
            if (r + g + b) / 3 < threshold:
                found = True
                if x < min_x: min_x = x
                if y < min_y: min_y = y
                if x > max_x: max_x = x
                if y > max_y: max_y = y
    if found:
        return (min_x, min_y, max_x, max_y)
    return None

for name, box in regions.items():
    crop = img.crop(box)
    bbox = get_tight_bbox(crop)
    if bbox:
        abs_box = (box[0] + bbox[0], box[1] + bbox[1], box[0] + bbox[2], box[1] + bbox[3])
        print(f"{name}: generous={box}, tight={abs_box}, size={abs_box[2]-abs_box[0]}x{abs_box[3]-abs_box[1]}")
    else:
        print(f"{name}: not found in {box}")
