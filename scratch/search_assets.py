import os

dir_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images"
keywords = ["yoga", "cycle", "stretch", "swim", "sport", "tennis", "racket", "football", "soccer", "lifting", "situp", "plank", "boxing", "box", "pain", "dizzy", "leak", "character", "active", "remember"]

files = os.listdir(dir_path)
found = {}
for f in files:
    f_lower = f.lower()
    for kw in keywords:
        if kw in f_lower:
            if kw not in found:
                found[kw] = []
            found[kw].append(f)

for kw, fs in found.items():
    print(f"Keyword '{kw}': {fs}")
