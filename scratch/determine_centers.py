import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

def is_bg(rgb):
    r, g, b = rgb
    return r >= 242 and g >= 242 and b >= 242

# We search for the circle parameters for each of the 6 icons
centers_est_x = [87.5, 187.5, 288.0, 388.0, 488.0, 589.5]

for i, est_x in enumerate(centers_est_x):
    best_score = -1e9
    best_cx, best_cy, best_r = 0, 0, 0
    
    # Search range for cx, cy, and r
    for cx in range(int(est_x - 10), int(est_x + 10) + 1):
        for cy in range(725, 745):
            for r in range(30, 38):
                # Calculate score:
                # Number of non-bg pixels inside the circle minus bg pixels inside
                # Plus number of bg pixels in a ring outside the circle
                inside_non_bg = 0
                inside_bg = 0
                outside_bg = 0
                outside_total = 0
                
                # Check pixels
                for y in range(cy - r - 6, cy + r + 7):
                    for x in range(cx - r - 6, cx + r + 7):
                        dist2 = (x - cx)**2 + (y - cy)**2
                        if dist2 <= r**2:
                            if is_bg(pixels[x, y]):
                                inside_bg += 1
                            else:
                                inside_non_bg += 1
                        elif r**2 < dist2 <= (r + 4)**2:
                            outside_total += 1
                            if is_bg(pixels[x, y]):
                                outside_bg += 1
                
                # Score formula
                score = inside_non_bg - 1.5 * inside_bg + 1.5 * (outside_bg / outside_total if outside_total > 0 else 0) * r
                if score > best_score:
                    best_score = score
                    best_cx, best_cy, best_r = cx, cy, r
                    
    print(f"Icon {i+1} Best Circle: cx={best_cx}, cy={best_cy}, r={best_r} (Score: {best_score:.1f})")
