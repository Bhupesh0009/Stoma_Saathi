from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780494639822.png"
img = Image.open(img_path)
w, h = img.size
print(f"Image dimensions: {w}x{h}")

img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

# Profile column X = 125
for y in range(50, h):
    r, g, b, a = pixels[125, y]
    # Print the coordinates where we see transition or colors
    if r < 240 or g < 240 or b < 240:
        print(f"Y={y}: color=({r},{g},{b})")
