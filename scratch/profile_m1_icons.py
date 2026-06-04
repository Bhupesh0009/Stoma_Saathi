from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

def is_foreground(r, g, b):
    return not (r >= 240 and g >= 235 and b >= 235)

def find_box(x0, y0, x1, y1):
    left = x1
    right = x0
    top = y1
    bottom = y0
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            if is_foreground(r, g, b):
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
    if not found:
        return None
    return (left, top, right + 1, bottom + 1)

print("Tighter Icon Bounding Boxes:")
print("Color Icon:", find_box(515, 250, 585, 340))
print("Texture Icon:", find_box(515, 410, 585, 500))
print("Shape Icon:", find_box(515, 570, 585, 660))
print("Warning Icon:", find_box(110, 780, 190, 860))
print("Gauze Icon:", find_box(660, 760, 790, 910))
