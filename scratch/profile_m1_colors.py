from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()

# Print background values at the top-left and top-right corners
print("Top-left corners:")
for y in range(5):
    for x in range(5):
        print(f"({x},{y}): {pixels[x, y]}")

print("\nAround stoma section (x=50, y=210):")
print(pixels[50, 210])
