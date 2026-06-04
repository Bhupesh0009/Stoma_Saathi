import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240779442.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

with Image.open(image_path) as img:
    # 1. Blue measuring guide card (kept as is, it's already perfect)
    ring_guide = img.crop((31, 245, 534, 561))
    ring_guide.save(os.path.join(output_dir, "module2_measuring_guide_card.png"), "PNG")
    print("Saved module2_measuring_guide_card.png")
    
    # 2. Scissors (adjusted Y from 225 to 342 to remove labels and baseplate overlap)
    scissors = img.crop((535, 225, 985, 342))
    scissors.save(os.path.join(output_dir, "module2_scissors.png"), "PNG")
    print("Saved module2_scissors.png")
    
    # 3. Baseplate guide (adjusted Y start to 342 to remove scissors overlap)
    baseplate = img.crop((575, 342, 895, 640))
    baseplate.save(os.path.join(output_dir, "module2_baseplate_guide.png"), "PNG")
    print("Saved module2_baseplate_guide.png")

print("Crop updated successfully!")
