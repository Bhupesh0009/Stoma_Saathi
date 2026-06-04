import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixReturnToWorkScreen extends StatelessWidget {
  const ModuleSixReturnToWorkScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  // Design tokens based on the return-to-work mockup
  static const _headerBlue = Color(0xFF4E73D9);
  static const _headerBlueDark = Color(0xFF3858B8);
  static const _cardBackground = Colors.white;
  static const _lightBlueBg = Color(0xFFEEF3FF);
  static const _labelBorderBlue = Color(0xFFD2E0FB);
  static const _darkBlueText = Color(0xFF2A438C);
  static const _checkmarkColor = Color(0xFF59B35D);
  static const _textColor = Color(0xFF2D3748);
  static const _pageBackground = Color(0xFFF4F7FE); // Soft light-blue background

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
              decoration: BoxDecoration(
                color: _cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE4EEF8), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: _headerBlue.withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section: Blue Gradient Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _headerBlue,
                          _headerBlueDark,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.work_history_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isEnglish ? '8. RETURN TO WORK' : '8. काम पर वापसी',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // SECTION 1: WHEN TO RESUME
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 480;

                            final resumeText = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section Label
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _lightBlueBg,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: _labelBorderBlue, width: 1.5),
                                  ),
                                  child: Text(
                                    isEnglish ? 'WHEN TO RESUME' : 'कब फिर से शुरू करें',
                                    style: const TextStyle(
                                      color: _darkBlueText,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Calendar Icon on Left
                                    Image.asset(
                                      'assets/images/module6_work_calendar.png',
                                      width: 62,
                                      height: 58,
                                      fit: BoxFit.contain,
                                    ),
                                    const SizedBox(width: 14),
                                    // Center Text
                                    Expanded(
                                      child: Text(
                                        isEnglish
                                            ? 'Usually after\n4–6 weeks\n(as advised)'
                                            : 'आमतौर पर\n4–6 सप्ताह के बाद\n(सलाह के अनुसार)',
                                        style: const TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w900,
                                          color: _textColor,
                                          height: 1.3,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );

                            final workerIllustration = Image.asset(
                              'assets/images/module6_work_person.png',
                              width: 140,
                              height: 115,
                              fit: BoxFit.contain,
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: resumeText),
                                  const SizedBox(width: 16),
                                  workerIllustration,
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: resumeText),
                                  const SizedBox(width: 8),
                                  workerIllustration,
                                ],
                              );
                            }
                          },
                        ),

                        // Divider Line
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Divider(
                            color: Color(0xFFE4EEF8),
                            height: 1.5,
                            thickness: 1.5,
                          ),
                        ),

                        // SECTION 2: PRECAUTIONS
                        // Section Label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: _lightBlueBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _labelBorderBlue, width: 1.5),
                            ),
                            child: Text(
                              isEnglish ? 'PRECAUTIONS' : 'सावधानियां',
                              style: const TextStyle(
                                color: _darkBlueText,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Precaution Row 1: Avoid heavy lifting
                        _buildPrecautionRow(
                          title: isEnglish ? 'Avoid heavy lifting' : 'भारी वजन उठाने से बचें',
                          illustrationPath: 'assets/images/module6_work_heavy_bag.png',
                          illustrationWidth: 62,
                          illustrationHeight: 56,
                        ),
                        const SizedBox(height: 16),

                        // Precaution Row 2: Take breaks if needed
                        _buildPrecautionRow(
                          title: isEnglish ? 'Take breaks if needed' : 'यदि आवश्यक हो तो ब्रेक लें',
                          illustrationPath: 'assets/images/module6_work_clock_water.png',
                          illustrationWidth: 70,
                          illustrationHeight: 42,
                        ),
                        const SizedBox(height: 16),

                        // Precaution Row 3: Maintain hygiene
                        _buildPrecautionRow(
                          title: isEnglish ? 'Maintain hygiene' : 'स्वच्छता बनाए रखें',
                          illustrationPath: 'assets/images/module6_work_handwashing.png',
                          illustrationWidth: 62,
                          illustrationHeight: 48,
                        ),
                        const SizedBox(height: 24),

                        // Bottom Reminder Banner
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: _lightBlueBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _labelBorderBlue, width: 1.5),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.business_center_rounded,
                                color: _headerBlue,
                                size: 28,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  isEnglish
                                      ? 'Listen to your body and take it slow'
                                      : 'अपने शरीर की सुनें और धीरे-धीरे आगे बढ़ें',
                                  style: const TextStyle(
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w900,
                                    color: _darkBlueText,
                                    height: 1.35,
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
          ],
        ),
      ),
    );
  }

  Widget _buildPrecautionRow({
    required String title,
    required String illustrationPath,
    required double illustrationWidth,
    required double illustrationHeight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Green Checkmark Icon on Left
        const Icon(
          Icons.check_circle_rounded,
          color: _checkmarkColor,
          size: 24,
        ),
        const SizedBox(width: 14),
        // Precaution Title
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: _textColor,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Illustration on Right
        SizedBox(
          width: 76,
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              illustrationPath,
              width: illustrationWidth,
              height: illustrationHeight,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    );
  }
}
