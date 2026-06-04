from PIL import Image

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
width, height = img.size
pixels = img.load()

# Find the header boundary
# The header has a teal color #4F8791 (RGB: 79, 135, 145).
# Let's find the row where the teal color ends (transition to white)
header_bottom = 0
for y in range(height):
    # check color at x = width // 2
    r, g, b = pixels[width // 2, y][:3]
    # Teal is around (70-90, 120-150, 135-160)
    if not (70 <= r <= 95 and 120 <= g <= 150 and 135 <= b <= 160):
        # We hit the white boundary!
        header_bottom = y
        break

print("Header bottom detected at Y =", header_bottom)

# Find the car icon boundaries in the header
# Car icon is white (approx 255, 255, 255) inside the teal header
icon_left = width
icon_right = 0
icon_top = header_bottom
icon_bottom = 0

for y in range(header_bottom):
    for x in range(width // 2, width):
        r, g, b = pixels[x, y][:3]
        if r > 240 and g > 240 and b > 240:
            if x < icon_left:
                icon_left = x
            if x > icon_right:
                icon_right = x
            if y < icon_top:
                icon_top = y
            if y > icon_bottom:
                icon_bottom = y

print(f"Car icon bounding box: X({icon_left} to {icon_right}), Y({icon_top} to {icon_bottom})")

# Let's crop the car icon with a 4px padding
pad = 4
car_icon = img.crop((icon_left - pad, icon_top - pad, icon_right + pad, icon_bottom + pad))
car_icon.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\test_car_icon.png")

# Now let's find the circular cushion graphic at the bottom right.
# The cushion graphic is inside a circle. The circle has a light blue-grey outline.
# Let's scan from bottom-right to find the circle's bounding box.
# We look for non-white pixels in the bottom right corner (x > width*0.5, y > height*0.5)
cushion_left = width
cushion_right = 0
cushion_top = height
cushion_bottom = 0

for y in range(int(height * 0.7), height):
    for x in range(int(width * 0.5), width):
        r, g, b = pixels[x, y][:3]
        # White background is (255, 255, 255), let's find anything that is not white (e.g. < 250)
        if r < 250 or g < 250 or b < 250:
            if x < cushion_left:
                cushion_left = x
            if x > cushion_right:
                cushion_right = x
            if y < cushion_top:
                cushion_top = y
            if y > cushion_bottom:
                cushion_bottom = y

print(f"Cushion bounding box: X({cushion_left} to {cushion_right}), Y({cushion_top} to {cushion_bottom})")

# Let's crop the cushion circle with a 2px padding
cush_pad = 2
cushion_img = img.crop((cushion_left - cush_pad, cushion_top - cush_pad, cushion_right + cush_pad, cushion_bottom + cush_pad))
cushion_img.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\test_cushion.png")

# Now let's crop the passenger illustration.
# In the mockup, the passenger illustration is on the left.
# It goes from X: 0 to about X: 270 (where the vertical space/checkmarks start)
# and from Y: header_bottom to the bottom of the image (height).
# Let's crop from X: 0 to X: 268 (so we don't include the checkmarks which start at X: 220-230)
# Wait, where do the checkmarks start? Let's check X coordinates of green checkmarks.
# Green checkmark is green color #58A95B (RGB: 88, 169, 91).
check_left = width
for y in range(header_bottom, height):
    for x in range(width):
        r, g, b = pixels[x, y][:3]
        if 80 <= r <= 95 and 160 <= g <= 175 and 85 <= b <= 100:
            if x < check_left:
                check_left = x
print("First green checkmark left edge detected at X =", check_left)

passenger_right_edge = check_left - 10 # give 10px spacing before the checkmark
print("Passenger crop right boundary =", passenger_right_edge)

passenger_img = img.crop((0, header_bottom, passenger_right_edge, height))
passenger_img.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\test_passenger.png")
