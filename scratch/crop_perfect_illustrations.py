import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780565576086.jpg"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's find the vertical divider line in the description section (Y: 200 to 500)
# The vertical divider line has a distinct teal color or grey color, and runs vertically.
# Let's scan columns around X: 210 to 250 for a column that has a solid line (similar pixels along Y)
# We can find it by looking for a column where many pixels have the same color.
# Alternatively, since we know the phone is on the left, let's find the rightmost pixel of the circular background
# of the phone, and ensure we crop to the left of the text.
# Let's look at the description text. The first word is "Stoma Saathi" in English and "स्टोमा साथी" in Hindi.
# In the image, the text starts around X: 235.
# Let's set the phone crop boundary to X: [50, 215], Y: [230, 480] to completely exclude the divider and text!
# In the original crop, the phone box was X(55 to 299), Y(200 to 499).
# By restricting the right boundary to X=220, we keep the entire phone circle (which is from X=55 to X=215)
# and completely cut off the text starting at X=230!
# Let's verify:
# Left boundary: 55
# Right boundary: 220
# Top boundary: 230
# Bottom boundary: 480

# 1. Phone crop:
phone_box = (55, 230, 220, 480)

# 2. Leaves crop:
# The leaves are in the top-right.
# The logo ends around X: 450, and the text "STOMA SAATHI" is centered.
# The leaves are in the top-right corner.
# Let's crop X: [480, 682], Y: [0, 150].
# This completely avoids the title text "STOMA SAATHI" (which is at Y: 155 to 200) and the logo (which is at X: 280 to 400).
leaves_box = (480, 0, 682, 140)

# 3. Bottom hands holding heart crop:
# The bottom footer has the hands holding heart illustration on the left.
# The hands illustration is located in X: [0, 190], Y: [890, 1024].
# The text "You are not alone..." starts around X: 210.
# So by restricting the right boundary to X: 195, we keep the entire hands illustration and exclude the text!
hands_box = (0, 890, 195, 1024)

print(f"Capping phone box to: {phone_box}")
print(f"Capping leaves box to: {leaves_box}")
print(f"Capping hands box to: {hands_box}")

# Crop and save
phone_crop = img.crop(phone_box)
phone_crop.save(os.path.join(output_dir, "about_phone.png"), "PNG")

leaves_crop = img.crop(leaves_box)
leaves_crop.save(os.path.join(output_dir, "about_leaves.png"), "PNG")

hands_crop = img.crop(hands_box)
hands_crop.save(os.path.join(output_dir, "about_hands.png"), "PNG")

# Now let's process transparency
def make_transparent(filename, threshold=245):
    filepath = os.path.join(output_dir, filename)
    img_rgba = Image.open(filepath).convert("RGBA")
    data = img_rgba.getdata()
    
    new_data = []
    for item in data:
        r, g, b, a = item
        # If the pixel is close to white, make it transparent
        if r >= threshold and g >= threshold and b >= threshold:
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append(item)
            
    img_rgba.putdata(new_data)
    img_rgba.save(filepath, "PNG")
    print(f"Applied transparency to {filename}")

make_transparent("about_phone.png", threshold=248)
make_transparent("about_leaves.png", threshold=248)
make_transparent("about_hands.png", threshold=248)
