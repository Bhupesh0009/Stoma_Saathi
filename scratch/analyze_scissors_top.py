from PIL import Image
import os

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240779442.jpg"

with Image.open(image_path) as img:
    rgb_img = img.convert("RGB")
    # Scan X: 800 to 1000, Y: 180 to 235
    # Print the Y coordinates where we find pixels that are darker (R < 240, G < 240, B < 240)
    for y in range(180, 235):
        found = False
        for x in range(800, 1000):
            r, g, b = rgb_img.getpixel((x, y))
            if r < 240 and g < 240 and b < 240:
                found = True
                break
        if found:
            # print first and last X
            xs = []
            for x in range(800, 1000):
                r, g, b = rgb_img.getpixel((x, y))
                if r < 240 and g < 240 and b < 240:
                    xs.append(x)
            print(f"y={y}: found dark pixels from X={min(xs)} to {max(xs)}")
        else:
            print(f"y={y}: clear")
