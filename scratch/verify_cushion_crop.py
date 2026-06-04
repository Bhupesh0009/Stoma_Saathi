from PIL import Image

c_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png"
c_img = Image.open(c_path)
width, height = c_img.size
pixels = c_img.load()

print("Scanning top of cushion image for dark pixels:")
dark_pixels_found = 0
for y in range(min(15, height)):
    for x in range(width):
        r, g, b = pixels[x, y][:3]
        if r < 100 and g < 100 and b < 100:
            dark_pixels_found += 1
            if dark_pixels_found <= 5:
                print(f"Dark pixel at X={x}, Y={y}: ({r}, {g}, {b})")

print("Total dark pixels in top 15 rows:", dark_pixels_found)
