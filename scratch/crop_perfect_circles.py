import os
from PIL import Image, ImageDraw

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

img = Image.open(image_path).convert("RGBA")
width, height = img.size

em_icons = [
    {"name": "disclaimer_em_pain.png", "cx": 88, "cy": 744, "r": 35},
    {"name": "disclaimer_em_bleeding.png", "cx": 188, "cy": 744, "r": 34},
    {"name": "disclaimer_em_fever.png", "cx": 287, "cy": 744, "r": 33},
    {"name": "disclaimer_em_leakage.png", "cx": 384, "cy": 744, "r": 33},
    {"name": "disclaimer_em_color.png", "cx": 486, "cy": 744, "r": 34},
    {"name": "disclaimer_em_skin.png", "cx": 590, "cy": 744, "r": 35},
]

for icon in em_icons:
    name = icon["name"]
    cx = icon["cx"]
    cy = icon["cy"]
    r = icon["r"]
    
    # Crop a square box around the circle with 1px padding
    box = (cx - r - 1, cy - r - 1, cx + r + 1, cy + r + 1)
    cropped = img.crop(box)
    
    # Create a circular mask of the same size
    mask = Image.new("L", cropped.size, 0)
    draw = ImageDraw.Draw(mask)
    # The center of the circle in the cropped coordinates is (r + 1, r + 1)
    draw.ellipse((1, 1, cropped.size[0] - 1, cropped.size[1] - 1), fill=255)
    
    # Apply the mask to the cropped image
    cropped.putalpha(mask)
    
    # Process transparency for any background pixels inside the circle (optional)
    # The pink background inside the circle is around (246, 225, 220).
    # Since we want to keep the pink circle background, we only make the pixels outside the circle transparent.
    # The mask already made everything outside the circle transparent (alpha = 0)!
    # So we don't need any additional thresholding that might eat away parts of the icon.
    
    # Save the output image
    output_path = os.path.join(output_dir, name)
    cropped.save(output_path, "PNG")
    print(f"Saved perfectly circular crop: {name} (center: {cx}, {cy}, radius: {r})")
