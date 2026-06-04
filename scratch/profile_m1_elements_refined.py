from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
w, h = img.size
img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

def is_foreground(r, g, b):
    # Background is very light pinkish-white: r >= 240, g >= 235, b >= 235
    # So foreground is anything that deviates from this.
    return not (r >= 240 and g >= 235 and b >= 235)

def find_box_refined(x0, y0, x1, y1):
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

print("Refined Bounding Boxes:")
print("Stoma Area (X: 30-490, Y: 200-720):", find_box_refined(30, 200, 490, 720))
print("Color Icon (X: 500-640, Y: 240-360):", find_box_refined(500, 240, 640, 360))
print("Texture Icon (X: 500-640, Y: 400-520):", find_box_refined(500, 400, 640, 520))
print("Shape Icon (X: 500-640, Y: 560-680):", find_box_refined(500, 560, 640, 680))
print("Warning Icon (X: 80-200, Y: 760-880):", find_box_refined(80, 760, 200, 880))
print("Gauze Icon (X: 620-800, Y: 740-920):", find_box_refined(620, 740, 800, 920))
