from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()

print("Pixels at Y=780:")
for x in range(110, 200, 10):
    print(f"X={x}: {pixels[x, 780]}")
