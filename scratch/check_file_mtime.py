import os
import time

c_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\assets\images\module6_seatbelt_cushion.png"
stat = os.stat(c_path)
print("File size on disk:", stat.st_size)
print("Last modified time:", time.ctime(stat.st_mtime))
