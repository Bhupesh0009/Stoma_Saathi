from PIL import Image

def inspect_crop(filename):
    crop_img = Image.open(filename)
    w, h = crop_img.size
    print(f"{filename} Crop size: {w}x{h}")

    pixels = crop_img.load()
    dark_pixels = 0
    for x in range(w - 25, w):
        for y in range(h):
            r, g, b, a = pixels[x, y]
            # Check for very dark pixels (typical text)
            if a > 0 and r < 80 and g < 80 and b < 80:
                dark_pixels += 1
                if dark_pixels < 10:
                    print(f"  Dark pixel at x={x}, y={y}: rgba=({r},{g},{b},{a})")
    print(f"Total dark pixels on right of {filename}: {dark_pixels}")

inspect_crop(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_pain_patient.png")
inspect_crop(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_pain_stoma.png")
