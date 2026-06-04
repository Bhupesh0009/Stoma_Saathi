import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"
output_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\mockup_crop.png"

with Image.open(image_path) as img:
    # Crop from y=120 to y=1050 to capture the whole infographic
    cropped = img.crop((0, 120, 720, 1050))
    cropped.save(output_path, "PNG")
    print("Mockup crop saved successfully!")
