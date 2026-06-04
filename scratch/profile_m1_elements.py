from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
w, h = img.size
img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

def find_box(x0, y0, x1, y1, tolerance=250):
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

# Let's locate the stoma + skin area
stoma_box = find_box(30, 200, 440, 720)
print(f"Stoma Box: {stoma_box}")

# Icons on the right
color_box = find_box(500, 240, 640, 350)
print(f"Color Icon Box: {color_box}")

texture_box = find_box(500, 400, 640, 520)
print(f"Texture Icon Box: {texture_box}")

shape_box = find_box(500, 560, 640, 680)
print(f"Shape Icon Box: {shape_box}")

# Bottom card elements
warning_box = find_box(100, 760, 250, 880)
print(f"Warning Icon Box: {warning_box}")

gauze_box = find_box(650, 760, 810, 920)
print(f"Gauze Box: {gauze_box}")
