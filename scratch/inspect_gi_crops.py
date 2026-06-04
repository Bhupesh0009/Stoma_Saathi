from PIL import Image

def inspect_edge(filename, side="right"):
    img = Image.open(filename)
    w, h = img.size
    print(f"Inspecting {filename} (size: {w}x{h}), checking {side} edge:")
    
    pixels = img.load()
    non_transparent = 0
    
    x_check = w - 1 if side == "right" else 0
    for y in range(h):
        r, g, b, a = pixels[x_check, y]
        if a > 0:
            non_transparent += 1
            if non_transparent < 10:
                print(f"  Pixel at y={y}: rgba=({r},{g},{b},{a})")
                
    print(f"Total non-transparent pixels on {side} edge: {non_transparent}")

inspect_edge(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_gi_nausea.png", "right")
inspect_edge(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module7_gi_bloating.png", "left")
