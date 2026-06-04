with open(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\lib\main.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re
matches = [m.start() for m in re.finditer("Everyday Tips", content)]
if matches:
    m = matches[0]
    # We print a larger chunk (4000 characters) to cover all 10 lessons in the array
    snippet = content[m: m + 4000]
    ascii_snippet = snippet.encode("ascii", "replace").decode("ascii")
    print(ascii_snippet)
