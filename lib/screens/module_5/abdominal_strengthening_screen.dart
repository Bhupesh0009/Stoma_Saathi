import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleFiveAbdominalStrengtheningScreen extends StatelessWidget {
  const ModuleFiveAbdominalStrengtheningScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentBlue = Color(0xFF1E88E5);
  static const _pageBackground = Color(0xFFF7FBFA);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: _pageBackground,
      appBar: AppBar(
        backgroundColor: _pageBackground,
        surfaceTintColor: _pageBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
              visible: true,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2EBE8), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F2C3E).withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header: Badge & Title / Subtitle
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _accentBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isEnglish
                                  ? 'Abdominal Strengthening Exercises'
                                  : 'पेट मजबूत करने वाले व्यायाम',
                              style: const TextStyle(
                                color: _accentBlue,
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              isEnglish
                                  ? 'Start only when advised by your doctor'
                                  : 'अपने डॉक्टर की सलाह पर ही शुरू करें',
                              style: const TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Side-by-Side Exercise Cards (Responsive)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 650;

                      final card1 = _buildExerciseCard(
                        number: '1',
                        title: isEnglish ? 'Deep breathing' : 'गहरी सांस लेना',
                        imagePath: 'assets/images/module5_breathing.png',
                        content: isEnglish
                            ? 'Inhale slowly\n→ hold\n→ exhale'
                            : 'धीरे-धीरे सांस लें\n→ रोकें\n→ सांस छोड़ें',
                        isBreathing: true,
                      );

                      final card2 = _buildExerciseCard(
                        number: '2',
                        title: isEnglish ? 'Abdominal tightening' : 'पेट कसना',
                        imagePath: 'assets/images/module5_tightening.png',
                        content: isEnglish
                            ? 'Gently tighten\nstomach muscles\nfor few seconds'
                            : 'कुछ सेकंड के लिए\nपेट की मांसपेशियों\nको धीरे से कसें',
                        isBreathing: false,
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: card1),
                            const SizedBox(width: 16),
                            Expanded(child: card2),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            card1,
                            const SizedBox(height: 18),
                            card2,
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Bottom Info Strips (Responsive)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 650;

                      final strip1 = _buildInfoStrip(
                        icon: const Icon(Icons.info_outline_rounded, color: _accentBlue, size: 24),
                        text: isEnglish
                            ? 'Do 5–10 repetitions, 2–3 times daily'
                            : '5-10 बार दोहराएं, दिन में 2-3 बार',
                        borderColor: const Color(0xFFBBDEFB),
                        backgroundColor: const Color(0xFFF1F8E9).withValues(alpha: 0.1), // light tint
                      );

                      final strip2 = _buildInfoStrip(
                        icon: const Icon(Icons.warning_amber_rounded, color: Color(0xFFE5A100), size: 24),
                        text: isEnglish
                            ? 'Stop if pain occurs'
                            : 'दर्द होने पर तुरंत रोक दें',
                        borderColor: const Color(0xFFFFF59D),
                        backgroundColor: const Color(0xFFFFFDE7),
                      );

                      if (isWide) {
                        return Row(
                          children: [
                            Expanded(child: strip1),
                            const SizedBox(width: 16),
                            Expanded(child: strip2),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            strip1,
                            const SizedBox(height: 12),
                            strip2,
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseCard({
    required String number,
    required String title,
    required String imagePath,
    required String content,
    required bool isBreathing,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEFF1), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row: Numbered circle and Heading
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _accentBlue, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: const TextStyle(
                    color: _accentBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: _accentBlue,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Side-by-side Layout of Card content (Image vs Text)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Exercise Image
              Expanded(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: isBreathing ? 1.1 : 1.7,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Exercise Text
              Expanded(
                flex: 3,
                child: Text(
                  content,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoStrip({
    required Widget icon,
    required String text,
    required Color borderColor,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
