import os
from PIL import Image

img_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_sports_hydration.png"
if os.path.exists(img_path):
    with Image.open(img_path) as img:
        print(f"Hydration image size: {img.size}")
        # Save a copy to brain directory to make it accessible
        img.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\check_hydration.png")
        print("Saved copy to brain directory for inspection.")
else:
    print("Hydration image does not exist!")
