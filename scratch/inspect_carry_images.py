import os
from PIL import Image

def main():
    ref_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_ref.png"
    img = Image.open(ref_path)
    w, h = img.size
    print(f"Reference Image Size: {w}x{h}")
    
    # We will crop several sub-assets based on safe coordinate bounds:
    # 1. Main cosmetic pouch / travel bag
    # Let's crop the travel bag from x=100 to 510, y=110 to 335
    # Let's verify by checking the non-white pixels in these regions.
    
    # Let's define the crop bounding boxes:
    # Main bag:
    # x goes from 100 to 515 (approx)
    # y goes from 115 to 335
    bag_box = (100, 115, 515, 335)
    
    # Extra Pouch (small stoma pouch below the bag)
    # Let's search the region x: 260 to 360, y: 340 to 425
    pouch_box = (275, 340, 355, 425)
    
    # Wipes packet below the bag
    # Let's search the region x: 200 to 340, y: 410 to 490
    wipes_box = (215, 415, 340, 490)
    
    # Disposal bag (green bag)
    # Let's search the region x: 310 to 440, y: 410 to 540
    disposal_box = (325, 415, 425, 540)
    
    # Bottom lock icon (inside privacy card)
    # Privacy card is at the very bottom, y: 555 to 650
    # Lock is on the left, x: 45 to 115, y: 565 to 640
    lock_box = (50, 565, 110, 640)
    
    # Bottom outline heart icon
    # Heart is on the right, x: 440 to 520, y: 575 to 630
    heart_box = (450, 575, 510, 630)
    
    crops = {
        "module6_carry_bag.png": bag_box,
        "module6_carry_extra_pouch.png": pouch_box,
        "module6_carry_wipes.png": wipes_box,
        "module6_carry_disposal.png": disposal_box,
        "module6_carry_lock.png": lock_box,
        "module6_carry_heart.png": heart_box
    }
    
    out_dir = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"
    for name, box in crops.items():
        cropped = img.crop(box)
        # Let's trim background borders
        cropped.save(os.path.join(out_dir, name))
        print(f"Saved {name} with box {box}")

if __name__ == "__main__":
    main()
