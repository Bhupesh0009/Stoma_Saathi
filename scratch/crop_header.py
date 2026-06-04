import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")

# Crop the top header region (Y: 0 to 220)
header_crop = img.crop((0, 0, img.size[0], 220))
header_crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\scratch\ref_header.png", "PNG")
print("Saved ref_header.png")
