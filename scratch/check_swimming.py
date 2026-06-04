import os
from PIL import Image

img_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_sports_swimming.png"
if os.path.exists(img_path):
    with Image.open(img_path) as img:
        img.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\check_swimming.png")
        print("Saved swimming copy to brain directory for inspection.")
else:
    print("Swimming image does not exist!")
