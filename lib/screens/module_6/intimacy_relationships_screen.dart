import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixIntimacyRelationshipsScreen extends StatelessWidget {
  const ModuleSixIntimacyRelationshipsScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentPink = Color(0xFFE97A96);
  static const _darkPinkText = Color(0xFFC84F73);
  static const _heartColor = Color(0xFFE86D90);
  static const _pageBackground = Color(0xFFFFF6F8); // Soft pink background

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFCECEF), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE97A96).withValues(alpha: 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Section: Pink Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFEC8EA3),
                          Color(0xFFE97A96),
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
                          Icons.favorite_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isEnglish ? 'INTIMACY & RELATIONSHIPS' : 'निकटता और रिश्ते',
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
                        // SECTION 1: EMOTIONAL SUPPORT
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 480;

                            final emotionalText = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section Label
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDECEF),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFBDCE2), width: 1),
                                  ),
                                  child: Text(
                                    isEnglish ? 'EMOTIONAL SUPPORT' : 'भावनात्मक समर्थन',
                                    style: const TextStyle(
                                      color: _darkPinkText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _buildTipRow(
                                  isEnglish ? 'Feeling nervous is normal' : 'घबराहट होना सामान्य है',
                                ),
                                const SizedBox(height: 12),
                                _buildTipRow(
                                  isEnglish ? 'Talk openly with your partner' : 'अपने साथी से खुलकर बात करें',
                                ),
                              ],
                            );

                            final emotionalIllustration = SizedBox(
                              width: 130,
                              height: 105,
                              child: Image.asset(
                                'assets/images/module6_intimacy_couple.png',
                                fit: BoxFit.contain,
                              ),
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: emotionalText),
                                  const SizedBox(width: 16),
                                  emotionalIllustration,
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: emotionalText),
                                  const SizedBox(width: 8),
                                  emotionalIllustration,
                                ],
                              );
                            }
                          },
                        ),
                        
                        // Divider Line
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Divider(
                            color: Color(0xFFFCE6EB),
                            height: 1.5,
                            thickness: 1.5,
                          ),
                        ),

                        // SECTION 2: TIPS FOR SAFE INTIMACY
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 480;

                            final safeText = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Section Label
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFDECEF),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFBDCE2), width: 1),
                                  ),
                                  child: Text(
                                    isEnglish ? 'TIPS FOR SAFE INTIMACY' : 'सुरक्षित निकटता के सुझाव',
                                    style: const TextStyle(
                                      color: _darkPinkText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _buildTipRow(
                                  isEnglish ? 'Empty pouch before activity' : 'गतिविधि से पहले पाउच खाली करें',
                                ),
                                const SizedBox(height: 12),
                                _buildTipRow(
                                  isEnglish ? 'Use pouch cover if needed' : 'यदि आवश्यक हो तो पाउच कवर का उपयोग करें',
                                ),
                                const SizedBox(height: 12),
                                _buildTipRow(
                                  isEnglish ? 'Choose comfortable positions' : 'आरामदायक स्थितियों का चयन करें',
                                ),
                              ],
                            );

                            final safeIllustration = SizedBox(
                              width: 130,
                              height: 110,
                              child: Image.asset(
                                'assets/images/module6_intimacy_pouch.png',
                                fit: BoxFit.contain,
                              ),
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: safeText),
                                  const SizedBox(width: 16),
                                  safeIllustration,
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: safeText),
                                  const SizedBox(width: 8),
                                  safeIllustration,
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Bottom Support Banner
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDECEF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFBDCE2), width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.favorite_rounded,
                                color: _accentPink,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w800,
                                      height: 1.35,
                                    ),
                                    children: isEnglish
                                        ? const [
                                            TextSpan(
                                              text: 'Your stoma',
                                              style: TextStyle(color: _darkPinkText),
                                            ),
                                            TextSpan(
                                              text: ' does ',
                                              style: TextStyle(color: Color(0xFF475569)),
                                            ),
                                            TextSpan(
                                              text: 'not stop',
                                              style: TextStyle(color: _darkPinkText),
                                            ),
                                            TextSpan(
                                              text: ' you from having a ',
                                              style: TextStyle(color: Color(0xFF475569)),
                                            ),
                                            TextSpan(
                                              text: 'hea',
                                              style: TextStyle(color: Color(0xFF475569)),
                                            ),
                                            TextSpan(
                                              text: 'lth',
                                              style: TextStyle(color: _darkPinkText),
                                            ),
                                            TextSpan(
                                              text: 'y relationship.',
                                              style: TextStyle(color: Color(0xFF475569)),
                                            ),
                                          ]
                                        : const [
                                            TextSpan(
                                              text: 'आपका स्टोमा',
                                              style: TextStyle(color: _darkPinkText),
                                            ),
                                            TextSpan(
                                              text: ' आपको एक ',
                                              style: TextStyle(color: Color(0xFF475569)),
                                            ),
                                            TextSpan(
                                              text: 'स्वस्थ',
                                              style: TextStyle(color: _darkPinkText),
                                            ),
                                            TextSpan(
                                              text: ' रिश्ता बनाने से ',
                                              style: TextStyle(color: Color(0xFF475569)),
                                            ),
                                            TextSpan(
                                              text: 'नहीं रोकता',
                                              style: TextStyle(color: _darkPinkText),
                                            ),
                                            TextSpan(
                                              text: ' है।',
                                              style: TextStyle(color: Color(0xFF475569)),
                                            ),
                                          ],
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

  Widget _buildTipRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Icon(
            Icons.favorite_rounded,
            color: _heartColor,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D3748),
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
