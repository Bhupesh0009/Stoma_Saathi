from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()

def find_color_box(x0, y0, x1, y1, color_cond):
    left = x1
    right = x0
    top = y1
    bottom = y0
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            if color_cond(r, g, b):
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
    if not found:
        return None
    return (left, top, right + 1, bottom + 1)

# Color Palette Icon (pinkish circle)
is_pink = lambda r, g, b: r > 180 and g < 120 and b < 150
print("Color Icon Box:", find_color_box(510, 240, 610, 360, is_pink))

# Texture Icon (bluish circle)
is_blue = lambda r, g, b: r < 120 and g < 180 and b > 180
print("Texture Icon Box:", find_color_box(510, 400, 610, 520, is_blue))

# Shape Icon (greenish circle)
is_green = lambda r, g, b: r < 120 and g > 150 and b < 120
print("Shape Icon Box:", find_color_box(510, 560, 610, 680, is_green))

# Warning Icon (yellow triangle)
is_yellow = lambda r, g, b: r > 200 and g > 140 and b < 100
print("Warning Icon Box:", find_color_box(100, 770, 220, 870, is_yellow))
