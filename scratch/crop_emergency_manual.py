import os
from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495333632.png"
img = Image.open(img_path)
img_rgba = img.convert("RGBA")

def make_transparent(crop_img, tolerance=250):
    crop_img = crop_img.convert("RGBA")
    pixels = crop_img.load()
    width, height = crop_img.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            # Replace pure white or very close to pure white with transparent
            if r >= tolerance and g >= tolerance and b >= tolerance:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

# Refined manually tuned clean bounding boxes (x0, y0, x1, y1)
manual_targets = {
    "module7_emergency_siren": (665, 25, 755, 85),
    "module7_emergency_cross": (446, 172, 554, 298),
    "module7_emergency_arrow_left": (398, 218, 442, 246),
    "module7_emergency_arrow_right": (558, 218, 602, 246),
    "module7_emergency_hospital": (412, 301, 592, 465),
    
    # Left Panel (Red)
    "module7_emergency_l1_black_stoma": (48, 192, 116, 265),
    "module7_emergency_l2_no_output": (48, 275, 122, 358),
    "module7_emergency_l3_blood": (46, 372, 108, 442),
    "module7_emergency_l4_vomit": (38, 450, 120, 540),
    
    # Right Panel (Orange)
    "module7_emergency_r1_color_change": (622, 182, 690, 268),
    "module7_emergency_r2_excessive": (630, 278, 688, 358),
    "module7_emergency_r3_infection": (622, 366, 690, 446),
    "module7_emergency_r4_pain": (620, 452, 702, 544),
}

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

for name, box in manual_targets.items():
    crop = img_rgba.crop(box)
    crop = make_transparent(crop)
    save_path = os.path.join(output_dir, f"{name}.png")
    crop.save(save_path)
    print(f"Manually cropped and saved {name}.png with size {crop.size}")
