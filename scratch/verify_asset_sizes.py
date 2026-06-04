from PIL import Image

p_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_passenger.png"
c_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png"

try:
    p_img = Image.open(p_path)
    print("Passenger image size on disk:", p_img.size)
except Exception as e:
    print("Passenger open error:", e)

try:
    c_img = Image.open(c_path)
    print("Cushion image size on disk:", c_img.size)
except Exception as e:
    print("Cushion open error:", e)
