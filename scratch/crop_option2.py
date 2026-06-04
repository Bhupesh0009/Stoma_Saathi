import os
from PIL import Image

def crop_m7_illustrations():
    image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780394346447.png"
    assets_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"
    
    if not os.path.exists(image_path):
        print("Image does not exist!")
        return
        
    img = Image.open(image_path).convert("RGBA")
    width, height = img.size
    
    # Define our three illustration regions on the left side (X < 220)
    regions = [
        # (Y_start, Y_end, X_start, X_end)
        (100, 318, 0, 220, "module7_output_no_output.png"),
        (318, 497, 0, 220, "module7_output_decrease.png"),
        (497, 653, 0, 220, "module7_output_watery.png")
    ]
    
    for y_start, y_end, x_start, x_end, filename in regions:
        # Crop the region
        cropped = img.crop((x_start, y_start, x_end, y_end))
        
        # Convert white pixels to transparent to make them look absolutely premium on any background!
        data = cropped.getdata()
        new_data = []
        for item in data:
            r, g, b, a = item
            if r > 250 and g > 250 and b > 250:
                new_data.append((255, 255, 255, 0)) # transparent
            else:
                new_data.append(item)
        cropped.putdata(new_data)
        
        # Trim empty transparent borders around the cropped illustration to make it perfectly tight
        bbox = cropped.getbbox()
        if bbox:
            cropped = cropped.crop(bbox)
            
        output_path = os.path.join(assets_dir, filename)
        cropped.save(output_path, "PNG")
        print(f"Successfully cropped and saved {filename} to assets! Final size: {cropped.size}")

if __name__ == "__main__":
    crop_m7_illustrations()
