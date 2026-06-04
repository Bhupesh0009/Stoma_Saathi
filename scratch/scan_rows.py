import os
from PIL import Image

def find_horizontal_dividers():
    image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780394346447.png"
    if not os.path.exists(image_path):
        print("Image does not exist!")
        return
        
    img = Image.open(image_path).convert("RGB")
    width, height = img.size
    
    # We count non-white pixels in right column (X in [220, 520]) where text is.
    row_right_pixels = []
    for y in range(height):
        non_white = 0
        for x in range(220, 520):
            r, g, b = img.getpixel((x, y))
            if r < 245 or g < 245 or b < 245:
                non_white += 1
        row_right_pixels.append(non_white)
        
    # We look for zero rows (spacing) in Y: 100 to 680
    zero_rows = []
    for y in range(100, 680):
        if row_right_pixels[y] == 0:
            zero_rows.append(y)
            
    # Group contiguous zero Ys into bands
    bands = []
    if zero_rows:
        start = zero_rows[0]
        prev = zero_rows[0]
        for y in zero_rows[1:]:
            if y - prev > 5:
                bands.append((start, prev))
                start = y
            prev = y
        bands.append((start, prev))
        
    print("Empty horizontal bands in the right column Y-ranges:")
    for idx, (start, end) in enumerate(bands):
        print(f"Band {idx+1}: Y {start} to {end} (center: {(start+end)//2})")

if __name__ == "__main__":
    find_horizontal_dividers()
