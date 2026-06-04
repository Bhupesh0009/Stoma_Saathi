from PIL import Image

crop_img = Image.open(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_skin_discharge.png")
w, h = crop_img.size
print(f"Discharge Crop size: {w}x{h}")

pixels = crop_img.load()
# Let's inspect the rightmost 25 pixels.
# If there are any dark pixels (which indicate text), let's print them.
for x in range(w - 25, w):
    for y in range(h):
        r, g, b, a = pixels[x, y]
        if a > 0 and r < 100 and g < 100 and b < 100:
            print(f"Dark pixel at x={x}, y={y}: rgba=({r},{g},{b},{a})")
            break
