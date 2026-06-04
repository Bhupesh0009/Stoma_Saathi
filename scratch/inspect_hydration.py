from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498319169.png"
img = Image.open(img_path)
print(f"Image format: {img.format}, size: {img.size}, mode: {img.mode}")
