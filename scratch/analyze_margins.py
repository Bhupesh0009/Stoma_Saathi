from PIL import Image

img_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module2_barrier_ring.png"
with Image.open(img_path) as img:
    w, h = img.size
    y = h // 2
    # Let's check pixel colors along this row
    rgb_img = img.convert("RGB")
    for x in range(0, w, 5):
        color = rgb_img.getpixel((x, y))
        print(f"x={x:3d}: RGB={color}, Hex=#{color[0]:02x}{color[1]:02x}{color[2]:02x}")
