import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

crops = {
    # Left column circle (X: 265 to 370)
    "module6_sports_walking.png": (262, 180, 365, 276),
    
    # 3 circles (X: 262 to 655)
    "module6_sports_yoga_stretch.png": (262, 243, 655, 376),
    
    # Center oval (X: 350 to 570)
    "module6_sports_swimming.png": (355, 353, 565, 436),
    
    # 3 circles (X: 262 to 655)
    "module6_sports_sports.png": (262, 418, 655, 546),
    
    # Center icons (X: 350 to 570)
    "module6_sports_hydration.png": (355, 493, 565, 578),
    
    # Left circle (X: 265 to 370)
    "module6_avoid_lifting.png": (262, 585, 365, 676),
    
    # 2 circles (X: 262 to 600)
    "module6_avoid_pressure.png": (262, 668, 600, 756),
    
    # 2 circles (X: 262 to 600)
    "module6_avoid_contact.png": (262, 743, 600, 846),
    
    # 4 items (X: 262 to 655)
    "module6_avoid_symptoms.png": (262, 793, 655, 903),
    
    # Bottom character (kept as is)
    "module6_sports_character.png": (498, 878, 674, 1016)
}

with Image.open(image_path) as img:
    for filename, box in crops.items():
        cropped_img = img.crop(box)
        cropped_img.save(os.path.join(output_dir, filename), "PNG")
        print(f"Saved {filename} with tight box {box}")

print("Tight cropping completed successfully!")
