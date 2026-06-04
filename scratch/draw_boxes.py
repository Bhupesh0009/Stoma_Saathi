from PIL import Image, ImageDraw

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
draw = ImageDraw.Draw(img)

# Let's draw bounding boxes for:
# 1. Car Icon (X: 310 to 390, Y: 20 to 70) - let's check
draw.rectangle([310, 20, 390, 70], outline="red", width=2)

# 2. Passenger Illustration (X: 0 to 260, Y: 83 to 469)
draw.rectangle([0, 83, 260, 469], outline="blue", width=2)

# 3. Cushion Illustration (X: 236, Y: 368 to X: 367, Y: 468) - let's check
draw.rectangle([236, 368, 367, 468], outline="green", width=2)

img.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\mockup_crop_debug.png")
print("Saved mockup_crop_debug.png")
