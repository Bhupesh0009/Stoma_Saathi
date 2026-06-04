from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498778528.png"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

img = Image.open(img_path).convert("RGBA")

# Use precise non-overlapping vertical search windows
# Header banner ends at Y=70
# Pill heading: Y in [90, 135]
# Item 1: Y in [135, 260]
# Item 2: Y in [280, 400]
# Item 3: Y in [415, 545]
precise_regions = {
    "module4_tips_gas_eat.png": (25, 135, 165, 260),
    "module4_tips_gas_carbonated.png": (25, 280, 165, 400),
    "module4_tips_gas_limit.png": (25, 415, 165, 545),
    
    "module4_tips_odor_curd.png": (435, 135, 565, 260),
    "module4_tips_odor_water.png": (435, 280, 565, 400),
    "module4_tips_odor_pouch.png": (435, 415, 565, 545),
}

def make_transparent_and_trim(crop_img, threshold=245):
    pixels = crop_img.load()
    w, h = crop_img.size
    
    # 1. Make near-white pixels transparent
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if (r + g + b) / 3 >= threshold:
                pixels[x, y] = (255, 255, 255, 0)
                
    # 2. Find tight bounding box of remaining non-transparent pixels
    min_x, min_y = w, h
    max_x = max_y = 0
    found = False
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a > 0:
                found = True
                if x < min_x: min_x = x
                if y < min_y: min_y = y
                if x > max_x: max_x = x
                if y > max_y: max_y = y
                
    if found:
        return crop_img.crop((min_x, min_y, max_x + 1, max_y + 1))
    return crop_img

for filename, box in precise_regions.items():
    crop_img = img.crop(box)
    trimmed = make_transparent_and_trim(crop_img)
    save_path = os.path.join(output_dir, filename)
    trimmed.save(save_path)
    print(f"Saved {filename}: final size={trimmed.size}")
