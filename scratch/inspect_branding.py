import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size

# Let's crop the top right corner where the branding logo is
# Typically X: 450 to 680, Y: 10 to 180
branding_crop = img.crop((450, 10, 680, 180))
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\scratch"
branding_crop.save(os.path.join(output_dir, "ref_branding.png"), "PNG")
print("Saved ref_branding.png")
