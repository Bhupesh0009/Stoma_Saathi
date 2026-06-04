from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

# The stoma illustration is in X=30 to 450.
# Let's see if there is any foreground pixel in a wider band to find its true boundaries.
def find_box(x0, y0, x1, y1, tolerance=240):
    left = x1
    right = x0
    top = y1
    bottom = y0
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            if r < tolerance or g < tolerance or b < tolerance:
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
    if not found:
        return None
    return (left, top, right + 1, bottom + 1)

box = find_box(30, 200, 480, 720)
print(f"Stoma Box: {box}")
