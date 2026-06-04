import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\about_phone.png"
ref_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\062027b2-7f37-4592-8e7e-032152ece79e\media__1780565576086.jpg"

ref_img = Image.open(ref_path).convert("RGB")
w, h = ref_img.size
pixels = ref_img.load()

# Let's sample colors at key locations in ref_img:
# 1. Background color of the page: sample near top-center but below wave, e.g., (width // 2, 220)
bg_color = pixels[w // 2, 220]

# 2. STOMA SAATHI title text color: sample near the center of the text "STOMA SAATHI"
# Title is located in the top part. Let's find where y is around 160-180.
# We'll scan around x=w//2, y in [140, 180] for the darkest color.
dark_teal = None
min_brightness = 765
for y in range(140, 190):
    for x in range(w // 4, 3 * w // 4):
        r, g, b = pixels[x, y]
        brightness = r + g + b
        if brightness < min_brightness:
            min_brightness = brightness
            dark_teal = (r, g, b)

# 3. Card background color:
# Card 1 (Developed By) is located around y in [500, 600].
# Let's sample near the right side of Card 1, e.g., (w - 100, 530)
card_bg = pixels[w - 100, 530]

# 4. Icon circle background color (dark teal inside the card icon circle):
# Let's search inside the circle of Card 1 (Developed By).
# Circle is on the left side, around x in [80, 150], y in [500, 560]
icon_circle_color = None
min_circle_brightness = 765
for y in range(500, 560):
    for x in range(80, 160):
        r, g, b = pixels[x, y]
        # It's a dark color, but not white (white is the icon). Let's find a dark teal (g > r and b > r, and small values)
        if g > r + 10 and b > r + 10 and (r + g + b) < min_circle_brightness:
            min_circle_brightness = r + g + b
            icon_circle_color = (r, g, b)

# 5. Divider line color (the vertical divider in the card):
# It should be a light teal/grey, e.g., around x in [160, 200], y in [500, 560]
divider_color = None
# Let's just scan and look for intermediate colors
print(f"Ref dimensions: {w}x{h}")
print(f"Page BG color sampled: {bg_color} (Hex: #{bg_color[0]:02X}{bg_color[1]:02X}{bg_color[2]:02X})")
print(f"Dark Teal title color: {dark_teal} (Hex: #{dark_teal[0]:02X}{dark_teal[1]:02X}{dark_teal[2]:02X})")
print(f"Card BG color sampled: {card_bg} (Hex: #{card_bg[0]:02X}{card_bg[1]:02X}{card_bg[2]:02X})")
print(f"Icon circle BG color: {icon_circle_color} (Hex: #{icon_circle_color[0]:02X}{icon_circle_color[1]:02X}{icon_circle_color[2]:02X})")
