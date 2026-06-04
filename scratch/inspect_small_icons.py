from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498319169.png"
img = Image.open(img_path).convert("RGBA")

# Bounding box detector
def get_bbox(crop_img, threshold=250):
    pixels = crop_img.load()
    w, h = crop_img.size
    min_x, min_y = w, h
    max_x = max_y = 0
    found = False
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if (r + g + b) / 3 < threshold:
                found = True
                if x < min_x: min_x = x
                if y < min_y: min_y = y
                if x > max_x: max_x = x
                if y > max_y: max_y = y
    if found:
        return (min_x, min_y, max_x, max_y)
    return None

# Search regions
regions = {
    "droplet": (240, 220, 310, 290),
    "ors": (240, 295, 310, 375),
    "buttermilk": (240, 410, 310, 495),
}

for name, box in regions.items():
    crop = img.crop(box)
    bbox = get_bbox(crop)
    if bbox:
        abs_box = (box[0] + bbox[0], box[1] + bbox[1], box[0] + bbox[2], box[1] + bbox[3])
        print(f"{name} absolute bbox: X: {abs_box[0]} to {abs_box[2]}, Y: {abs_box[1]} to {abs_box[4-1]}")
    else:
        print(f"{name} not found in {box}")
