with open(r"c:\Users\Bhupesh\Desktop\Stoma Saathi\lib\main.dart", "r", encoding="utf-8") as f:
    content = f.read()

import re
matches = [m.start() for m in re.finditer("Car Seat Belt Adjustment", content)]
if matches:
    m = matches[0]
    snippet = content[m - 100: m + 1000]
    # Encode as ascii with escape characters to view the characters safely
    print(snippet.encode("ascii", "backslashreplace").decode("ascii"))
