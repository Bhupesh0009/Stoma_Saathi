from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780494245821.png"
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

# Crop 1: Patient holding abdomen - Y: 100 to 366, X: 10 to 280
patient_box = get_non_white_bbox(img_rgba, 10, 100, 280, 366)
print(f"Patient Box: {patient_box}")
if patient_box:
    crop = img_rgba.crop((patient_box[0] - 2, patient_box[1] - 2, patient_box[2] + 2, patient_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_pain_patient.png")
    print("Saved patient illustration.")

# Crop 2: Stoma with pain indicators - Y: 370 to 570, X: 10 to 280
stoma_box = get_non_white_bbox(img_rgba, 10, 370, 280, 570)
print(f"Stoma Box: {stoma_box}")
if stoma_box:
    crop = img_rgba.crop((stoma_box[0] - 2, stoma_box[1] - 2, stoma_box[2] + 2, stoma_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_pain_stoma.png")
    print("Saved stoma illustration.")
