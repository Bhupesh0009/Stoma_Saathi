from PIL import Image
import os

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")

# Crop Passenger Illustration (X: 0 to 235, Y: 83 to 468)
# This includes the entire passenger and seat, but cuts off before the checkmarks and the cushion circle start.
passenger = img.crop((0, 83, 235, 468))
passenger.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_passenger.png")
print("Saved clean passenger illustration.")

# Crop Cushion Illustration (X: 236 to 368, Y: 358 to 468)
# This includes the circle containing the cushion, without the text "if needed" above it or the jeans on the left.
cushion = img.crop((236, 358, 368, 468))
cushion.save(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png")
print("Saved clean cushion circle illustration.")
