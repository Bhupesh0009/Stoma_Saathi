from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240431040.png"
with Image.open(image_path) as img:
    w, h = img.size
    print(f"Dimensions: {w}x{h}")
    # Sample column at x = 10 (inside the card area)
    x = 10
    rgb_img = img.convert("RGB")
    for y in range(0, h, 10):
        color = rgb_img.getpixel((x, y))
        # print when color changes or every 20 pixels
        print(f"y={y:3d}: RGB={color}, Hex=#{color[0]:02x}{color[1]:02x}{color[2]:02x}")
