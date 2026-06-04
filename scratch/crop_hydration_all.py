from PIL import Image
import os

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780498319169.png"
output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

img = Image.open(img_path).convert("RGBA")

def make_transparent_average(crop_img, threshold=245):
    pixels = crop_img.load()
    w, h = crop_img.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = pixels[x, y]
            if (r + g + b) / 3 >= threshold:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

# 1. Main Water Bottle & Glass on left (X: 10 to 240, Y: 100 to 480)
main_crop = img.crop((10, 100, 240, 480))
main_crop = make_transparent_average(main_crop, threshold=248)
main_crop.save(os.path.join(output_dir, "module4_hydration_main.png"))
print("Saved module4_hydration_main.png")

# 2. Water Droplet Bullet Icon (X: 250 to 300, Y: 220 to 280)
droplet_crop = img.crop((250, 220, 300, 280))
droplet_crop = make_transparent_average(droplet_crop, threshold=245)
droplet_crop.save(os.path.join(output_dir, "module4_hydration_droplet.png"))
print("Saved module4_hydration_droplet.png")

# 3. ORS Circle Icon (X: 250 to 300, Y: 300 to 365)
ors_crop = img.crop((250, 300, 300, 365))
ors_crop = make_transparent_average(ors_crop, threshold=245)
ors_crop.save(os.path.join(output_dir, "module4_hydration_ors_icon.png"))
print("Saved module4_hydration_ors_icon.png")

# 4. Buttermilk Icon (X: 250 to 300, Y: 415 to 485)
buttermilk_crop = img.crop((250, 415, 300, 485))
buttermilk_crop = make_transparent_average(buttermilk_crop, threshold=245)
buttermilk_crop.save(os.path.join(output_dir, "module4_hydration_buttermilk.png"))
print("Saved module4_hydration_buttermilk.png")
