import os
from PIL import Image

def detect():
    image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780387837839.png"
    img = Image.open(image_path).convert("RGB")
    width, height = img.size
    
    # We want to find the horizontal grey lines.
    # Let's print rows that have high count of light grey pixels (e.g. R, G, B in [230, 240])
    dividers = []
    for y in range(height):
        grey_count = 0
        for x in range(20, width - 20):
            r, g, b = img.getpixel((x, y))
            # Grey lines are around 230-245
            if 225 <= r <= 245 and 225 <= g <= 245 and 225 <= b <= 245:
                grey_count += 1
        if grey_count > width * 0.8:
            dividers.append(y)
            
    print("All detected divider rows:", dividers)
    
    # Let's group contiguous divider rows into lines
    lines = []
    if dividers:
        start = dividers[0]
        prev = dividers[0]
        for y in dividers[1:]:
            if y - prev > 5:
                lines.append((start, prev))
                start = y
            prev = y
        lines.append((start, prev))
        
    print("Contiguous divider lines Y-ranges:")
    for idx, (start, end) in enumerate(lines):
        print(f"Line {idx+1}: Y {start} to {end} (center: {(start+end)//2})")

if __name__ == "__main__":
    detect()
