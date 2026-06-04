from PIL import Image

img_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780495816118.jpg"
img = Image.open(img_path)
pixels = img.convert("RGBA").load()

# Let's count non-white pixels along columns (projection)
# to see where the icons are horizontally in the cards.
# Card area is roughly X = 500 to 650.
for x in range(500, 650):
    non_white_count = 0
    for y in range(240, 690):
        r, g, b, a = pixels[x, y]
        # check if it's not the background color (approx r >= 250, g >= 240, b >= 240)
        if not (r >= 250 and g >= 240 and b >= 240):
            non_white_count += 1
    if non_white_count > 0:
        # print X only if there is a peak or active pixels
        pass

# Let's find bounding boxes of the three icons using a very precise background filter:
# background is extremely light pink/white (r >= 252, g >= 242, b >= 240)
def find_tight_box(x0, y0, x1, y1):
    left = x1
    right = x0
    top = y1
    bottom = y0
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            # Foreground is anything that deviates from the light pink background
            if not (r >= 252 and g >= 242 and b >= 240):
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
    if not found:
        return None
    return (left, top, right, bottom)

# Let's search inside the cards
print("Tight Bounding Boxes:")
# For the icons, they are inside the cards. Card backgrounds are pure white (255, 255, 255).
# So background filter: not (r >= 254 and g >= 254 and b >= 254) is perfect inside the card!
def find_icon_box(x0, y0, x1, y1):
    left = x1
    right = x0
    top = y1
    bottom = y0
    found = False
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = pixels[x, y]
            if not (r >= 253 and g >= 253 and b >= 253):
                found = True
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
    if not found:
        return None
    return (left, top, right, bottom)

print("Color Icon (Card 1):", find_icon_box(510, 240, 600, 360))
print("Texture Icon (Card 2):", find_icon_box(510, 400, 600, 520))
print("Shape Icon (Card 3):", find_icon_box(510, 560, 600, 680))
print("Warning Icon (Bottom Left):", find_tight_box(100, 770, 220, 870))
print("Gauze Icon (Bottom Right):", find_tight_box(650, 750, 810, 920))
