import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

if not os.path.exists(output_dir):
    os.makedirs(output_dir, exist_ok=True)

crops = {
    "module6_sports_walking.png": (248, 183, 674, 276),
    "module6_sports_yoga_stretch.png": (248, 243, 674, 376),
    "module6_sports_swimming.png": (248, 353, 674, 436),
    "module6_sports_sports.png": (248, 418, 674, 546),
    "module6_sports_hydration.png": (248, 493, 674, 578),
    "module6_avoid_lifting.png": (248, 585, 674, 676),
    "module6_avoid_pressure.png": (248, 668, 674, 756),
    "module6_avoid_contact.png": (248, 743, 674, 846),
    "module6_avoid_symptoms.png": (248, 793, 674, 903),
    "module6_sports_character.png": (498, 878, 674, 1016)
}

with Image.open(image_path) as img:
    for filename, box in crops.items():
        cropped_img = img.crop(box)
        cropped_img.save(os.path.join(output_dir, filename), "PNG")
        print(f"Saved {filename} with box {box}")

print("Option 10 image assets cropped successfully!")
