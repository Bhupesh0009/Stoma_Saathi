import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780242540022.png"
brain_dir = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7"

with Image.open(image_path) as img:
    # 1. Toilet icon in header (transparent bg)
    # Green background is roughly RGB (78, 141, 58) or `#4E8D3A`
    # Let's crop X: 375 to 455, Y: 18 to 82
    toilet = img.crop((375, 18, 455, 82))
    # Make background transparent
    rgba_toilet = toilet.convert("RGBA")
    data = rgba_toilet.getdata()
    new_data = []
    for item in data:
        # If the pixel is green (high G, low R and B)
        # or if it's close to the header green color:
        r, g, b, a = item
        # A simple color distance to green #4E8D3A
        dist_green = abs(r - 78) + abs(g - 141) + abs(b - 58)
        if dist_green < 80 or (g > r + 20 and g > b + 20):
            new_data.append((255, 255, 255, 0)) # transparent
        else:
            new_data.append(item)
    rgba_toilet.putdata(new_data)
    rgba_toilet.save(os.path.join(brain_dir, "test_toilet.png"), "PNG")
    
    # 2. Row 1: Tissue box + Wipes
    # X: 20 to 240, Y: 155 to 275
    row1 = img.crop((20, 155, 240, 275))
    row1.save(os.path.join(brain_dir, "test_row1.png"), "PNG")
    
    # 3. Row 2: Sanitizer bottle
    # X: 45 to 175, Y: 285 to 409
    row2 = img.crop((45, 285, 175, 409))
    row2.save(os.path.join(brain_dir, "test_row2.png"), "PNG")
    
    # 4. Row 3: Clock
    # X: 40 to 150, Y: 420 to 528
    row3 = img.crop((40, 420, 150, 528))
    row3.save(os.path.join(brain_dir, "test_row3.png"), "PNG")
    
    # 5. Restroom scene
    # X: 0 to 468, Y: 535 to 685 (from the separator line down)
    scene = img.crop((0, 535, 468, 685))
    scene.save(os.path.join(brain_dir, "test_scene.png"), "PNG")

print("Test crops saved successfully!")
