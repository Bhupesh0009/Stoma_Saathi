import os
from PIL import Image

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"
images_to_check = [
    # Option 8
    "module7_emergency_l1_black_stoma.png",
    "module7_emergency_l2_no_output.png",
    "module7_emergency_l3_blood.png",
    "module7_emergency_l4_vomit.png",
    "module7_emergency_r1_color_change.png",
    "module7_emergency_r2_excessive.png",
    "module7_emergency_r3_infection.png",
    "module7_emergency_r4_pain.png",
    
    # Option 4
    "module1_normal_stoma.png",
    "module1_normal_color_icon.png",
    "module1_normal_texture_icon.png",
    "module1_normal_shape_icon.png",
    "module1_normal_warning.png",
    "module1_normal_gauze.png"
]

print("--- EDGE QUALITY CHECK ---")
for name in images_to_check:
    path = os.path.join(output_dir, name)
    if not os.path.exists(path):
        print(f"{name}: FILE NOT FOUND")
        continue
    img = Image.open(path).convert("RGBA")
    w, h = img.size
    pixels = img.load()
    
    # Check top/bottom edges (Y=0, Y=h-1) for non-transparent pixels
    top_non_trans = sum(1 for x in range(w) if pixels[x, 0][3] > 0)
    bottom_non_trans = sum(1 for x in range(w) if pixels[x, h - 1][3] > 0)
    
    # Check left/right edges (X=0, X=w-1) for non-transparent pixels
    left_non_trans = sum(1 for y in range(h) if pixels[0, y][3] > 0)
    right_non_trans = sum(1 for y in range(h) if pixels[w - 1, y][3] > 0)
    
    print(f"{name} ({w}x{h}):")
    print(f"  Top edge non-transparent: {top_non_trans} pixels")
    print(f"  Bottom edge non-transparent: {bottom_non_trans} pixels")
    print(f"  Left edge non-transparent: {left_non_trans} pixels")
    print(f"  Right edge non-transparent: {right_non_trans} pixels")
