from PIL import Image

crop_img = Image.open(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_dehydration_droplet.png")
w, h = crop_img.size
print(f"Droplet Crop size: {w}x{h}")

# Find bounds of actually colored pixels (excluding very light background pixels)
pixels = crop_img.load()
min_x, max_x = w, 0
min_y, max_y = h, 0
found = False

for y in range(h):
    for x in range(w):
        r, g, b, a = pixels[x, y]
        # If it is blue (e.g. b > 150 and r < 100) or generally colored
        if a > 0 and (r < 240 or g < 240 or b < 240):
            found = True
            if x < min_x: min_x = x
            if x > max_x: max_x = x
            if y < min_y: min_y = y
            if y > max_y: max_y = y

if found:
    print(f"Colored pixel bounds: x={min_x} to {max_x}, y={min_y} to {max_y}")
    print(f"Colored pixel width: {max_x - min_x + 1}, height: {max_y - min_y + 1}")
else:
    print("No colored pixels found.")
