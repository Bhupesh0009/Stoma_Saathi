from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495333632.png"
img = Image.open(img_path)
w, h = img.size
img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

def find_box_in_region(x0, y0, x1, y1, tolerance=240):
    left = x1
    right = x0
    top = y1
    bottom = y0
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            # check for non-white/non-light gray pixels
            if r < tolerance or g < tolerance or b < tolerance:
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
    if not found:
        return None
    return (left, top, right + 1, bottom + 1)

# Let's locate the siren
siren_box = find_box_in_region(650, 10, 800, 100)
print(f"Siren Box: {siren_box}")

# Let's locate center components
# Center Cross
cross_box = find_box_in_region(420, 150, 580, 320)
print(f"Center Cross Box: {cross_box}")

# Center Hospital
hospital_box = find_box_in_region(400, 300, 600, 500)
print(f"Hospital Box: {hospital_box}")

# Let's look for double arrows. They might be in Y=200 to 300.
# The red arrow pointing left is on the left of the cross (X=390 to 450).
# The orange arrow pointing right is on the right of the cross (X=550 to 610).
left_arrow_box = find_box_in_region(390, 200, 450, 320)
print(f"Left Arrow Box: {left_arrow_box}")

right_arrow_box = find_box_in_region(550, 200, 610, 320)
print(f"Right Arrow Box: {right_arrow_box}")
