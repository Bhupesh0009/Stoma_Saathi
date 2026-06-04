from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780241417268.jpg"

with Image.open(image_path) as img:
    rgb = img.convert("RGB")
    width, height = img.size
    
    # We will scan rows from y=360 to y=430 (swimming row)
    # Background color is light green (from the green card)
    # Let's find background color at x=50, y=380
    bg_color = rgb.getpixel((50, 380))
    print(f"Card background color: {bg_color}")
    
    # Print the sum of color differences from background for each column
    col_dists = []
    for x in range(200, 680):
        col_dist = 0
        for y in range(360, 430): # inside the row, avoiding dividers
            r, g, b = rgb.getpixel((x, y))
            # Distance from background color
            dist = abs(r - bg_color[0]) + abs(g - bg_color[1]) + abs(b - bg_color[2])
            # Also check distance from pure white (255, 255, 255)
            dist_white = abs(r - 255) + abs(g - 255) + abs(b - 255)
            if dist > 20 and dist_white > 20:
                col_dist += dist
        col_dists.append((x, col_dist))
        
    # Print columns with significant color differences (representing the swimmer illustration)
    active_cols = [x for x, d in col_dists if d > 200] # threshold of cumulative difference
    if active_cols:
        print(f"Swimmer active X range: {active_cols[0]} to {active_cols[-1]}")
    else:
        print("No swimmer detected with current threshold.")
