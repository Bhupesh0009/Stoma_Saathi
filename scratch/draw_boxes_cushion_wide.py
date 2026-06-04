from PIL import Image, ImageDraw

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
draw = ImageDraw.Draw(img)

# Wider Cushion Circle box: X 230 to 370, Y 345 to 468
draw.rectangle([230, 345, 370, 468], outline="green", width=2)
draw.rectangle([310, 20, 390, 70], outline="red", width=2)

img.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\mockup_crop_debug_cushion_wide.png")
print("Saved mockup_crop_debug_cushion_wide.png")
