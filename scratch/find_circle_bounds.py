from PIL import Image

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
width, height = img.size
pixels = img.load()

circle_left = width
circle_right = 0
circle_top = height
circle_bottom = 0

for y in range(300, height):
    for x in range(200, width):
        r, g, b = pixels[x, y][:3]
        # Slate-blue outline color range
        if (60 <= r <= 95) and (80 <= g <= 115) and (120 <= b <= 155):
            if x < circle_left: circle_left = x
            if x > circle_right: circle_right = x
            if y < circle_top: circle_top = y
            if y > circle_bottom: circle_bottom = y

print(f"Cushion circle detected: X({circle_left} to {circle_right}), Y({circle_top} to {circle_bottom})")
