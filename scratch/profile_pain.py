from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780494245821.png"
img = Image.open(img_path)
w, h = img.size
print(f"Image dimensions: {w}x{h}")

img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

# Let's check a column that goes through the bottom of the green shirt / top of the stoma skin.
# The stoma is centered around X=150. The patient is also centered around X=150.
# Let's inspect columns from X=120 to X=180, for Y between 300 and 390.
# We will print the color at each Y to see the transition.
for y in range(300, 390):
    # Print the colors at X = 150
    r, g, b, a = pixels[150, y]
    # Also let's check if there is any green color (green shirt has high G, e.g. g > 120 and r < 100)
    # or stoma skin color (e.g. pinkish/cream color, r > 240, g > 200, b > 160)
    print(f"Y={y}: color=({r},{g},{b})")
