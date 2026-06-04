from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495333632.png"
img = Image.open(img_path)
w, h = img.size
img_rgba = img.convert("RGBA")
pixels = img_rgba.load()

# Let's profile left column Y ranges
# We will count non-white pixels in the horizontal band X = 50 to 120
print("--- LEFT COLUMN PROFILE (X = 50 to 120) ---")
left_active_rows = []
for y in range(100, 550):
    non_white_count = 0
    for x in range(50, 120):
        r, g, b, a = pixels[x, y]
        if r < 240 or g < 240 or b < 240:
            non_white_count += 1
    if non_white_count > 0:
        left_active_rows.append((y, non_white_count))

# Print contiguous active row intervals
if left_active_rows:
    start_y = left_active_rows[0][0]
    prev_y = start_y
    for y, count in left_active_rows[1:]:
        if y > prev_y + 1:
            print(f"Active interval: Y = {start_y} to {prev_y}")
            start_y = y
        prev_y = y
    print(f"Active interval: Y = {start_y} to {prev_y}")

# Let's profile right column Y ranges
# band X = 620 to 690
print("\n--- RIGHT COLUMN PROFILE (X = 620 to 690) ---")
right_active_rows = []
for y in range(100, 550):
    non_white_count = 0
    for x in range(620, 690):
        r, g, b, a = pixels[x, y]
        if r < 240 or g < 240 or b < 240:
            non_white_count += 1
    if non_white_count > 0:
        right_active_rows.append((y, non_white_count))

if right_active_rows:
    start_y = right_active_rows[0][0]
    prev_y = start_y
    for y, count in right_active_rows[1:]:
        if y > prev_y + 1:
            print(f"Active interval: Y = {start_y} to {prev_y}")
            start_y = y
        prev_y = y
    print(f"Active interval: Y = {start_y} to {prev_y}")
