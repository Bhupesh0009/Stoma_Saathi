from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

def color_dist(c1, c2):
    return sum(abs(a - b) for a, b in zip(c1, c2))

with Image.open(image_path) as img:
    rgb_img = img.convert("RGB")
    y_min, y_max = 187, 271
    bg_color = rgb_img.getpixel((252, (y_min + y_max)//2))
    
    print(f"Sampling dark pixels for walking row (bg_color={bg_color}):")
    # Let's print out the coordinates of dark pixels that are on the far right (X > 380)
    for x in range(380, 655):
        for y in range(y_min, y_max):
            color = rgb_img.getpixel((x, y))
            if color_dist(color, bg_color) > 15:
                print(f"x={x}, y={y}: RGB={color}")
