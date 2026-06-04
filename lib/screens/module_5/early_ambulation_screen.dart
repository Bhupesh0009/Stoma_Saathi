import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleFiveEarlyAmbulationScreen extends StatelessWidget {
  const ModuleFiveEarlyAmbulationScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _darkGreen = Color(0xFF0A5C2D);
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
                    color: const Color(0xFF0F3E2B).withValues(alpha: 0.05),
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
                          color: _darkGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '1',
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
                          isEnglish
                              ? 'Early Ambulation (Walking Guidelines)'
                              : 'जल्दी चलना (चलने के निर्देश)',
                          style: const TextStyle(
                            color: _darkGreen,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Middle Section: Responsive layout for wide vs narrow screens
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 650;

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Section: Walking illustration
                            SizedBox(
                              width: 170,
                              child: _buildIllustration(),
                            ),
                            const SizedBox(width: 20),
                            // Center Section: Instructions
                            Expanded(
                              flex: 5,
                              child: _buildInstructions(isEnglish),
                            ),
                            const SizedBox(width: 20),
                            // Right Section: Benefits card
                            Expanded(
                              flex: 6,
                              child: _buildBenefits(isEnglish),
                            ),
                          ],
                        );
                      } else {
                        // Mobile Layout
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Illustration Centered
                            Center(
                              child: SizedBox(
                                width: 200,
                                child: _buildIllustration(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Instructions
                            _buildInstructions(isEnglish),
                            const SizedBox(height: 24),
                            // Benefits Card
                            _buildBenefits(isEnglish),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Bottom Section: Warning Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFDF0),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFF2A8), width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Color(0xFFE5A100),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isEnglish
                                ? 'Walk slowly and take support if needed'
                                : 'धीरे चलें और आवश्यकता होने पर सहारा लें',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
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

  Widget _buildIllustration() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFECEFF1), width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          'assets/images/module5_walking.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInstructions(bool isEnglish) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? 'Instructions:' : 'निर्देश:',
          style: const TextStyle(
            color: _darkGreen,
            fontSize: 16.5,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),
        _buildBulletPoint(
          isEnglish
              ? 'Start walking within\n24–48 hours (as advised)'
              : 'सलाह मिलने पर 24–48 घंटे के भीतर चलना शुरू करें',
        ),
        _buildBulletPoint(
          isEnglish ? 'Begin with short distances' : 'कम दूरी से शुरुआत करें',
        ),
        _buildBulletPoint(
          isEnglish
              ? 'Gradually increase\nduration daily'
              : 'रोजाना धीरे-धीरे चलने का समय बढ़ाएं',
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
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

  Widget _buildBenefits(bool isEnglish) {
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
          Text(
            isEnglish ? 'Benefits:' : 'लाभ:',
            style: const TextStyle(
              color: _darkGreen,
              fontSize: 16.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 16),
          _buildBenefitItem(
            const Icon(Icons.water_drop_rounded, color: Color(0xFFD32F2F), size: 24),
            isEnglish ? 'Improves blood circulation' : 'रक्त प्रवाह में सुधार करता है',
          ),
          const SizedBox(height: 14),
          _buildBenefitItem(
            const Icon(Icons.verified_user_rounded, color: Color(0xFF2E7D32), size: 24),
            isEnglish
                ? 'Prevents complications\n(clots, constipation)'
                : 'जटिलताओं (खून के थक्के, कब्ज)\nसे बचाता है',
          ),
          const SizedBox(height: 14),
          _buildBenefitItem(
            const Icon(Icons.directions_run_rounded, color: Color(0xFF00897B), size: 24),
            isEnglish ? 'Speeds recovery' : 'रिकवरी को तेज करता है',
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(Widget icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
