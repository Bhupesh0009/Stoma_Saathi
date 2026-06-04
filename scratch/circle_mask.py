from PIL import Image
import math

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
width, height = img.size

# We crop a bounding box that fully contains the circle
# Center of circle is approx X=305, Y=415. Radius is approx 60.
# So X goes from 245 to 365. Y goes from 355 to 469.
crop_left = 245
crop_top = 355
crop_right = 365
crop_bottom = 469

cushion = img.crop((crop_left, crop_top, crop_right, crop_bottom))
pixels = cushion.load()

# Center and radius in original coordinates
center_x = 305
center_y = 415
radius = 58

for y in range(cushion.height):
    for x in range(cushion.width):
        orig_x = x + crop_left
        orig_y = y + crop_top
        # Calculate distance to circle center
        dist = math.sqrt((orig_x - center_x) ** 2 + (orig_y - center_y) ** 2)
        if dist > radius:
            # Out of circle -> fill with white
            pixels[x, y] = (255, 255, 255, 255) if len(pixels[x, y]) == 4 else (255, 255, 255)

# Save the clean cushion circle
cushion.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png")
cushion.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\cushion_check.png")
print("Saved masked cushion circle.")
