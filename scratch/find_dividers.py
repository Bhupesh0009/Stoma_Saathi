import os
from PIL import Image

def find_horizontal_dividers():
    image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780387837839.png"
    if not os.path.exists(image_path):
        print("Image does not exist!")
        return
        
    img = Image.open(image_path).convert("RGB")
    width, height = img.size
    
    # Let's count non-white pixels across horizontal rows (X projection)
    # We look for rows that are almost completely white (all R, G, B > 250)
    row_non_white = []
    for y in range(height):
        non_white_count = 0
        for x in range(width):
            r, g, b = img.getpixel((x, y))
            if r < 250 or g < 250 or b < 250:
                non_white_count += 1
        row_non_white.append(non_white_count)
        
    # Print Y ranges where non_white_count is extremely low (white space) or high (content)
    # This helps us identify exact divider lines!
    print("Row non-white count (first 100 rows):")
    for y in range(0, 150, 5):
        print(f"Row {y}-{y+5}: {[row_non_white[i] for i in range(y, min(y+5, height))]}")
        
    # Let's look for divider lines. The dividers are light grey horizontal lines!
    # A light grey line would have pixels around R, G, B = 230-240.
    # Let's search for exact horizontal lines of light grey across the middle columns:
    grey_rows = []
    for y in range(height):
        # Check if row is mostly light grey (R, G, B in [220, 240])
        grey_count = 0
        for x in range(width // 4, 3 * width // 4):
            r, g, b = img.getpixel((x, y))
            if 220 <= r <= 245 and 220 <= g <= 245 and 220 <= b <= 245:
                grey_count += 1
        if grey_count > width // 2 - 10:
            grey_rows.append(y)
            
    print("Detected grey rows (potential dividers):", grey_rows)

if __name__ == "__main__":
    find_horizontal_dividers()
