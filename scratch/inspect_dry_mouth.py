from PIL import Image

# Open the cropped dry mouth image
crop_img = Image.open(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_dehydration_dry_mouth.png")
w, h = crop_img.size
print(f"Crop size: {w}x{h}")

# Let's inspect the rightmost 30 pixels of the crop.
# If there are any stray black components that resemble text, let's print them.
# Let's also print the Y coordinates of the non-white pixels at the right edge.
pixels = crop_img.load()
for x in range(w - 20, w):
    for y in range(h):
        r, g, b, a = pixels[x, y]
        # if not transparent
        if a > 0:
            print(f"Non-transparent pixel at x={x}, y={y}: rgba=({r},{g},{b},{a})")
            break
