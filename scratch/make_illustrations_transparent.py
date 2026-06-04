import os
from PIL import Image

output_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"

def make_transparent(filename, threshold=245):
    filepath = os.path.join(output_dir, filename)
    if not os.path.exists(filepath):
        print(f"{filename} does not exist")
        return
    
    img = Image.open(filepath).convert("RGBA")
    data = img.getdata()
    
    new_data = []
    for item in data:
        r, g, b, a = item
        # If the pixel is close to white, make it transparent
        if r >= threshold and g >= threshold and b >= threshold:
            new_data.append((255, 255, 255, 0))
        else:
            new_data.append(item)
            
    img.putdata(new_data)
    # Save as PNG
    img.save(filepath, "PNG")
    print(f"Processed transparency for {filename}")

make_transparent("about_leaves.png", threshold=248)
make_transparent("about_phone.png", threshold=248)
make_transparent("about_hands.png", threshold=248)
