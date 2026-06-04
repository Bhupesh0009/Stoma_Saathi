import shutil
import os

src = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\media__1780240657025.png"
dst = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module2_stoma_appliance_bottom.png"

shutil.copy(src, dst)
print("Copied successfully!")
