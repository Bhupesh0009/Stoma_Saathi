import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixCarryingSuppliesScreen extends StatelessWidget {
  const ModuleSixCarryingSuppliesScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  // Exact design tokens from Option 9 Reference
  static const _headerGreen = Color(0xFF5D9E46);
  static const _headerGreenDark = Color(0xFF488233);
  static const _lightGreenBg = Color(0xFFEEF7EB);
  static const _labelBorderGreen = Color(0xFFD2E8CD);
  static const _darkGreenText = Color(0xFF33691E);
  static const _checkmarkColor = Color(0xFF4CAF50);
  static const _textColor = Color(0xFF2D3748);
  static const _pageBackground = Color(0xFFF3FAF2); // Soft light-green page background
  static const _cardBackground = Colors.white;

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
                border: Border.all(color: const Color(0xFFE2EFE0), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: _headerGreen.withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section: Dark Green Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _headerGreen,
                          _headerGreenDark,
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
                          Icons.shopping_bag_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isEnglish ? '9. CARRYING SUPPLIES DISCREETLY' : '9. सामान को गोपनीय रूप से साथ रखें',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.3,
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
                        // Main Illustration: Beige Pouch Travel Bag
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Image.asset(
                              'assets/images/module6_carry_bag.png',
                              width: double.infinity,
                              height: 165,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),

                        // KEEP Label
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                            decoration: BoxDecoration(
                              color: _lightGreenBg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: _labelBorderGreen, width: 1.5),
                            ),
                            child: Text(
                              isEnglish ? 'KEEP:' : 'रखें:',
                              style: const TextStyle(
                                color: _darkGreenText,
                                fontSize: 13.0,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),

                        // Item 1: Extra Pouch
                        _buildSuppliesRow(
                          title: isEnglish ? 'Extra pouch' : 'अतिरिक्त पाउच',
                          illustrationPath: 'assets/images/module6_carry_extra_pouch.png',
                          illustrationWidth: 46,
                          illustrationHeight: 48,
                        ),
                        const SizedBox(height: 12),

                        // Item 2: Wipes
                        _buildSuppliesRow(
                          title: isEnglish ? 'Wipes' : 'वाइप्स',
                          illustrationPath: 'assets/images/module6_carry_wipes.png',
                          illustrationWidth: 64,
                          illustrationHeight: 42,
                        ),
                        const SizedBox(height: 12),

                        // Item 3: Disposal bags
                        _buildSuppliesRow(
                          title: isEnglish ? 'Disposal bags' : 'डिस्पोज़ल बैग',
                          illustrationPath: 'assets/images/module6_carry_disposal.png',
                          illustrationWidth: 50,
                          illustrationHeight: 68,
                        ),
                        const SizedBox(height: 24),

                        // Bottom Privacy Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: _lightGreenBg,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: _labelBorderGreen, width: 1.5),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left Side: Green Lock Illustration
                              Image.asset(
                                'assets/images/module6_carry_lock.png',
                                width: 28,
                                height: 38,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              // Center Text
                              Expanded(
                                child: Text(
                                  isEnglish
                                      ? 'No one needs to know unless you want to share'
                                      : 'जब तक आप स्वयं न बताना चाहें, किसी को जानने की आवश्यकता नहीं है',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w800,
                                    color: _darkGreenText,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Right Side: Outline Heart Icon
                              Image.asset(
                                'assets/images/module6_carry_heart.png',
                                width: 26,
                                height: 26,
                                fit: BoxFit.contain,
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

  Widget _buildSuppliesRow({
    required String title,
    required String illustrationPath,
    required double illustrationWidth,
    required double illustrationHeight,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Green Checkmark on Left
        const Icon(
          Icons.check_circle_rounded,
          color: _checkmarkColor,
          size: 24,
        ),
        const SizedBox(width: 14),
        // Item Title
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: _textColor,
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
