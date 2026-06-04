from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495333632.png"
img = Image.open(img_path)
img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

def find_box(x0, y0, x1, y1, tolerance=245):
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

left_ranges = [
    ("l1", 50, 190, 120, 265),
    ("l2", 50, 275, 120, 360),
    ("l3", 50, 370, 120, 445),
    ("l4", 50, 450, 120, 540),
]

right_ranges = [
    ("r1", 620, 180, 690, 270),
    ("r2", 620, 278, 690, 360),
    ("r3", 620, 362, 690, 450),
    ("r4", 620, 451, 690, 545),
]

print("--- LEFT PANEL BOUNDING BOXES ---")
for name, x0, y0, x1, y1 in left_ranges:
    box = find_box(x0, y0, x1, y1)
    print(f"{name}: {box}")

print("\n--- RIGHT PANEL BOUNDING BOXES ---")
for name, x0, y0, x1, y1 in right_ranges:
    box = find_box(x0, y0, x1, y1)
    print(f"{name}: {box}")
