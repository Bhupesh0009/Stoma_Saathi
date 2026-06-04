import os
from PIL import Image

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

# Image paths
img8_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495333632.png"
img4_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"

img8 = Image.open(img8_path).convert("RGBA")
img4 = Image.open(img4_path).convert("RGBA")

# ----------------- FILTERS -----------------

def make_transparent_average(crop_img, threshold=242):
    pixels = crop_img.load()
    w, h = crop_img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if (r + g + b) / 3 >= threshold:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

def apply_circular_mask(crop_img):
    w, h = crop_img.size
    center_x = w / 2
    center_y = h / 2
    radius = min(w, h) / 2 - 1.5
    pixels = crop_img.load()
    for y in range(h):
        for x in range(w):
            dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
            if dist > radius:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

def make_transparent_cream_only(crop_img):
    # Cream is approx (255, 248, 239). White is (255, 255, 255).
    # We want to replace cream but keep white solid.
    pixels = crop_img.load()
    w, h = crop_img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            # If it's cream-colored (r >= 250, g >= 238, b >= 228 and b < 248)
            if r >= 248 and g >= 236 and b >= 228 and b < 248:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

def apply_radial_alpha_fade(crop_img, inner_radius=135, outer_radius=225):
    w, h = crop_img.size
    center_x = w / 2
    center_y = h / 2
    pixels = crop_img.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            
            # If pixel is very close to white, make it transparent
            if (r + g + b) / 3 >= 248:
                pixels[x, y] = (255, 255, 255, 0)
                continue
                
            # Exclude the connector lines on the right from the fade
            if x > center_x + 35:
                continue
                
            dist = ((x - center_x) ** 2 + (y - center_y) ** 2) ** 0.5
            if dist <= inner_radius:
                pass
            elif dist >= outer_radius:
                pixels[x, y] = (r, g, b, 0)
            else:
                factor = (outer_radius - dist) / (outer_radius - inner_radius)
                new_a = int(255 * factor)
                pixels[x, y] = (r, g, b, min(a, new_a))
    return crop_img

# ----------------- EXECUTE CROPS -----------------

print("--- CROPPING OPTION 8 (EMERGENCY) ---")
targets8 = {
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

for name, box in targets8.items():
    crop = img8.crop(box)
    crop = make_transparent_average(crop, threshold=242)
    save_path = os.path.join(output_dir, f"{name}.png")
    crop.save(save_path)
    print(f"Saved {name}.png")

print("\n--- CROPPING OPTION 4 (NORMAL STOMA) ---")
# 1. Stoma (X: 30 to 431, Y: 210 to 690) with radial fade
crop_stoma = img4.crop((30, 210, 431, 690))
crop_stoma = apply_radial_alpha_fade(crop_stoma)
crop_stoma.save(os.path.join(output_dir, "module1_normal_stoma.png"))
print("Saved module1_normal_stoma.png")

# 2. Card Icons with circular mask
icon_boxes = {
    "module1_normal_color_icon": (431, 272, 511, 352),
    "module1_normal_texture_icon": (431, 441, 511, 521),
    "module1_normal_shape_icon": (431, 609, 511, 689)
}
for name, box in icon_boxes.items():
    crop = img4.crop(box)
    crop = apply_circular_mask(crop)
    save_path = os.path.join(output_dir, f"{name}.png")
    crop.save(save_path)
    print(f"Saved {name}.png")

# 3. Bottom Card Elements (with cream-only background filter)
crop_warning = img4.crop((110, 780, 200, 870))
crop_warning = make_transparent_cream_only(crop_warning)
crop_warning.save(os.path.join(output_dir, "module1_normal_warning.png"))
print("Saved module1_normal_warning.png")

crop_gauze = img4.crop((660, 755, 805, 915))
crop_gauze = make_transparent_cream_only(crop_gauze)
crop_gauze.save(os.path.join(output_dir, "module1_normal_gauze.png"))
print("Saved module1_normal_gauze.png")
