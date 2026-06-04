import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780242540022.png"

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    w, h = img.size
    
    # 1. Header restroom/toilet icon:
    # Located on the right side of the green banner (Y: 5 to 90, X: 350 to 460)
    # Background color is green (#4E8D3A, around RGB 72,121,58)
    # The icon is white (RGB around 255,255,255)
    # Let's search for white pixels in this region
    icon_pixels = []
    for x in range(350, 460):
        for y in range(5, 90):
            r, g, b = rgb.getpixel((x, y))
            # Icon is white
            if r > 240 and g > 240 and b > 240:
                icon_pixels.append((x, y))
    if icon_pixels:
        ixs = [p[0] for p in icon_pixels]
        iys = [p[1] for p in icon_pixels]
        print(f"Header Toilet Icon: X={min(ixs)}-{max(ixs)}, Y={min(iys)}-{max(iys)}")
    
    # 2. Row 1: Tissue Box + Wipes (Y: 95 to 275, X: 15 to 250)
    # Let's search for non-white/non-bg pixels on the left side
    row1_pixels = []
    for x in range(15, 250):
        for y in range(115, 275): # start Y slightly lower to avoid TIPS badge
            r, g, b = rgb.getpixel((x, y))
            # Background is white/light green
            if r < 240 or g < 240 or b < 240:
                row1_pixels.append((x, y))
    if row1_pixels:
        r1xs = [p[0] for p in row1_pixels]
        r1ys = [p[1] for p in row1_pixels]
        print(f"Row 1 (Tissue & Wipes): X={min(r1xs)}-{max(r1xs)}, Y={min(r1ys)}-{max(r1ys)}")
        
    # 3. Row 2: Sanitizer Bottle (Y: 275 to 415, X: 15 to 250)
    row2_pixels = []
    for x in range(15, 250):
        for y in range(285, 410):
            r, g, b = rgb.getpixel((x, y))
            if r < 240 or g < 240 or b < 240:
                row2_pixels.append((x, y))
    if row2_pixels:
        r2xs = [p[0] for p in row2_pixels]
        r2ys = [p[1] for p in row2_pixels]
        print(f"Row 2 (Sanitizer): X={min(r2xs)}-{max(r2xs)}, Y={min(r2ys)}-{max(r2ys)}")
        
    # 4. Row 3: Clock (Y: 415 to 535, X: 15 to 250)
    row3_pixels = []
    for x in range(15, 250):
        for y in range(420, 530):
            r, g, b = rgb.getpixel((x, y))
            if r < 240 or g < 240 or b < 240:
                row3_pixels.append((x, y))
    if row3_pixels:
        r3xs = [p[0] for p in row3_pixels]
        r3ys = [p[1] for p in row3_pixels]
        print(f"Row 3 (Clock): X={min(r3xs)}-{max(r3xs)}, Y={min(r3ys)}-{max(r3ys)}")

    # 5. Bottom restroom scene (Y: 535 to 685, X: 0 to 468)
    # The restroom scene occupies the entire width of the card at the bottom.
    # Let's print its size
    print(f"Row 4 (Restroom Scene): X=0-{w-1}, Y=500-{h-1}")
