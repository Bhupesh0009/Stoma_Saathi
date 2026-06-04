import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleFiveActivityTimelineScreen extends StatelessWidget {
  const ModuleFiveActivityTimelineScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentTeal = Color(0xFF00796B);
  static const _calendarGreen = Color(0xFF2E7D32);
  static const _calendarBlue = Color(0xFF1976D2);
  static const _warningText = Color(0xFF7F5F00);
  static const _warningBackground = Color(0xFFFFFDE7);
  static const _warningBorder = Color(0xFFFFF59D);
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
                    color: const Color(0xFF0F3E3B).withValues(alpha: 0.05),
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
                          color: _accentTeal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '5',
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
                        child: Text(
                          isEnglish ? 'Activity Progression Timeline' : 'गतिविधि बढ़ाने की समयरेखा',
                          style: const TextStyle(
                            color: _accentTeal,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // First Card (After 2 Weeks)
                  _buildTimelineCard(
                    context: context,
                    calendarColor: _calendarGreen,
                    title: isEnglish ? 'After 2 Weeks:' : '2 सप्ताह के बाद:',
                    bullets: [
                      isEnglish ? 'Light household activities' : 'हल्की घरेलू गतिविधियां',
                      isEnglish ? 'Walking independently' : 'स्वतंत्र रूप से चलना',
                      isEnglish ? 'Simple daily tasks' : 'सरल दैनिक कार्य',
                    ],
                    imageAsset: 'assets/images/module5_activity_2weeks.png',
                    isEnglish: isEnglish,
                  ),
                  const SizedBox(height: 20),

                  // Second Card (After 6 Weeks)
                  _buildTimelineCard(
                    context: context,
                    calendarColor: _calendarBlue,
                    title: isEnglish ? 'After 6 Weeks:' : '6 सप्ताह के बाद:',
                    bullets: [
                      isEnglish ? 'Gradual return to normal routine' : 'धीरे-धीरे सामान्य दिनचर्या पर लौटना',
                      isEnglish ? 'Moderate physical activity (as advised)' : 'मध्यम शारीरिक गतिविधि (सलाह के अनुसार)',
                    ],
                    imageAsset: 'assets/images/module5_activity_6weeks.png',
                    isEnglish: isEnglish,
                  ),
                  const SizedBox(height: 24),

                  // Bottom Warning Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _warningBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _warningBorder, width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFFBC02D),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isEnglish
                                ? 'Avoid heavy exercise unless approved by doctor'
                                : 'डॉक्टर की अनुमति के बिना भारी व्यायाम से बचें',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: _warningText,
                            ),
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

  Widget _buildTimelineCard({
    required BuildContext context,
    required Color calendarColor,
    required String title,
    required List<String> bullets,
    required String imageAsset,
    required bool isEnglish,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEFF1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 520;

          final leftContent = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and Heading Row
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    color: calendarColor,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: calendarColor,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Bullet Points
              ...bullets.map((bullet) => _buildBulletRow(bullet)),
            ],
          );

          final rightContent = Container(
            constraints: const BoxConstraints(maxHeight: 150),
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
            ),
          );

          if (isWide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: leftContent),
                const SizedBox(width: 16),
                Expanded(flex: 4, child: rightContent),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                leftContent,
                const SizedBox(height: 16),
                Center(child: rightContent),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildBulletRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0, right: 10.0),
            child: Icon(
              Icons.fiber_manual_record,
              size: 7,
              color: Color(0xFF1E293B),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
