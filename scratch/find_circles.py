import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Let's search for pink pixels in Y: 600 to 820
print("Finding pink circles:")
for i in range(6):
    x_min_zone = int(i * (width / 6))
    x_max_zone = int((i + 1) * (width / 6))
    
    pink_pixels = []
    for y in range(650, 810):
        for x in range(x_min_zone, x_max_zone):
            r, g, b = pixels[x, y]
            # Pink background check: R high, G and B moderate
            # e.g., R in 240..255, G in 210..235, B in 210..235
            if r >= 235 and 210 <= g <= 236 and 210 <= b <= 236:
                pink_pixels.append((x, y))
                
    if pink_pixels:
        xs = [p[0] for p in pink_pixels]
        ys = [p[1] for p in pink_pixels]
        print(f"Icon {i+1}: X: {min(xs)}..{max(xs)}, Y: {min(ys)}..{max(ys)}")
    else:
        print(f"Icon {i+1}: No pink pixels found")
