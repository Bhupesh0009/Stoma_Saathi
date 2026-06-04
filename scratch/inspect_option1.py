from PIL import Image
import os

def inspect():
    image_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\media__1780387837839.png"
    if not os.path.exists(image_path):
        print("Image does not exist!")
        return
        
    img = Image.open(image_path)
    print("Dimensions of option 1 reference:", img.size)

if __name__ == "__main__":
    inspect()
