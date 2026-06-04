from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

with Image.open(image_path) as img:
    rgb_img = img.convert("RGB")
    y = 230
    print("Horizontal profile at y = 230:")
    for x in range(200, 680, 5):
        color = rgb_img.getpixel((x, y))
        print(f"x={x:3d}: RGB={color}")
