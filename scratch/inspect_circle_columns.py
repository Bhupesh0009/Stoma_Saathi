from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()

def find_precise_box(x0, y0, x1, y1, color_cond):
    xs = []
    ys = []
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            if color_cond(r, g, b):
                xs.append(x)
                ys.append(y)
    if not xs:
        return None
    return min(xs), min(ys), max(xs), max(ys)

# Search within X: 420 to 520
print("Precisely scanned circles in X: 420-520:")

# Pink Palette Circle: Y: 250 to 360
# Pink color is around RGB (232, 77, 115) -> r > 210, 60 <= g <= 95, 95 <= b <= 130
pink_box = find_precise_box(420, 250, 520, 360, lambda r, g, b: r > 210 and 60 <= g <= 95 and 95 <= b <= 130)
print("Pink Circle:", pink_box)

# Blue Circle: Y: 430 to 530
# Blue is around RGB (77, 137, 216) -> 60 <= r <= 95, 120 <= g <= 155, 200 <= b <= 235
blue_box = find_precise_box(420, 430, 520, 530, lambda r, g, b: 60 <= r <= 95 and 120 <= g <= 155 and 200 <= b <= 235)
print("Blue Circle:", blue_box)

# Green Circle: Y: 590 to 700
# Green is around RGB (105, 184, 90) -> 90 <= r <= 120, 165 <= g <= 200, 75 <= b <= 105
green_box = find_precise_box(420, 590, 520, 700, lambda r, g, b: 90 <= r <= 120 and 165 <= g <= 200 and 75 <= b <= 105)
print("Green Circle:", green_box)
