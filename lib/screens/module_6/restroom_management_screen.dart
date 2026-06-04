import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixRestroomManagementScreen extends StatelessWidget {
  const ModuleSixRestroomManagementScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const Color primaryGreen = Color(0xFF4E8D3A);
  static const Color badgeBackground = Color(0xFFEAF3E4);
  static const Color badgeTextGreen = Color(0xFF3B6B2B);
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
                    color: primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            isEnglish
                                ? '3. PUBLIC RESTROOM\nMANAGEMENT'
                                : '3. सार्वजनिक शौचालय\nप्रबंधन',
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
                          'assets/images/module6_restroom_header_toilet.png',
                          width: 48,
                          height: 48,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),

                  // Tips badge & tips rows
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TIPS Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            color: badgeBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isEnglish ? 'TIPS' : 'सुझाव',
                            style: const TextStyle(
                              color: badgeTextGreen,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.6,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tip Row 1
                        _buildTipRow(
                          imageAsset: 'assets/images/module6_restroom_tips_row1.png',
                          text: isEnglish
                              ? 'Carry tissue, wipes, disposal bags'
                              : 'टिशू, वाइप्स, डिस्पोजल बैग साथ रखें',
                        ),
                        _buildDivider(),

                        // Tip Row 2
                        _buildTipRow(
                          imageAsset: 'assets/images/module6_restroom_tips_row2.png',
                          text: isEnglish
                              ? 'Use hand sanitizer'
                              : 'हैंड सैनिटाइज़र का उपयोग करें',
                        ),
                        _buildDivider(),

                        // Tip Row 3
                        _buildTipRow(
                          imageAsset: 'assets/images/module6_restroom_tips_row3.png',
                          text: isEnglish
                              ? 'Take your time—no need to rush'
                              : 'समय लें—जल्दबाजी करने की आवश्यकता नहीं है',
                        ),
                      ],
                    ),
                  ),

                  // Bottom Scene Illustration
                  Image.asset(
                    'assets/images/module6_restroom_scene.png',
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipRow({required String imageAsset, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Image Frame
        Expanded(
          flex: 40,
          child: Container(
            height: 72,
            alignment: Alignment.center,
            child: Image.asset(
              imageAsset,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(width: 14),
        // Right Text Description
        Expanded(
          flex: 60,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14.5,
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
