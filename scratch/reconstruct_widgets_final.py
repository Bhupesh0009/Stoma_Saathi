import os

widgets_path = r"c:\Users\Bhupesh\Desktop\Stoma Saathi\lib\widgets\widgets.dart"

# 1. Read current corrupted widgets.dart to get the rest of the file
with open(widgets_path, "r", encoding="utf-8") as f:
    content = f.read()

lines = content.split("\n")
# Find the exact line index where class ModuleScreen starts
ms_index = -1
for idx, l in enumerate(lines):
    if "class ModuleScreen extends StatelessWidget" in l:
        ms_index = idx
        break

if ms_index == -1:
    print("Could not find class ModuleScreen in corrupted file!")
    exit(1)

# The rest of the file starts from // Module Screen Widget which is usually right before class ModuleScreen
# Let's see if the line before it is // Module Screen Widget
start_idx = ms_index
if start_idx > 0 and "// Module Screen" in lines[start_idx - 1]:
    start_idx -= 1

rest_of_file = "\n".join(lines[start_idx:])

# 2. Write the perfect reconstructed content
reconstructed = """import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../models/modules_data.dart';
import '../utils/theme_utils.dart';
import '../screens/module_1/module_one_screen.dart';
import '../screens/module_2/module_two_screen.dart';
import '../screens/module_5/index.dart';
import '../screens/module_6/index.dart';

// Language Chip Widget
class LanguageChip extends StatelessWidget {
  const LanguageChip({
    required this.language,
    required this.onLanguageChanged,
    this.dark = false,
    this.visible = false,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final bool dark;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<AppLanguage>(
      onSelected: onLanguageChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(value: AppLanguage.english, child: Text('English')),
        PopupMenuItem(value: AppLanguage.hindi, child: Text('हिंदी')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: dark ? Colors.white.withValues(alpha: 0.14) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: 0.4)
                : const Color(0xFFD6E3F5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, size: 18, color: dark ? Colors.white : null),
            const SizedBox(width: 6),
            Text(
              language == AppLanguage.english ? 'English' : 'हिंदी',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: dark ? Colors.white : const Color(0xFF173C8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleSevenBanner extends StatelessWidget {
  const ModuleSevenBanner({
    super.key,
    required this.module,
    required this.language,
    required this.onTap,
  });

  final ModuleData module;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translated texts
    final badgeText = isEnglish ? 'Module 7' : 'मॉड्यूल 7';
    final titleText = isEnglish ? 'WARNING SIGNS' : 'चेतावनी के संकेत';
    final subtitleText = isEnglish ? '(When to Seek Help)' : '(कब सहायता लेनी चाहिए)';
    final descText = isEnglish
        ? 'It is important to recognize early warning signs\\nto prevent serious complications.'
        : 'गंभीर समस्याओं से बचने के लिए शुरुआती चेतावनी\\nसंकेतों को पहचानना महत्वपूर्ण है।';
    final highlightText = isEnglish
        ? 'If you notice these signs, do not ignore—\\ntake action immediately.'
        : 'यदि आप इन संकेतों को देखते हैं, तो अनदेखा न करें—\\nतुरंत कार्रवाई करें।';
    final cardTitle = isEnglish ? 'Why it’s Important?' : 'यह क्यों महत्वपूर्ण है?';
    final point1Text = isEnglish
        ? 'Early action can prevent\\nserious complications.'
        : 'शुरुआती कार्रवाई गंभीर\\nजटिलताओं को रोक सकती है।';
    final point2Text = isEnglish
        ? 'Your health and safety\\nare our priority.'
        : 'आपका स्वास्थ्य और सुरक्षा\\nहमारी प्राथमिकता है।';

    return Card(
      elevation: 4,
      shadowColor: const Color(0x120F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          child: AspectRatio(
            aspectRatio: 975 / 253, // Match reference aspect ratio exactly
            child: LayoutBuilder(
              builder: (context, constraints) {
                return FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 975,
                    height: 253,
                    child: Stack(
                      children: [
                        // Left Illustration (Worried Patient)
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: 180,
                            height: 253,
                            child: Image.asset(
                              'assets/images/module7_patient.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                        
                        // Top Left Badge
                        Positioned(
                          left: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                        // Middle Content
                        Positioned(
                          left: 175,
                          top: 12,
                          right: 250,
                          bottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Row with Warning Icon and Title/Subtitle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 112,
                                    height: 88,
                                    child: Image.asset(
                                      'assets/images/module7_warning_triangle.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        titleText,
                                        style: const TextStyle(
                                          color: Color(0xFFD60000),
                                          fontSize: 34,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Text(
                                        subtitleText,
                                        style: const TextStyle(
                                          color: Color(0xFF1E3A8A),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              // Description
                              Text(
                                descText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF1F2937),
                                  fontSize: 13,
                                  fontWeight: TextAlign.w700,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Highlight Box
                              Container(
                                width: 440,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFDF0),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFFE082), width: 1.2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '“ ',
                                      style: TextStyle(
                                        color: Color(0xFFE65100),
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        highlightText,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ' ”',
                                      style: TextStyle(
                                        color: Color(0xFFE65100),
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Nurse Illustration
                        Positioned(
                          right: 225,
                          bottom: 0,
                          child: SizedBox(
                            width: 156,
                            height: 225,
                            child: Image.asset(
                              'assets/images/module7_nurse.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                        ),

                        // Right Information Card
                        Positioned(
                          right: 12,
                          top: 12,
                          bottom: 12,
                          child: Container(
                            width: 236,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x060F172A),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cardTitle,
                                  style: const TextStyle(
                                    color: Color(0xFFD60000),
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(color: Color(0xFFF1F5F9), height: 1),
                                const SizedBox(height: 10),
                                
                                // Point 1
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 41,
                                      height: 44,
                                      child: Image.asset(
                                        'assets/images/module7_shield.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        point1Text,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                
                                // Point 2
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Image.asset(
                                        'assets/images/module7_heart_hand.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        point2Text,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Module Card Widget
class ModuleCard extends StatelessWidget {
  const ModuleCard({
    super.key,
    required this.module,
    required this.language,
    required this.onTap,
  });

  final ModuleData module;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFEAF0F8)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x120F172A),
                blurRadius: 18,
                offset: Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Column(
            children: [
              Expanded(child: _ModuleArtwork(module: module)),
              const SizedBox(height: 12),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: module.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: module.color.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${module.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                module.title.value(language),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Module Artwork Widget
class _ModuleArtwork extends StatelessWidget {
  const _ModuleArtwork({required this.module});

  final ModuleData module;

  @override
  Widget build(BuildContext context) {
    final isFirst = module.number == 1;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            module.color.withValues(alpha: 0.18),
            module.color.withValues(alpha: 0.05),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: EdgeInsets.all(isFirst ? 14 : 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                module.homeIconAsset,
                fit: isFirst ? BoxFit.contain : BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
""" + "\n\n" + rest_of_file

with open(widgets_path, "w", encoding="utf-8") as f:
    f.write(reconstructed)

print("Widgets.dart perfectly reconstructed and verified!")
