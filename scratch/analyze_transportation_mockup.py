from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780243482966.png"

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    width, height = img.size
    print(f"Mockup size: {width}x{height}")
    
    # Let's check vertical transitions in the middle column
    x_mid = width // 2
    for y in range(0, height, 5):
        r, g, b = rgb.getpixel((x_mid, y))
        print(f"y={y:3d}: RGB=({r:3d}, {g:3d}, {b:3d})")
