from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498778528.png"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

img = Image.open(img_path).convert("RGBA")

# Define generous search boxes
# Left Column: X in [25, 175], Y for items
# Right Column: X in [430, 570], Y for items
generous_regions = {
    "module4_tips_gas_eat.png": (25, 110, 175, 265),
    "module4_tips_gas_carbonated.png": (25, 270, 175, 400),
    "module4_tips_gas_limit.png": (25, 410, 175, 530),
    
    "module4_tips_odor_curd.png": (430, 110, 570, 265),
    "module4_tips_odor_water.png": (430, 270, 570, 400),
    "module4_tips_odor_pouch.png": (430, 410, 570, 540),
}

def make_transparent_and_trim(crop_img, threshold=245):
    # Load pixels
    pixels = crop_img.load()
    w, h = crop_img.size
    
    # Pass 1: Make all near-white pixels transparent
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if (r + g + b) / 3 >= threshold:
                pixels[x, y] = (255, 255, 255, 0)
                
    # Pass 2: Find tight bounding box of remaining non-transparent pixels
    min_x, min_y = w, h
    max_x = max_y = 0
    found = False
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if a > 0:  # Non-transparent
                found = True
                if x < min_x: min_x = x
                if y < min_y: min_y = y
                if x > max_x: max_x = x
                if y > max_y: max_y = y
                
    if found:
        return crop_img.crop((min_x, min_y, max_x + 1, max_y + 1))
    return crop_img

for filename, box in generous_regions.items():
    # Crop the generous region
    crop_img = img.crop(box)
    # Process transparency and trim
    trimmed = make_transparent_and_trim(crop_img)
    # Save the processed image
    save_path = os.path.join(output_dir, filename)
    trimmed.save(save_path)
    print(f"Saved {filename}: final size={trimmed.size}")
