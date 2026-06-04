import os

print("Searching for images in workspace...")
for root, dirs, files in os.walk(r"c:\Users\Bhupesh\Desktop\Stoma Saathi"):
    # skip .git, build, android, ios, macos, windows, linux, web, .dart_tool, .vscode, .idea
    dirs[:] = [d for d in dirs if d not in ['.git', 'build', 'android', 'ios', 'macos', 'windows', 'linux', 'web', '.dart_tool', '.vscode', '.idea']]
    for f in files:
        if f.lower().endswith(('.png', '.jpg', '.jpeg')):
            path = os.path.join(root, f)
            print(f"Workspace: {path} - {os.path.getsize(path)} bytes")

print("\nSearching for images in app data dir...")
for root, dirs, files in os.walk(r"C:\Users\Bhupesh\.gemini\antigravity-ide"):
    for f in files:
        if f.lower().endswith(('.png', '.jpg', '.jpeg')):
            path = os.path.join(root, f)
            print(f"App Data: {path} - {os.path.getsize(path)} bytes")
