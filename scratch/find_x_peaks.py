import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780567253660.jpg"
img = Image.open(image_path).convert("RGB")
width, height = img.size
pixels = img.load()

# Count pink or graphic pixels for each X column, summed over Y: 710 to 770 (safe range for circles)
x_counts = [0] * width
for x in range(width):
    for y in range(710, 770):
        r, g, b = pixels[x, y]
        # Check if pink background or darker red graphic
        if r > 110 and r > g * 1.07 and r > b * 1.07:
            x_counts[x] += 1

# Let's print out the column counts to find peaks
print("X column counts (X: count):")
active_range = []
for x in range(width):
    if x_counts[x] > 5:  # threshold of 5 pixels
        active_range.append(x)
        
# Group contiguous ranges
if active_range:
    groups = []
    current_group = [active_range[0]]
    for val in active_range[1:]:
        if val - current_group[-1] <= 5:
            current_group.append(val)
        else:
            groups.append(current_group)
            current_group = [val]
    groups.append(current_group)
    
    for i, g in enumerate(groups):
        cx = sum(g) / len(g)
        max_val = max(x_counts[x] for x in g)
        print(f"Group {i+1}: X range {g[0]}..{g[-1]} (width={len(g)}), Center X = {cx:.1f}, Max Count = {max_val}")
