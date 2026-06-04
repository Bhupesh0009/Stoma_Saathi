from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()
w, h = img.size

# Let's search for pink/red color of the icon circle.
# The icon circle has a solid pink background in the mockup. Let's find its center.
# The pink color is around RGB (232, 77, 115) or similar.
# Let's scan X: 300 to 700 and Y: 220 to 380.
matches = []
for y in range(220, 380):
    for x in range(300, 700):
        r, g, b, a = pixels[x, y]
        # Pink: high R, lower G/B
        if r > 200 and 60 <= g <= 100 and 90 <= b <= 130:
            matches.append((x, y))

if matches:
    xs = [m[0] for m in matches]
    ys = [m[1] for m in matches]
    min_x, max_x = min(xs), max(xs)
    min_y, max_y = min(ys), max(ys)
    print(f"Found pink pixels in X: {min_x} to {max_x}, Y: {min_y} to {max_y}")
    print(f"Approx center: X = {(min_x + max_x) // 2}, Y = {(min_y + max_y) // 2}")
else:
    print("No matching pink pixels found.")
