from PIL import Image, ImageDraw

img = Image.open(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780244406098.png")
draw = ImageDraw.Draw(img)

# Proposed Cushion Circle box: X 236 to 368, Y 350 to 468
draw.rectangle([236, 350, 368, 468], outline="green", width=2)
draw.rectangle([310, 20, 390, 70], outline="red", width=2)

img.save(r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\mockup_crop_debug_cushion.png")
print("Saved mockup_crop_debug_cushion.png")
