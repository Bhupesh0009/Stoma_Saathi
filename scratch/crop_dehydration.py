from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780493462888.png"
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
            # Convert pixels close to white to transparent
            if r > tolerance and g > tolerance and b > tolerance:
                pixels[x, y] = (255, 255, 255, 0)
    return crop_img

# Crop 1: Droplet (narrow down top right)
droplet_box = get_non_white_bbox(img_rgba, 480, 10, 580, 100)
print(f"Refined Droplet Box: {droplet_box}")
if droplet_box:
    crop = img_rgba.crop((droplet_box[0] - 2, droplet_box[1] - 2, droplet_box[2] + 2, droplet_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_dehydration_droplet.png")
    print("Saved refined droplet icon.")

# Crop 2: Dry mouth (X: 10 to 220, Y: 100 to 310)
dry_mouth_box = get_non_white_bbox(img_rgba, 10, 100, 220, 310)
print(f"Refined Dry Mouth Box: {dry_mouth_box}")
if dry_mouth_box:
    # Let's crop it. Note: the bubble on the top right of the circle might extend slightly past X=220.
    # Let's see: the dry mouth bubble is at the top right of the girl's head. Let's expand the X limit to 250 to catch the bubble!
    dry_mouth_box = get_non_white_bbox(img_rgba, 10, 100, 260, 310)
    print(f"Re-calculated Dry Mouth Box (wider X): {dry_mouth_box}")
    crop = img_rgba.crop((dry_mouth_box[0] - 2, dry_mouth_box[1] - 2, dry_mouth_box[2] + 2, dry_mouth_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_dehydration_dry_mouth.png")
    print("Saved refined dry mouth illustration.")

# Crop 3: Reduced urine (X: 10 to 220, Y: 310 to 490)
# Let's search X up to 250 to make sure we get the urine drop next to the glass.
reduced_urine_box = get_non_white_bbox(img_rgba, 10, 310, 250, 490)
print(f"Refined Reduced Urine Box: {reduced_urine_box}")
if reduced_urine_box:
    crop = img_rgba.crop((reduced_urine_box[0] - 2, reduced_urine_box[1] - 2, reduced_urine_box[2] + 2, reduced_urine_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_dehydration_urine.png")
    print("Saved refined reduced urine illustration.")

# Crop 4: Dizziness (X: 10 to 220, Y: 490 to 680)
# Let's search X up to 250 to capture the swirls around the man's head.
dizziness_box = get_non_white_bbox(img_rgba, 10, 490, 250, 680)
print(f"Refined Dizziness Box: {dizziness_box}")
if dizziness_box:
    crop = img_rgba.crop((dizziness_box[0] - 2, dizziness_box[1] - 2, dizziness_box[2] + 2, dizziness_box[3] + 2))
    crop = make_transparent(crop)
    crop.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_dehydration_dizzy.png")
    print("Saved refined dizziness illustration.")
