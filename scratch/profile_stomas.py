from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780493776065.png"
img = Image.open(img_path)
w, h = img.size
print(f"Image dimensions: {w}x{h}")

img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

# Let's profile along X = 125, which should go through the center of the three stoma circles.
# We will print the Y coordinates where the pixels are not white.
x = 125
for y in range(h):
    r, g, b, a = pixels[x, y]
    # If not white (at least one channel is < 240)
    if r < 240 or g < 240 or b < 240:
        print(f"Y={y}: color=({r},{g},{b})")
