import os
from PIL import Image

image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780243482966.png"
brain_dir = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7"

def make_bg_transparent(img, threshold=245):
    rgba = img.convert("RGBA")
    data = rgba.getdata()
    new_data = []
    for item in data:
        r, g, b, a = item
        if r >= threshold and g >= threshold and b >= threshold - 5:
            new_data.append((255, 255, 255, 0)) # transparent
        else:
            new_data.append(item)
    rgba.putdata(new_data)
    return rgba

with Image.open(image_path) as img:
    # 1. Header Bus Icon (transparent bg)
    # Purple background is around RGB (110, 81, 155) or `#7A5AB5`
    bus = img.crop((370, 5, 458, 80))
    rgba_bus = bus.convert("RGBA")
    bus_data = rgba_bus.getdata()
    new_bus_data = []
    for item in bus_data:
        r, g, b, a = item
        # check distance from purple (110, 81, 155)
        dist_purple = abs(r - 110) + abs(g - 81) + abs(b - 155)
        if dist_purple < 80 or (r > g + 15 and b > g + 15):
            new_bus_data.append((255, 255, 255, 0))
        else:
            new_bus_data.append(item)
    rgba_bus.putdata(new_bus_data)
    rgba_bus.save(os.path.join(brain_dir, "test_bus.png"), "PNG")
    
    # 2. Row 1 Icon: Seat
    row1 = img.crop((15, 100, 110, 200))
    row1_trans = make_bg_transparent(row1)
    row1_trans.save(os.path.join(brain_dir, "test_seat.png"), "PNG")
    
    # 3. Row 2 Icon: Crowd
    row2 = img.crop((15, 210, 110, 310))
    row2_trans = make_bg_transparent(row2)
    row2_trans.save(os.path.join(brain_dir, "test_crowd.png"), "PNG")
    
    # 4. Row 3 Icon: Bag
    row3 = img.crop((15, 328, 110, 428))
    row3_trans = make_bg_transparent(row3)
    row3_trans.save(os.path.join(brain_dir, "test_bag.png"), "PNG")
    
    # 5. Right Column Passenger scene
    passenger = img.crop((276, 82, 458, 463))
    passenger.save(os.path.join(brain_dir, "test_passenger.png"), "PNG")

print("Transportation test crops saved successfully!")
