import os
from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495333632.png"
img = Image.open(img_path)
w, h = img.size
img_rgba = img.convert("RGBA")

def get_non_white_bbox(im, x0, y0, x1, y1, tolerance=248):
    left = x1
    right = x0
    top = y1
    bottom = y0
    
    pixels = im.load()
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            if r < tolerance or g < tolerance or b < tolerance:
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
                
    if not found:
        return None
    return (left, top, right + 1, bottom + 1)

def make_transparent(crop_img, tolerance=248):
    crop_img = crop_img.convert("RGBA")
    pixels = crop_img.load()
    width, height = crop_img.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if r > tolerance and g > tolerance and b > tolerance:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

# Define all target assets
targets = {
    "module7_emergency_siren": (660, 20, 760, 90),
    "module7_emergency_cross": (430, 170, 570, 300),
    "module7_emergency_arrow_left": (400, 210, 445, 250),
    "module7_emergency_arrow_right": (555, 210, 600, 250),
    "module7_emergency_hospital": (405, 300, 595, 480),
    
    # Left Panel (Red)
    "module7_emergency_l1_black_stoma": (30, 175, 125, 250),
    "module7_emergency_l2_no_output": (30, 250, 125, 340),
    "module7_emergency_l3_blood": (30, 340, 125, 430),
    "module7_emergency_l4_vomit": (30, 430, 125, 520),
    
    # Right Panel (Orange)
    "module7_emergency_r1_color_change": (600, 175, 730, 250),
    "module7_emergency_r2_excessive": (600, 250, 730, 340),
    "module7_emergency_r3_infection": (600, 340, 730, 430),
    "module7_emergency_r4_pain": (600, 430, 730, 520),
}

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

for name, box_limits in targets.items():
    x0, y0, x1, y1 = box_limits
    bbox = get_non_white_bbox(img_rgba, x0, y0, x1, y1)
    if bbox:
        print(f"Detected bounding box for {name}: {bbox}")
        # Crop with 1px padding
        crop = img_rgba.crop((bbox[0] - 1, bbox[1] - 1, bbox[2] + 1, bbox[3] + 1))
        crop = make_transparent(crop)
        save_path = os.path.join(output_dir, f"{name}.png")
        crop.save(save_path)
        print(f"Saved {name}.png")
    else:
        print(f"WARNING: Could not find box for {name} in range {box_limits}")
