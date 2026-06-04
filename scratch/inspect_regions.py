from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498319169.png"
img = Image.open(img_path).convert("RGBA")
w, h = img.size

# Let's crop the water bottle & glass on the left.
# By looking at the reference image, it's roughly on the left side (X < 240, 100 < Y < 480).
# Let's crop X: 10 to 240, Y: 100 to 480 and find the non-white bounding box.
crop_left = img.crop((10, 100, 240, 480))
pixels = crop_left.load()
min_x, min_y = crop_left.size
max_x = max_y = 0
for y in range(crop_left.size[1]):
    for x in range(crop_left.size[0]):
        r, g, b, a = pixels[x, y]
        # Check if not white / not background
        if (r + g + b) / 3 < 250:
            if x < min_x: min_x = x
            if y < min_y: min_y = y
            if x > max_x: max_x = x
            if y > max_y: max_y = y

print(f"Left illustration bounding box inside crop: min_x={min_x}, min_y={min_y}, max_x={max_x}, max_y={max_y}")
print(f"Absolute coordinates in main image: X: {10 + min_x} to {10 + max_x}, Y: {100 + min_y} to {100 + max_y}")
