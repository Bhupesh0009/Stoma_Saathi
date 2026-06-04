import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240431040.png"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

if not os.path.exists(output_dir):
    os.makedirs(output_dir, exist_ok=True)

with Image.open(image_path) as img:
    width, height = img.size
    print(f"Original size: {width}x{height}")
    
    # Precise boundaries
    # Card 1: 0 to 200
    ring = img.crop((0, 0, width, 200))
    ring.save(os.path.join(output_dir, "module2_barrier_ring.png"), "PNG")
    print("Saved module2_barrier_ring.png")
    
    # Card 2: 220 to 420
    paste = img.crop((0, 220, width, 420))
    paste.save(os.path.join(output_dir, "module2_barrier_paste.png"), "PNG")
    print("Saved module2_barrier_paste.png")
    
    # Card 3: 440 to 640
    wipes = img.crop((0, 440, width, 640))
    wipes.save(os.path.join(output_dir, "module2_barrier_wipes.png"), "PNG")
    print("Saved module2_barrier_wipes.png")

print("Cropping completed successfully!")
