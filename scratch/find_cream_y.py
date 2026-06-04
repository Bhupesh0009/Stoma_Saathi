from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()
w, h = img.size

# Let's search along a column in the middle of the card (e.g. X = 400)
# to see where the cream color starts and ends.
print("Profile of X=400:")
for y in range(700, h):
    r, g, b, a = pixels[400, y]
    # Check for cream-like color (R > 250, G > 240, B > 230)
    if r > 250 and g > 240 and b > 230:
        print(f"Y={y}: ({r},{g},{b})")
