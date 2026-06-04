import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleFiveStopExerciseScreen extends StatelessWidget {
  const ModuleFiveStopExerciseScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentRed = Color(0xFFD32F2F);
  static const _circleBorderRed = Color(0xFFFFCDD2);
  static const _contactBackground = Color(0xFFFFEBEE);
  static const _contactBorder = Color(0xFFFFCDD2);
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
                    color: const Color(0xFF3E0F0F).withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Row: Badge & Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _accentRed,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          isEnglish ? 'When to Stop Exercise & Contact Nurse' : 'व्यायाम कब रोकें और नर्स से संपर्क करें',
                          style: const TextStyle(
                            color: _accentRed,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Symptoms Grid / Row
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 600;

                      final item1 = _buildSymptomItem(
                        imageAsset: 'assets/images/module5_stop_pain.png',
                        label: isEnglish ? 'Severe pain' : 'तेज दर्द',
                      );

                      final item2 = _buildSymptomItem(
                        imageAsset: 'assets/images/module5_stop_dizziness.png',
                        label: isEnglish ? 'Dizziness' : 'चक्कर आना',
                      );

                      final item3 = _buildSymptomItem(
                        imageAsset: 'assets/images/module5_stop_breathless.png',
                        label: isEnglish ? 'Breathlessness' : 'सांस फूलना',
                      );

                      final item4 = _buildSymptomItem(
                        imageAsset: 'assets/images/module5_stop_swelling.png',
                        label: isEnglish ? 'Swelling near stoma' : 'स्टोमा के पास सूजन',
                      );

                      if (isWide) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: item1),
                            const SizedBox(width: 8),
                            Expanded(child: item2),
                            const SizedBox(width: 8),
                            Expanded(child: item3),
                            const SizedBox(width: 8),
                            Expanded(child: item4),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: item1),
                                const SizedBox(width: 12),
                                Expanded(child: item2),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(child: item3),
                                const SizedBox(width: 12),
                                Expanded(child: item4),
                              ],
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 32),

                  // Bottom Contact Alert Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: BoxDecoration(
                      color: _contactBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _contactBorder, width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.phone_in_talk_rounded,
                          color: _accentRed,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isEnglish ? 'Contact your nurse immediately' : 'तुरंत अपनी नर्स से संपर्क करें',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: _accentRed,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomItem({
    required String imageAsset,
    required String label,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular Image Frame with Red Border
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _circleBorderRed, width: 2),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        // Centered Bold Label Text
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
            height: 1.25,
          ),
        ),
      ],
    );
  }
}
