import os

log_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\.system_generated\tasks\task-1315.log"

if os.path.exists(log_path):
    with open(log_path, "r", encoding="utf-8", errors="ignore") as f:
        lines = f.readlines()
    print("Last 30 lines of flutter run log:")
    for line in lines[-30:]:
        print(line.strip())
else:
    print("Log file does not exist yet!")
