import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780242540022.png"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

if not os.path.exists(output_dir):
    os.makedirs(output_dir, exist_ok=True)

def make_bg_transparent(img, threshold=245):
    rgba = img.convert("RGBA")
    data = rgba.getdata()
    new_data = []
    for item in data:
        r, g, b, a = item
        # If the pixel is close to white/cream
        if r >= threshold and g >= threshold and b >= threshold - 5:
            new_data.append((255, 255, 255, 0)) # transparent
        else:
            new_data.append(item)
    rgba.putdata(new_data)
    return rgba

with Image.open(image_path) as img:
    # 1. Toilet icon in header (transparent bg)
    toilet = img.crop((375, 18, 455, 82))
    rgba_toilet = toilet.convert("RGBA")
    toilet_data = rgba_toilet.getdata()
    new_toilet_data = []
    for item in toilet_data:
        r, g, b, a = item
        dist_green = abs(r - 78) + abs(g - 141) + abs(b - 58)
        if dist_green < 80 or (g > r + 20 and g > b + 20):
            new_toilet_data.append((255, 255, 255, 0))
        else:
            new_toilet_data.append(item)
    rgba_toilet.putdata(new_toilet_data)
    rgba_toilet.save(os.path.join(output_dir, "module6_restroom_header_toilet.png"), "PNG")
    print("Saved module6_restroom_header_toilet.png")
    
    # 2. Row 1: Tissue box + Wipes
    row1 = img.crop((20, 155, 240, 275))
    row1_trans = make_bg_transparent(row1)
    row1_trans.save(os.path.join(output_dir, "module6_restroom_tips_row1.png"), "PNG")
    print("Saved module6_restroom_tips_row1.png")
    
    # 3. Row 2: Sanitizer bottle
    row2 = img.crop((45, 285, 175, 409))
    row2_trans = make_bg_transparent(row2)
    row2_trans.save(os.path.join(output_dir, "module6_restroom_tips_row2.png"), "PNG")
    print("Saved module6_restroom_tips_row2.png")
    
    # 4. Row 3: Clock
    row3 = img.crop((40, 420, 150, 528))
    row3_trans = make_bg_transparent(row3)
    row3_trans.save(os.path.join(output_dir, "module6_restroom_tips_row3.png"), "PNG")
    print("Saved module6_restroom_tips_row3.png")
    
    # 5. Restroom scene (kept as is, no transparency needed)
    scene = img.crop((0, 535, 468, 685))
    scene.save(os.path.join(output_dir, "module6_restroom_scene.png"), "PNG")
    print("Saved module6_restroom_scene.png")

print("All restroom illustrations cropped and saved successfully!")
