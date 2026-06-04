import os
from PIL import Image

def find():
    image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780387837839.png"
    img = Image.open(image_path).convert("RGB")
    width, height = img.size
    
    # Let's count non-white pixels in left column X in [20, 200]
    row_left_pixels = []
    for y in range(height):
        non_white = 0
        for x in range(20, 200):
            r, g, b = img.getpixel((x, y))
            if r < 240 or g < 240 or b < 240:
                non_white += 1
        row_left_pixels.append(non_white)
        
    # We expect bands of 0 (white space) separating the warning signs!
    # Let's print rows in Y: 100 to 677 where row_left_pixels is 0
    zero_rows = []
    for y in range(100, 677):
        if row_left_pixels[y] == 0:
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
        
    print("Empty horizontal bands in the left column Y-ranges:")
    for idx, (start, end) in enumerate(bands):
        print(f"Band {idx+1}: Y {start} to {end} (center: {(start+end)//2})")

if __name__ == "__main__":
    find()
