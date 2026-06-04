from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780493776065.png"
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

# Crop 1: Redness (Symptom 1) - Y: 100 to 280, X: 10 to 220
redness_box = get_non_white_bbox(img_rgba, 10, 100, 220, 280)
print(f"Redness Box: {redness_box}")
if redness_box:
    crop = img_rgba.crop((redness_box[0] - 2, redness_box[1] - 2, redness_box[2] + 2, redness_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_skin_redness.png")
    print("Saved redness illustration.")

# Crop 2: Swelling (Symptom 2) - Y: 280 to 425, X: 10 to 220
swelling_box = get_non_white_bbox(img_rgba, 10, 280, 220, 425)
print(f"Swelling Box: {swelling_box}")
if swelling_box:
    crop = img_rgba.crop((swelling_box[0] - 2, swelling_box[1] - 2, swelling_box[2] + 2, swelling_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_skin_swelling.png")
    print("Saved swelling illustration.")

# Crop 3: Discharge (Symptom 3) - Y: 425 to 575, X: 10 to 240
discharge_box = get_non_white_bbox(img_rgba, 10, 425, 240, 575)
print(f"Discharge Box: {discharge_box}")
if discharge_box:
    crop = img_rgba.crop((discharge_box[0] - 2, discharge_box[1] - 2, discharge_box[2] + 2, discharge_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_skin_discharge.png")
    print("Saved discharge illustration.")
