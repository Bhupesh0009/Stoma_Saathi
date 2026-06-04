import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

# Perfect uniform crop boxes
crops = {
    # Green Section Rows
    "module6_sports_walking.png": (262, 180, 674, 262),
    "module6_sports_yoga_stretch.png": (262, 262, 674, 356),
    "module6_sports_swimming.png": (262, 356, 674, 423),
    "module6_sports_sports.png": (262, 423, 674, 508),
    "module6_sports_hydration.png": (262, 508, 674, 575),
    
    # Red Section Rows
    "module6_avoid_lifting.png": (262, 585, 674, 680),
    "module6_avoid_pressure.png": (262, 680, 674, 747),
    "module6_avoid_contact.png": (262, 747, 674, 817),
    "module6_avoid_symptoms.png": (262, 817, 674, 899),
    
    # Bottom Character
    "module6_sports_character.png": (498, 878, 674, 1016)
}

with Image.open(image_path) as img:
    for filename, box in crops.items():
        cropped_img = img.crop(box)
        cropped_img.save(os.path.join(output_dir, filename), "PNG")
        print(f"Saved {filename} with perfect box {box} (size: {cropped_img.size})")

print("Perfect cropping completed successfully!")
