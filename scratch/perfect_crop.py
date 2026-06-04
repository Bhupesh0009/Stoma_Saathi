from PIL import Image, ImageDraw
import os
import math

# Load the original mockup
img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
width, height = img.size

os.makedirs(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images", exist_ok=True)

# Define circle parameters
center_x = 303
center_y = 413
radius = 60

# --- 1. Generate Clean Passenger Illustration ---
# We make a copy of the original image to edit
p_img = img.copy()
p_draw = ImageDraw.Draw(p_img)

# Clear checkmarks (fill with white)
p_draw.rectangle([230, 120, 270, 170], fill="white")
p_draw.rectangle([230, 260, 270, 310], fill="white")

# Clear the text "if needed" (fill with white)
p_draw.rectangle([235, 320, 370, 362], fill="white")

# Clear the cushion circle area (fill with white circle)
p_draw.ellipse([center_x - radius, center_y - radius, center_x + radius, center_y + radius], fill="white")

# Now crop the passenger image (X: 0 to 270, Y: 83 to 468)
passenger = p_img.crop((0, 83, 270, 468))
passenger.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_passenger.png")
print("Saved perfect passenger illustration.")


# --- 2. Generate Clean Cushion Circle ---
# Crop cushion box that fully contains the circle
crop_left = 236
crop_top = 345
crop_right = 370
crop_bottom = 469

cushion = img.crop((crop_left, crop_top, crop_right, crop_bottom))
c_pixels = cushion.load()

# Clear the "if needed" text region inside the cropped cushion image
# Relative to crop (Y starts at 345, X starts at 236)
# "if needed" text is Y: 345 to 360 in original -> Y: 0 to 15 in crop
for y in range(0, 16):
    for x in range(cushion.width):
        c_pixels[x, y] = (255, 255, 255, 255) if len(c_pixels[x, y]) == 4 else (255, 255, 255)

# Now apply circle mask (fill everything outside the circle with white)
for y in range(cushion.height):
    for x in range(cushion.width):
        orig_x = x + crop_left
        orig_y = y + crop_top
        dist = math.sqrt((orig_x - center_x) ** 2 + (orig_y - center_y) ** 2)
        if dist > radius:
            c_pixels[x, y] = (255, 255, 255, 255) if len(c_pixels[x, y]) == 4 else (255, 255, 255)

cushion.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png")
cushion.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\cushion_check.png")
print("Saved perfect cushion illustration.")
