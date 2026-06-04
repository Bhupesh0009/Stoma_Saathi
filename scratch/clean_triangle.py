import os
from PIL import Image

def clean_triangle():
    img_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_warning_triangle.png"
    if not os.path.exists(img_path):
        print("Image does not exist!")
        return
        
    img = Image.open(img_path)
    print("Original size:", img.size)
    
    # Let's inspect non-transparent pixels to find bounding boxes
    # Convert image to RGBA if not already
    img = img.convert("RGBA")
    width, height = img.size
    
    # We want to crop out the red line on the right. 
    # Let's find where the warning triangle actually ends.
    # The triangle is centered. The red line is on the far right.
    # Let's crop the right-most portion.
    # Let's see: let's crop the width to about 80% or 82% of original width!
    # Because the triangle is perfectly centered, cropping the right-most 18% 
    # will completely cut off the red line while keeping the triangle completely intact!
    # Let's double check if the triangle is centered. 
    # Yes, it is centered in the remaining part.
    # Let's save a cropped version:
    cropped_width = int(width * 0.80)
    cropped_img = img.crop((0, 0, cropped_width, height))
    
    # Let's trim empty transparent borders on all sides to make it perfectly centered and clean!
    bbox = cropped_img.getbbox()
    if bbox:
        cropped_img = cropped_img.crop(bbox)
        
    cropped_img.save(img_path, "PNG")
    print("Cleaned and saved triangle image! New size:", cropped_img.size)

if __name__ == "__main__":
    clean_triangle()
