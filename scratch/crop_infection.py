from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780494639822.png"
img = Image.open(img_path)
w, h = img.size
print(f"Original image dimensions: {w}x{h}")

img_rgba = img.convert("RGBA")

def get_non_white_bbox(im, x0, y0, x1, y1, tolerance=245):
    left = x1
    right = x0
    top = y1
    bottom = y0
    
    pixels = im.load()
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            if r < tolerance or g < tolerance or b < tolerance:
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
                
    if not found:
        return None
    return (left, top, right + 1, bottom + 1)

def make_transparent(crop_img, tolerance=248):
    crop_img = crop_img.convert("RGBA")
    pixels = crop_img.load()
    width, height = crop_img.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if r > tolerance and g > tolerance and b > tolerance:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

# Crop 1: Germ Icon (narrow down top right)
germ_box = get_non_white_bbox(img_rgba, int(w * 0.7), 10, w, 100)
print(f"Germ Box: {germ_box}")
if germ_box:
    crop = img_rgba.crop((germ_box[0] - 2, germ_box[1] - 2, germ_box[2] + 2, germ_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_infection_germ.png")
    print("Saved refined germ icon.")

# Crop 2: Thermometer (Symptom 1) - Y: 100 to 267, X: 10 to 220
thermometer_box = get_non_white_bbox(img_rgba, 10, 100, 220, 267)
print(f"Thermometer Box: {thermometer_box}")
if thermometer_box:
    crop = img_rgba.crop((thermometer_box[0] - 2, thermometer_box[1] - 2, thermometer_box[2] + 2, thermometer_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_infection_thermometer.png")
    print("Saved refined thermometer illustration.")

# Crop 3: Inflamed stoma (Symptom 2) - Y: 267 to 415, X: 10 to 220
inflamed_box = get_non_white_bbox(img_rgba, 10, 267, 220, 415)
print(f"Inflamed Box: {inflamed_box}")
if inflamed_box:
    crop = img_rgba.crop((inflamed_box[0] - 2, inflamed_box[1] - 2, inflamed_box[2] + 2, inflamed_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_infection_warmth.png")
    print("Saved refined inflamed stoma illustration.")

# Crop 4: Discharge (Symptom 3) - Y: 415 to 570, X: 10 to 230
discharge_box = get_non_white_bbox(img_rgba, 10, 415, 230, 570)
print(f"Discharge Box: {discharge_box}")
if discharge_box:
    crop = img_rgba.crop((discharge_box[0] - 2, discharge_box[1] - 2, discharge_box[2] + 2, discharge_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_infection_discharge.png")
    print("Saved refined discharge stoma illustration.")
