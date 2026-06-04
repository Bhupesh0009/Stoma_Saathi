from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780242540022.png"

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    width, height = img.size
    print(f"Mockup size: {width}x{height}")
    
    # We will sample pixel colors along the middle column (x = width // 2)
    # and find where colors transition.
    # Header color is dark green (#4E8D3A).
    # Background color is white/light-grey.
    
    x = width // 2
    for y in range(0, height, 5):
        r, g, b = rgb.getpixel((x, y))
        print(f"y={y:3d}: RGB=({r:3d}, {g:3d}, {b:3d})")
