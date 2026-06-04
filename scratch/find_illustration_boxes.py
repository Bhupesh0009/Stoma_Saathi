from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498778528.png"
img = Image.open(img_path).convert("RGBA")

# Let's search inside regions that exclude card borders
# Left card border is at X <= 22, Right card border is at X <= 422
regions = {
    "gas_eat": (25, 100, 165, 270),
    "gas_carbonated": (25, 260, 165, 410),
    "gas_limit": (25, 400, 165, 540),
    
    "odor_curd": (435, 100, 565, 270),
    "odor_water": (435, 260, 565, 410),
    "odor_pouch": (435, 400, 565, 550),
}

def get_tight_bbox(crop_img, threshold=245):
    pixels = crop_img.load()
    cw, ch = crop_img.size
    min_x, min_y = cw, ch
    max_x = max_y = 0
    found = False
    for y in range(ch):
        for x in range(cw):
            r, g, b, a = pixels[x, y]
            # average RGB less than threshold and alpha > 0
            if (r + g + b) / 3 < threshold and a > 0:
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
        print(f"{name}: tight={abs_box}, size={abs_box[2]-abs_box[0]}x{abs_box[3]-abs_box[1]}")
    else:
        print(f"{name}: not found in {box}")
