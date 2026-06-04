import os
from PIL import Image, ImageDraw

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240779442.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

with Image.open(image_path) as img:
    # 1. Scissors Perfect Crop
    # X: 535 to 985, Y: 175 to 342 (captures the full scissors from top loop to bottom handle)
    scissors = img.crop((535, 175, 985, 342))
    
    # 2. Draw a rectangle to erase the "SCISSORS" text badge in the cropped image
    # The badge is roughly in the left-half of this crop, at y < 50
    # Background color is (253, 252, 250)
    draw = ImageDraw.Draw(scissors)
    draw.rectangle([0, 0, 290, 50], fill=(253, 252, 250))
    
    # Save the cleaned image
    scissors.save(os.path.join(output_dir, "module2_scissors.png"), "PNG")
    print("Saved clean module2_scissors.png without label")

print("Crop update completed!")
