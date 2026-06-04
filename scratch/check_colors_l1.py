from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495333632.png"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()

# Let's print pixel values for Y = 192, X = 48 to 116
print("Pixels at Y=192:")
for x in range(48, 116):
    r, g, b, a = pixels[x, 192]
    # Print if it's not transparent/white
    if not (r >= 250 and g >= 250 and b >= 250):
        print(f"X={x}: ({r},{g},{b})")
