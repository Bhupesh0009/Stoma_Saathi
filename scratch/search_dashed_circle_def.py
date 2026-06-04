import json

transcript_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\f1cf9703-6f7b-478e-8094-4bedb94062a7\.system_generated\logs\transcript.jsonl"
out_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\scratch\recovered_dashed_circle_def.txt"

with open(transcript_path, "r", encoding="utf-8") as f, open(out_path, "w", encoding="utf-8") as out:
    for line in f:
        item = json.loads(line)
        content = item.get("content", "")
        if "class _DashedCirclePainter" in content:
            out.write(f"--- Step {item.get('step_index')} ({item.get('type')}) ---\n")
            lines = content.splitlines()
            for idx, l in enumerate(lines):
                if "class _DashedCirclePainter" in l:
                    start = max(0, idx - 2)
                    end = min(len(lines), idx + 25)
                    for k in range(start, end):
                        out.write(f"{k}: {lines[k]}\n")
                    out.write("-" * 40 + "\n")
print("Done writing recovered dashed circle def.")
