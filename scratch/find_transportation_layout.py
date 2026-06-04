from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780243482966.png"

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    width, height = img.size
    
    # 1. Let's find the vertical divider line.
    # It should be a vertical line of gray color stretching from Y = 85 to Y = 460.
    # Let's check pixel colors along the horizontal axis at Y = 200.
    y = 200
    print("Horizontal profile at Y = 200:")
    for x in range(150, 350, 2):
        r, g, b = rgb.getpixel((x, y))
        print(f"x={x:3d}: RGB=({r:3d}, {g:3d}, {b:3d})")
