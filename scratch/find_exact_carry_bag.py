from PIL import Image

def get_bbox(img, y_start, y_end, threshold=245):
    # Find bounding box for non-white pixels in the vertical range [y_start, y_end]
    w, h = img.size
    pix = img.load()
    
    left = w
    right = 0
    top = y_end
    bottom = y_start
    
    for y in range(y_start, y_end):
        for x in range(w):
            r, g, b = pix[x, y][:3]
            # If the pixel is not white (below threshold)
            if r < threshold or g < threshold or b < threshold:
                if x < left: left = x
                if x > right: right = x
                if y < top: top = y
                if y > bottom: bottom = y
                
    return (max(0, left - 5), max(y_start, top - 5), min(w, right + 5), min(y_end, bottom + 5))

def main():
    ref_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_ref.png"
    img = Image.open(ref_path)
    
    # 1. Main cosmetic pouch / travel bag
    # Located in y-range [105, 340]
    bag_box = get_bbox(img, 105, 340)
    print(f"Calculated Bag Bounding Box: {bag_box}")
    img.crop(bag_box).save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_bag.png")
    
    # 2. Extra Pouch (small stoma pouch below the bag)
    # Located in y-range [335, 430], x-range [250, 380]
    pouch_box = get_bbox(img, 335, 430)
    # Filter by x bounds to avoid wipes or text
    # Wipes is further left, disposal bag is further right. Let's look at the exact x range of the small pouch
    # The small pouch is at x range [270, 360].
    # Let's crop it by vertical range first, then filter x
    p_box = (270, 335, 360, 428)
    print(f"Pouch Box: {p_box}")
    img.crop(p_box).save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_extra_pouch.png")
    
    # 3. Wipes packet below the bag
    # Located in y-range [410, 500], x-range [210, 345]
    w_box = (215, 410, 340, 492)
    print(f"Wipes Box: {w_box}")
    img.crop(w_box).save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_wipes.png")
    
    # 4. Disposal bag (green bag)
    # Located in y-range [410, 550], x-range [315, 430]
    d_box = (325, 410, 425, 545)
    print(f"Disposal Box: {d_box}")
    img.crop(d_box).save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_disposal.png")
    
    # 5. Lock Icon
    # Located in privacy card at bottom, y: [555, 650]
    # We want only the lock icon itself
    l_box = (50, 562, 105, 638)
    print(f"Lock Box: {l_box}")
    img.crop(l_box).save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_lock.png")
    
    # 6. Heart Icon
    # Located in privacy card at bottom right
    h_box = (454, 575, 506, 626)
    print(f"Heart Box: {h_box}")
    img.crop(h_box).save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_carry_heart.png")

if __name__ == "__main__":
    main()
