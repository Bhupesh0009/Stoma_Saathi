import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

with Image.open(image_path) as img:
    w, h = img.size
    rgb_img = img.convert("RGB")
    
    # 1. Locate running shield icon (left side, Y: 50 to 140, X: 10 to 120)
    left_pixels = []
    for x in range(10, 120):
        for y in range(50, 140):
            r, g, b = rgb_img.getpixel((x, y))
            # Background is white/off-white (threshold 244)
            if r < 244 or g < 244 or b < 244:
                left_pixels.append((x, y))
                
    if left_pixels:
        xs = [p[0] for p in left_pixels]
        ys = [p[1] for p in left_pixels]
        shield_box = (min(xs) - 2, min(ys) - 2, max(xs) + 2, max(ys) + 2)
        print(f"Running shield box: {shield_box}")
        shield = img.crop(shield_box)
        shield.save(os.path.join(output_dir, "module6_sports_shield.png"), "PNG")
    else:
        print("Running shield not found")
        
    # 2. Locate ostomy pouch (right side, Y: 50 to 140, X: 550 to w - 10)
    right_pixels = []
    for x in range(550, w - 10):
        for y in range(50, 140):
            r, g, b = rgb_img.getpixel((x, y))
            if r < 244 or g < 244 or b < 244:
                right_pixels.append((x, y))
                
    if right_pixels:
        xs = [p[0] for p in right_pixels]
        ys = [p[1] for p in right_pixels]
        pouch_box = (min(xs) - 2, min(ys) - 2, max(xs) + 2, max(ys) + 2)
        print(f"Pouch box: {pouch_box}")
        pouch = img.crop(pouch_box)
        pouch.save(os.path.join(output_dir, "module6_sports_pouch.png"), "PNG")
    else:
        print("Pouch not found")

print("Header icons crop completed!")
