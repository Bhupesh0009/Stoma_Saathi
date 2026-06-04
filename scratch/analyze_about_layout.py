import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780565576086.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

if not os.path.exists(output_dir):
    os.makedirs(output_dir, exist_ok=True)

img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's inspect the background color
# We can sample a few corners
bg_samples = [pixels[0, 0], pixels[width-1, 0], pixels[0, height-1], pixels[width-1, height-1], pixels[width//2, height//2]]
print("BG samples:", bg_samples)

# We know the background of the image is generally #F8FAFA, let's check what RGB is in the JPEG.
# Usually it's around (248, 250, 250) or slightly different due to JPEG compression.
# Let's find non-background pixels (where color is not close to the background color at e.g. x=width//2, y=height//2, or 248, 250, 250).
# Let's define background threshold.
def is_bg(rgb):
    r, g, b = rgb
    # check if close to F8FAFA (248, 250, 250)
    # The leaves are light teal, the phone background circle is very light teal, the footer is light teal.
    # So background is very bright/white-ish.
    return r > 245 and g > 245 and b > 245

# 1. Top-right leaves
# Look in X: [400, width], Y: [0, 200]
leaves_left = width
leaves_right = 0
leaves_top = height
leaves_bottom = 0

for y in range(0, 200):
    for x in range(400, width):
        if not is_bg(pixels[x, y]):
            if x < leaves_left: leaves_left = x
            if x > leaves_right: leaves_right = x
            if y < leaves_top: leaves_top = y
            if y > leaves_bottom: leaves_bottom = y

print(f"Leaves bbox: X({leaves_left} to {leaves_right}), Y({leaves_top} to {leaves_bottom})")

# 2. Phone illustration
# It's in the middle, left side.
# Let's scan X: [0, 300], Y: [200, 500]
phone_left = width
phone_right = 0
phone_top = height
phone_bottom = 0

for y in range(200, 500):
    for x in range(0, 300):
        if not is_bg(pixels[x, y]):
            if x < phone_left: phone_left = x
            if x > phone_right: phone_right = x
            if y < phone_top: phone_top = y
            if y > phone_bottom: phone_bottom = y

print(f"Phone bbox: X({phone_left} to {phone_right}), Y({phone_top} to {phone_bottom})")

# 3. Bottom hands holding heart
# Scan X: [0, 250], Y: [800, 1024]
hands_left = width
hands_right = 0
hands_top = height
hands_bottom = 0

for y in range(800, height):
    for x in range(0, 250):
        if not is_bg(pixels[x, y]):
            if x < hands_left: hands_left = x
            if x > hands_right: hands_right = x
            if y < hands_top: hands_top = y
            if y > hands_bottom: hands_bottom = y

print(f"Hands bbox: X({hands_left} to {hands_right}), Y({hands_top} to {hands_bottom})")

# Let's crop and save them
if leaves_right > leaves_left and leaves_bottom > leaves_top:
    # pad slightly
    leaves_crop = img.crop((leaves_left - 5, leaves_top - 5, leaves_right + 5, leaves_bottom + 5))
    leaves_crop.save(os.path.join(output_dir, "about_leaves.png"), "PNG")
    print("Saved about_leaves.png")

if phone_right > phone_left and phone_bottom > phone_top:
    phone_crop = img.crop((phone_left - 5, phone_top - 5, phone_right + 5, phone_bottom + 5))
    phone_crop.save(os.path.join(output_dir, "about_phone.png"), "PNG")
    print("Saved about_phone.png")

if hands_right > hands_left and hands_bottom > hands_top:
    hands_crop = img.crop((hands_left - 5, hands_top - 5, hands_right + 5, hands_bottom + 5))
    hands_crop.save(os.path.join(output_dir, "about_hands.png"), "PNG")
    print("Saved about_hands.png")
