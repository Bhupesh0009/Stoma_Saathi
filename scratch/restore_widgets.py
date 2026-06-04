import json
import os

transcript_path = r"C:\Users\Bhupesh\.gemini\antigravity-ide\brain\8af67e2d-3edc-42fc-ac17-372a48afc03b\.system_generated\logs\transcript.jsonl"
widgets_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\lib\widgets\widgets.dart"

original_lines = None

if os.path.exists(transcript_path):
    print("Reading transcript.jsonl...")
    with open(transcript_path, "r", encoding="utf-8") as f:
        for line in f:
            try:
                data = json.loads(line)
                # Look for the step that viewed widgets.dart
                if "tool_calls" in data:
                    for tc in data["tool_calls"]:
                        if tc.get("name") == "view_file" and "widgets.dart" in tc.get("args", {}).get("AbsolutePath", ""):
                            # Let's see if the output is in this step
                            # Or check the next response step
                            pass
                if "content" in data and "File Path: `file:///c:/Users/Bhupesh/Desktop/Stoma%20Saathi/lib/widgets/widgets.dart`" in data["content"]:
                    content = data["content"]
                    # Extract the lines
                    lines = content.split("\n")
                    # Filter out line numbers (e.g. "1: import...")
                    clean_lines = []
                    started = False
                    for l in lines:
                        if "Showing lines 1 to 800" in l:
                            started = True
                            continue
                        if started:
                            if "The above content does NOT show" in l or "The above content shows the entire" in l:
                                break
                            # Strip line number prefix like "12:   const LanguageChip({"
                            parts = l.split(":", 1)
                            if len(parts) == 2 and parts[0].strip().isdigit():
                                clean_lines.append(parts[1][1:]) # strip the space after the colon
                            else:
                                clean_lines.append(l)
                    original_lines = "\n".join(clean_lines)
                    print("Found original widgets.dart content in transcript!")
                    break
            except Exception as e:
                pass

if original_lines:
    # Read the current contents of widgets.dart from line 118 onwards
    with open(widgets_path, "r", encoding="utf-8") as f:
        curr_content = f.read()
    
    # We want to keep everything from line 118 (or starting with "class ModuleScreen") of the corrupted file,
    # or just reconstruct the top part of the original file and append the rest.
    # Actually, the original_lines contains the first 800 lines of widgets.dart!
    # So we can just take the first 110 lines of the original_lines, add our ModuleSevenBanner, and then append the rest of widgets.dart!
    # Let's find where "class ModuleScreen" is in widgets.dart currently.
    # In the corrupted file, "class ModuleScreen" is at line 118.
    curr_lines = curr_content.split("\n")
    # Let's find the index of "class ModuleScreen"
    ms_index = -1
    for idx, l in enumerate(curr_lines):
        if "class ModuleScreen extends StatelessWidget" in l:
            ms_index = idx
            break
            
    if ms_index != -1:
        rest_of_file = "\n".join(curr_lines[ms_index:])
        # Now get the first 112 lines of original_lines (before "class ModuleScreen")
        orig_split = original_lines.split("\n")
        orig_ms_idx = -1
        for idx, l in enumerate(orig_split):
            if "class ModuleScreen extends StatelessWidget" in l:
                orig_ms_idx = idx
                break
        if orig_ms_idx != -1:
            top_part = "\n".join(orig_split[:orig_ms_idx])
            
            # Reconstruct the file perfectly!
            new_content = top_part + "\n\n" + rest_of_file
            with open(widgets_path, "w", encoding="utf-8") as f:
                f.write(new_content)
            print("Successfully restored widgets.dart to perfect original state!")
        else:
            print("Could not find class ModuleScreen in original lines")
    else:
        print("Could not find class ModuleScreen in corrupted file")
else:
    print("Could not retrieve original content from transcript")
