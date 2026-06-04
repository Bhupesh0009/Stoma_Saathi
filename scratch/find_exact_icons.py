from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()
w, h = img.size

def find_color_bounds(color_check):
    xs = []
    ys = []
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if color_check(r, g, b):
                xs.append(x)
                ys.append(y)
    if not xs:
        return None
    return min(xs), min(ys), max(xs), max(ys)

# 1. Pink Palette Circle (pink/red background)
# We know the pink color is around RGB (232, 77, 115) -> Color: #E84D73
# Let's search for r > 210, 60 <= g <= 90, 100 <= b <= 130
pink_box = find_color_bounds(lambda r, g, b: r > 210 and 60 <= g <= 95 and 95 <= b <= 130)
print("Pink circle bounds:", pink_box)

# 2. Blue Circle (blue background)
# Blue is around RGB (77, 137, 216) -> Color: #4D89D8
# Let's search for 60 <= r <= 95, 120 <= g <= 155, 200 <= b <= 235
blue_box = find_color_bounds(lambda r, g, b: 60 <= r <= 95 and 120 <= g <= 155 and 200 <= b <= 235)
print("Blue circle bounds:", blue_box)

# 3. Green Circle (green background)
# Green is around RGB (105, 184, 90) -> Color: #69B85A
# Let's search for 90 <= r <= 120, 165 <= g <= 200, 75 <= b <= 105
green_box = find_color_bounds(lambda r, g, b: 90 <= r <= 120 and 165 <= g <= 200 and 75 <= b <= 105)
print("Green circle bounds:", green_box)
