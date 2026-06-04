import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size

# The branding section is in the top right.
# Let's crop X: 480..670, Y: 10..180
crop = img.crop((480, 10, 670, 180))
crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\scratch\ref_logo_section.png", "PNG")
print("Saved ref_logo_section.png")
