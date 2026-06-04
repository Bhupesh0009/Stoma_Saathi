from PIL import Image
import os

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
width, height = img.size

# Create assets directory if it doesn't exist
os.makedirs(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images", exist_ok=True)

# 1. Crop Car Icon
# We'll scan the bounding box of white pixels on the right side of the header (X > 300, Y < 83)
pixels = img.load()
icon_left, icon_right, icon_top, icon_bottom = width, 0, 83, 0
for y in range(5, 83):
    for x in range(300, width):
        r, g, b = pixels[x, y][:3]
        if r > 240 and g > 240 and b > 240:
            if x < icon_left: icon_left = x
            if x > icon_right: icon_right = x
            if y < icon_top: icon_top = y
            if y > icon_bottom: icon_bottom = y

pad = 3
car_icon = img.crop((icon_left - pad, icon_top - pad, icon_right + pad, icon_bottom + pad))
car_icon.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_header_car.png")
print(f"Saved car icon: X({icon_left} to {icon_right}), Y({icon_top} to {icon_bottom})")

# 2. Crop Cushion Illustration
# Let's find the circle boundaries.
# We know the circle is in the bottom right, roughly X > 230, Y > 360.
cush_left, cush_right, cush_top, cush_bottom = width, 0, height, 0
for y in range(360, height):
    for x in range(230, width):
        r, g, b = pixels[x, y][:3]
        # Outline is blueish-grey (e.g. r < 240, g < 240, b < 240)
        # Inside is yellow/brown (cushion) and light background.
        if r < 245 or g < 245 or b < 245:
            if x < cush_left: cush_left = x
            if x > cush_right: cush_right = x
            if y < cush_top: cush_top = y
            if y > cush_bottom: cush_bottom = y

cush_pad = 2
cushion = img.crop((cush_left - cush_pad, cush_top - cush_pad, cush_right + cush_pad, cush_bottom + cush_pad))
cushion.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png")
print(f"Saved cushion: X({cush_left} to {cush_right}), Y({cush_top} to {cush_bottom})")

# 3. Crop Passenger Illustration
# The passenger is on the left. In the mockup, the passenger starts at X=0 and goes up to the checkmarks (X around 220).
# The cushion circle's left edge is at cush_left. Since the cushion overlaps the passenger,
# we can crop the passenger illustration from X:0 to X:260 or X:270, and Y:83 to height.
# Let's crop X: 0 to 260, Y: 83 to height.
passenger = img.crop((0, 83, 260, height))
passenger.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_passenger.png")
print("Saved passenger illustration: X(0 to 260), Y(83 to 469)")
