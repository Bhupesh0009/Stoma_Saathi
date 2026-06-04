with open(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\lib\main.dart", "r", encoding="utf-8") as f:
    content = f.read()

lines = content.splitlines()

start_idx = None
for i, line in enumerate(lines):
    if "class LessonScreen" in line:
        start_idx = i
        break

if start_idx is not None:
    print(f"Found LessonScreen at line {start_idx + 1}")
    for j in range(start_idx, min(start_idx + 180, len(lines))):
        ascii_line = lines[j].encode("ascii", "replace").decode("ascii")
        print(f"{j+1}: {ascii_line}")
else:
    print("LessonScreen not found")
