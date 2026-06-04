import re

file_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\lib\main.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

lines = content.splitlines()

# Search for the class _ModuleSixScreen definition
start_idx = None
for i, line in enumerate(lines):
    if "class _ModuleSixScreen" in line:
        start_idx = i
        break

if start_idx is not None:
    print(f"Found _ModuleSixScreen at line {start_idx + 1}")
    # Print the next 150 lines safely
    for j in range(start_idx, min(start_idx + 150, len(lines))):
        # replace non-ascii characters to avoid print errors
        ascii_line = lines[j].encode("ascii", "replace").decode("ascii")
        print(f"{j+1}: {ascii_line}")
else:
    print("_ModuleSixScreen not found")
