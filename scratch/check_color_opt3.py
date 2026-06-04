from PIL import Image
import os

assets = [
    "module2_measuring_guide_card.png",
    "module2_scissors.png",
    "module2_baseplate_guide.png"
]
dir_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

for asset in assets:
    path = os.path.join(dir_path, asset)
    if os.path.exists(path):
        with Image.open(path) as img:
            color = img.convert("RGB").getpixel((0, 0))
            print(f"{asset}: size={img.size}, pixel(0,0)={color}")
