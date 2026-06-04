import os
from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
img_rgba = img.convert("RGBA")

def make_transparent_white(crop_img, tol=250):
    pixels = crop_img.load()
    w, h = crop_img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if r >= tol and g >= tol and b >= tol:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

def make_transparent_cream(crop_img, tol_r=250, tol_g=240, tol_b=230):
    pixels = crop_img.load()
    w, h = crop_img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if r >= tol_r and g >= tol_g and b >= tol_b:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

def crop_and_save_white(name, box, tol=250):
    crop = img_rgba.crop(box)
    crop = make_transparent_white(crop, tol)
    save_path = os.path.join(output_dir, f"{name}.png")
    crop.save(save_path)
    print(f"Saved {name}.png with size {crop.size}")

def crop_and_save_cream(name, box):
    crop = img_rgba.crop(box)
    crop = make_transparent_cream(crop)
    save_path = os.path.join(output_dir, f"{name}.png")
    crop.save(save_path)
    print(f"Saved {name}.png with size {crop.size}")

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

# 1. Realistic Stoma + skin + connector lines
# Search box: (30, 215, 502, 690)
# Skin background fades to white/light pink, let's use tol=251 for white replacement
crop_and_save_white("module1_normal_stoma", (30, 210, 502, 690), tol=251)

# 2. Card circular icons (background is white)
crop_and_save_white("module1_normal_color_icon", (520, 260, 600, 340), tol=254)
crop_and_save_white("module1_normal_texture_icon", (520, 420, 600, 500), tol=254)
crop_and_save_white("module1_normal_shape_icon", (520, 580, 600, 660), tol=254)

# 3. Bottom card warning and gauze (background is cream card: #FFF8EF)
crop_and_save_cream("module1_normal_warning", (110, 780, 200, 870))
crop_and_save_cream("module1_normal_gauze", (660, 755, 805, 915))
