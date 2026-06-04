import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixTransportationSafetyScreen extends StatelessWidget {
  const ModuleSixTransportationSafetyScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const Color primaryPurple = Color(0xFF7A5AB5);
  static const Color pageBackground = Color(0xFFF7FBFA);
  static const Color textDark = Color(0xFF1E293B);
  static const Color dividerColor = Color(0xFFE5E5E5);

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
                  // Header Banner section
                  Container(
                    color: primaryPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            isEnglish
                                ? '4. TRANSPORTATION\n& SAFETY'
                                : '4. परिवहन और\nसुरक्षा',
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
                          'assets/images/module6_transportation_header_bus.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  // Content Section (Always two-column layout: options on the left, passenger on the right)
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isMobile = constraints.maxWidth < 480;
                      final paddingVal = isMobile ? 10.0 : 20.0;
                      final fontSizeVal = isMobile ? 12.0 : 13.5;

                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Left column - Tips list
                            Expanded(
                              flex: 52,
                              child: Padding(
                                padding: EdgeInsets.all(paddingVal),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildTipRow(
                                      imageAsset: 'assets/images/module6_transportation_tips_seat.png',
                                      text: isEnglish
                                          ? 'Sit comfortably\n(avoid pressure on stoma)'
                                          : 'आराम से बैठें\n(स्टोमा पर दबाव से बचें)',
                                      fontSize: fontSizeVal,
                                    ),
                                    _buildDivider(),
                                    _buildTipRow(
                                      imageAsset: 'assets/images/module6_transportation_tips_crowd.png',
                                      text: isEnglish
                                          ? 'Avoid crowded places\ninitially'
                                          : 'शुरुआत में भीड़भाड़\nवाली जगहों से बचें',
                                      fontSize: fontSizeVal,
                                    ),
                                    _buildDivider(),
                                    _buildTipRow(
                                      imageAsset: 'assets/images/module6_transportation_tips_bag.png',
                                      text: isEnglish
                                          ? 'Keep supplies\neasily accessible'
                                          : 'सामग्री को आसानी\nसे सुलभ रखें',
                                      fontSize: fontSizeVal,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Vertical divider line
                            const VerticalDivider(
                              color: dividerColor,
                              thickness: 1.2,
                              width: 1,
                            ),
                            // Right column - Passenger illustration
                            Expanded(
                              flex: 48,
                              child: Image.asset(
                                'assets/images/module6_transportation_passenger.png',
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),
                            ),
                          ],
                        ),
                      );
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

  Widget _buildTipRow({
    required String imageAsset,
    required String text,
    required double fontSize,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left circular icon frame
        Expanded(
          flex: 38,
          child: Container(
            height: 72,
            alignment: Alignment.center,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Right text description
        Expanded(
          flex: 62,
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
      ],
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Divider(
        color: dividerColor,
        thickness: 1.2,
      ),
    );
  }
}
