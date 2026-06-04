import json
import os

transcript_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\.system_generated\logs\transcript.jsonl"

if os.path.exists(transcript_path):
    with open(transcript_path, "r", encoding="utf-8") as f:
        for line in f:
            try:
                data = json.loads(line)
                if "content" in data and "File Path: `file:///c:/Users/Bhupesh/Desktop/Stoma%20Saathi/lib/widgets/widgets.dart`" in data["content"]:
                    content = data["content"]
                    lines = content.split("\n")
                    print(f"Total lines in transcript view: {len(lines)}")
                    for idx, l in enumerate(lines[:100]):
                        print(f"{idx}: {l}")
                    break
            except Exception as e:
                pass
