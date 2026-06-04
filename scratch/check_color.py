from PIL import Image

img_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module2_barrier_ring.png"
with Image.open(img_path) as img:
    w, h = img.size
    print(f"Size: {w}x{h}")
    # Sample different locations:
    # Corner, middle-edge, center
    points = [
        (0, 0),
        (w//2, 5),
        (5, h//2),
        (w//2, h//2),
        (w//4, h//4),
        (w - 5, h - 5)
    ]
    for pt in points:
        color = img.convert("RGB").getpixel(pt)
        print(f"Point {pt} - RGB: {color}, Hex: #{color[0]:02x}{color[1]:02x}{color[2]:02x}")
