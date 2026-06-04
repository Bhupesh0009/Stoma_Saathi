from PIL import Image, ImageDraw
import os

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
width, height = img.size

os.makedirs(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images", exist_ok=True)

# 1. Crop Car Icon
car_icon = img.crop((310, 20, 390, 70))
car_icon.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_header_car.png")
print("Saved car icon.")

# 2. Crop Cushion Circle
cushion = img.crop((230, 345, 370, 468))
cushion.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png")
print("Saved cushion.")

# 3. Crop Passenger and Erase Checkmarks
passenger = img.crop((0, 83, 270, 468))
# Create draw context on the passenger crop
draw = ImageDraw.Draw(passenger)
# Let's fill the checkmarks with white color (since the background is pure white)
# Relative to passenger crop (Y starts at 83, X starts at 0):
# First checkmark in original: X: 220 to 270, Y: 120 to 170 -> in crop: X: 220 to 270, Y: 37 to 87
draw.rectangle([220, 37, 270, 87], fill="white")
# Second checkmark in original: X: 220 to 270, Y: 260 to 310 -> in crop: X: 220 to 270, Y: 177 to 227
draw.rectangle([220, 177, 270, 227], fill="white")

passenger.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_passenger.png")
print("Saved passenger illustration after cleaning checkmarks.")
