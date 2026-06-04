import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780243482966.png"

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    w, h = img.size
    
    # 1. Bus icon in header: (Y: 5 to 75, X: 350 to w-5)
    # Background is purple (#7A5AB5, RGB around 110,81,155)
    # Icon is white (RGB > 240)
    bus_pixels = []
    for x in range(350, w):
        for y in range(5, 78):
            r, g, b = rgb.getpixel((x, y))
            if r > 240 and g > 240 and b > 240:
                bus_pixels.append((x, y))
    if bus_pixels:
        bxs = [p[0] for p in bus_pixels]
        bys = [p[1] for p in bus_pixels]
        print(f"Header Bus Icon: X={min(bxs)}-{max(bxs)}, Y={min(bys)}-{max(bys)}")
        
    # 2. Left Tips Column Icons (X < 120)
    # Row 1 (Seat): Y = 90 to 200
    r1_px = []
    for x in range(5, 120):
        for y in range(95, 205):
            r, g, b = rgb.getpixel((x, y))
            if r < 240 or g < 240 or b < 240:
                r1_px.append((x, y))
    if r1_px:
        r1xs = [p[0] for p in r1_px]
        r1ys = [p[1] for p in r1_px]
        print(f"Row 1 Icon (Seat): X={min(r1xs)}-{max(r1xs)}, Y={min(r1ys)}-{max(r1ys)}")
        
    # Row 2 (Crowd): Y = 210 to 320
    r2_px = []
    for x in range(5, 120):
        for y in range(215, 325):
            r, g, b = rgb.getpixel((x, y))
            if r < 240 or g < 240 or b < 240:
                r2_px.append((x, y))
    if r2_px:
        r2xs = [p[0] for p in r2_px]
        r2ys = [p[1] for p in r2_px]
        print(f"Row 2 Icon (Crowd): X={min(r2xs)}-{max(r2xs)}, Y={min(r2ys)}-{max(r2ys)}")
        
    # Row 3 (Bag): Y = 330 to 440
    r3_px = []
    for x in range(5, 120):
        for y in range(335, 445):
            r, g, b = rgb.getpixel((x, y))
            if r < 240 or g < 240 or b < 240:
                r3_px.append((x, y))
    if r3_px:
        r3xs = [p[0] for p in r3_px]
        r3ys = [p[1] for p in r3_px]
        print(f"Row 3 Icon (Bag): X={min(r3xs)}-{max(r3xs)}, Y={min(r3ys)}-{max(r3ys)}")
