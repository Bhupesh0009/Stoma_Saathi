from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

rows = [
    ("walking", 180, 276),
    ("yoga_stretch", 243, 376),
    ("swimming", 353, 436),
    ("sports", 418, 546),
    ("hydration", 493, 578),
    ("avoid_lifting", 585, 676),
    ("avoid_pressure", 668, 756),
    ("avoid_contact", 743, 846),
    ("avoid_symptoms", 793, 903),
    ("character", 878, 1016)
]

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    width, height = img.size
    
    # We know that the illustration area is on the right, starting from X=250 to 670.
    # Let's print out the profile of non-background pixels on the X-axis for each row, 
    # but ignoring any horizontal lines (dividers) by checking if a column has many non-bg pixels.
    # Also, the background of the green card is Color(0xFFF9FDF9) - very light green, 
    # and the red card is Color(0xFFFDF8F7) - very light red.
    # So we should check if a pixel is significantly different from white/light green/light red.
    
    for name, y_min, y_max in rows:
        print(f"\nRow: {name} (Y: {y_min} to {y_max})")
        # Find background color at X=50, Y=y_mid
        y_mid = (y_min + y_max) // 2
        bg_color = rgb.getpixel((50, y_mid))
        
        # Let's count non-bg pixels in each column
        counts = []
        for x in range(250, 680):
            count = 0
            for y in range(y_min + 3, y_max - 3): # inset Y by 3 to avoid horizontal divider lines
                r, g, b = rgb.getpixel((x, y))
                # Check distance from white and card background
                dist_white = abs(r - 255) + abs(g - 255) + abs(b - 255)
                dist_bg = abs(r - bg_color[0]) + abs(g - bg_color[1]) + abs(b - bg_color[2])
                # If it's a drawing pixel, it's typically darker or colored
                if dist_white > 15 and dist_bg > 15:
                    count += 1
            counts.append(count)
            
        # Group adjacent columns with non-zero count
        intervals = []
        start_x = None
        for i, c in enumerate(counts):
            real_x = 250 + i
            if c > 1: # at least 2 pixels of drawing
                if start_x is None:
                    start_x = real_x
            else:
                if start_x is not None:
                    intervals.append((start_x, real_x - 1))
                    start_x = None
        if start_x is not None:
            intervals.append((start_x, 679))
            
        print("Detected illustration columns:", intervals)
