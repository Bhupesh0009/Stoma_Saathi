from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780494980100.png"
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

# Crop 1: Female patient nausea (X: 10 to 390)
# We search up to 390 to completely exclude the vertical divider line around X=399.
nausea_box = get_non_white_bbox(img_rgba, 10, 100, 390, 380)
print(f"Refined Nausea Box: {nausea_box}")
if nausea_box:
    crop = img_rgba.crop((nausea_box[0] - 2, nausea_box[1] - 2, nausea_box[2] + 2, nausea_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_gi_nausea.png")
    print("Saved refined nausea illustration.")

# Crop 2: Male patient bloating (X: 410 to w - 10)
# We search starting from 410 to completely exclude the vertical divider line around X=399.
bloating_box = get_non_white_bbox(img_rgba, 410, 100, w - 10, 380)
print(f"Refined Bloating Box: {bloating_box}")
if bloating_box:
    crop = img_rgba.crop((bloating_box[0] - 2, bloating_box[1] - 2, bloating_box[2] + 2, bloating_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_gi_bloating.png")
    print("Saved refined bloating illustration.")
