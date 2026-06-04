from PIL import Image
import os

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780386565475.png"

with Image.open(image_path) as img:
    w, h = img.size
    rgb_img = img.convert("RGB")
    
    # Let's inspect different columns to locate the elements precisely:
    # 1. Worried Patient (on the left, X < 200)
    # He has green sweater (greenish pixels) and black hair.
    # Let's find non-white pixels (R < 250, G < 250, B < 250) in X range [0, 200]
    patient_pixels = []
    for x in range(0, 180):
        for y in range(0, h):
            r, g, b = rgb_img.getpixel((x, y))
            if r < 250 or g < 250 or b < 250:
                patient_pixels.append((x, y))
                
    if patient_pixels:
        pxs = [p[0] for p in patient_pixels]
        pys = [p[1] for p in patient_pixels]
        print(f"Patient bounds: X:({min(pxs)} to {max(pxs)}), Y:({min(pys)} to {max(pys)})")
        
    # 2. Warning Triangle Icon (X range [120, 240], Y range [20, 150])
    # The triangle is red (high R, low G, low B)
    warning_pixels = []
    for x in range(120, 240):
        for y in range(10, 150):
            r, g, b = rgb_img.getpixel((x, y))
            # Red triangle check
            if r > 180 and g < 50 and b < 50:
                warning_pixels.append((x, y))
                
    if warning_pixels:
        wxs = [p[0] for p in warning_pixels]
        wys = [p[1] for p in warning_pixels]
        print(f"Warning icon bounds: X:({min(wxs)} to {max(wxs)}), Y:({min(wys)} to {max(wys)})")

    # 3. Nurse (X range [550, 740])
    # She has blue scrubs (high B, low R, low G) and black hair.
    nurse_pixels = []
    for x in range(550, 750):
        for y in range(0, h):
            r, g, b = rgb_img.getpixel((x, y))
            if r < 250 or g < 250 or b < 250:
                nurse_pixels.append((x, y))
                
    if nurse_pixels:
        nxs = [p[0] for p in nurse_pixels]
        nys = [p[1] for p in nurse_pixels]
        print(f"Nurse bounds: X:({min(nxs)} to {max(nxs)}), Y:({min(nys)} to {max(nys)})")

    # 4. Green Shield Icon (X range [740, 810], Y range [60, 140])
    # Green check (high G, low R, low B)
    shield_pixels = []
    for x in range(740, 810):
        for y in range(60, 140):
            r, g, b = rgb_img.getpixel((x, y))
            if g > 120 and r < 80 and b < 80:
                shield_pixels.append((x, y))
                
    if shield_pixels:
        sxs = [p[0] for p in shield_pixels]
        sys = [p[1] for p in shield_pixels]
        print(f"Green shield bounds: X:({min(sxs)} to {max(sxs)}), Y:({min(sys)} to {max(sys)})")

    # 5. Red Heart/Hand Icon (X range [740, 810], Y range [150, 230])
    # Red heart check (high R, low G, low B)
    heart_pixels = []
    for x in range(740, 810):
        for y in range(150, 230):
            r, g, b = rgb_img.getpixel((x, y))
            if r > 180 and g < 80 and b < 80:
                heart_pixels.append((x, y))
                
    if heart_pixels:
        hxs = [p[0] for p in heart_pixels]
        hys = [p[1] for p in heart_pixels]
        print(f"Red heart/hand bounds: X:({min(hxs)} to {max(hxs)}), Y:({min(hys)} to {max(hys)})")
