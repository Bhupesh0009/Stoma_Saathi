from PIL import Image

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
width, height = img.size
pixels = img.load()

print("Scanning column X = 20:")
for y in range(0, 150):
    r, g, b = pixels[20, y][:3]
    # Print the color for every 5 pixels
    if y % 5 == 0:
        print(f"Y={y}: RGB=({r}, {g}, {b})")
