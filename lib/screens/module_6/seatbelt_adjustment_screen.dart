import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixSeatBeltAdjustmentScreen extends StatelessWidget {
  const ModuleSixSeatBeltAdjustmentScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const Color primaryTeal = Color(0xFF4F8791);
  static const Color checkGreen = Color(0xFF58A95B);
  static const Color pageBackground = Color(0xFFF7FBFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color dividerColor = Color(0xFFECEFF1);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: pageBackground,
      appBar: AppBar(
        backgroundColor: pageBackground,
        surfaceTintColor: pageBackground,
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
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header section
                  Container(
                    color: primaryTeal,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            isEnglish
                                ? '5. CAR SEAT BELT\nADJUSTMENT'
                                : '5. कार सीट बेल्ट\nठीक करना',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w900,
                              height: 1.25,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Image.asset(
                          'assets/images/module6_seatbelt_header_car.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  // Main content area
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 480;

                      if (isMobile) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Passenger illustration on top
                            Container(
                              height: 240,
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/module6_seatbelt_passenger.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                            // Tips below
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Column(
                                children: [
                                  _buildTipRow(
                                    text: isEnglish
                                        ? 'Adjust belt to avoid direct pressure on stoma'
                                        : 'स्टोमा पर सीधे दबाव से बचने के लिए बेल्ट को समायोजित करें',
                                    fontSize: 13.0,
                                  ),
                                  const SizedBox(height: 16),
                                  _buildTipRow(
                                    text: isEnglish
                                        ? 'Use a small cushion or soft cloth if needed'
                                        : 'यदि आवश्यक हो तो एक छोटा तकिया या मुलायम कपड़े का उपयोग करें',
                                    fontSize: 13.0,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Cushion illustration below tips
                            Center(
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                width: 120,
                                height: 120,
                                child: Image.asset(
                                  'assets/images/module6_seatbelt_cushion.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Desktop two-column layout
                        return IntrinsicHeight(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Left column - Passenger illustration
                                  Expanded(
                                    flex: 54,
                                    child: Image.asset(
                                      'assets/images/module6_seatbelt_passenger.png',
                                      fit: BoxFit.cover,
                                      alignment: Alignment.centerLeft,
                                    ),
                                  ),
                                  // Right column - Safety Tips
                                  Expanded(
                                    flex: 46,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _buildTipRow(
                                            text: isEnglish
                                                ? 'Adjust belt to\navoid direct\npressure\non stoma'
                                                : 'स्टोमा पर सीधे\nदबाव से बचने के\nलिए बेल्ट को\nसमायोजित करें',
                                            fontSize: 13.5,
                                          ),
                                          const SizedBox(height: 28),
                                          _buildTipRow(
                                            text: isEnglish
                                                ? 'Use a small\ncushion or\nsoft cloth\nif needed'
                                                : 'यदि आवश्यक हो\nतो एक छोटा\nतकिया या मुलायम\nकपड़े का उपयोग करें',
                                            fontSize: 13.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Positioned cushion circle overlapping passenger illustration
                              Positioned(
                                left: constraints.maxWidth * 0.54 - 45,
                                bottom: 0,
                                width: 120,
                                height: 100,
                                child: Image.asset(
                                  'assets/images/module6_seatbelt_cushion.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildTipRow({required String text, required double fontSize}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: checkGreen,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w800,
                color: textDark,
                height: 1.35,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
