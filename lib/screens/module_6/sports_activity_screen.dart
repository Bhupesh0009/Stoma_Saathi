import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixSportsActivityScreen extends StatelessWidget {
  const ModuleSixSportsActivityScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const Color primaryTeal = Color(0xFF5F9F99);
  static const Color successGreen = Color(0xFF4F9A4F);
  static const Color warningRed = Color(0xFFD85B4D);

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    final String screenTitle = isEnglish
        ? '10. SPORTS & PHYSICAL ACTIVITY WITH STOMA'
        : '10. खेल और शारीरिक गतिविधि';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Top Navigation Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Color(0xFF1E2939),
                    size: 26,
                  ),
                ),
                LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                  visible: true,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Main infographic card enclosing everything
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Teal Header Banner
                  Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                        decoration: BoxDecoration(
                          color: primaryTeal,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F5F9F99),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          screenTitle,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle & highlight with flanking icons
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/module6_sports_shield.png',
                        width: 55,
                        height: 55,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              isEnglish
                                  ? 'Staying active is good for your body and mind.'
                                  : 'सक्रिय रहना आपके शरीर और दिमाग के लिए अच्छा है।',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: isEnglish ? 'The key is to ' : 'मुख्य बात यह है कि ',
                                  ),
                                  TextSpan(
                                    text: isEnglish
                                        ? 'start slowly and listen to your body.'
                                        : 'धीरे-धीरे शुरुआत करें और अपने शरीर की सुनें।',
                                    style: const TextStyle(
                                      color: Color(0xFF2E7D32),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/module6_sports_pouch.png',
                        width: 55,
                        height: 55,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // SECTION 1 — WHAT YOU CAN DO
                  _buildSectionHeader(
                    title: isEnglish ? '✓ WHAT YOU CAN DO' : '✓ आप क्या कर सकते हैं',
                    color: successGreen,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FAF1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2EFE2), width: 1.2),
                    ),
                    child: Column(
                      children: [
                        _buildRowItem(
                          isGreen: true,
                          text: isEnglish
                              ? 'Start with walking after surgery and increase gradually.'
                              : 'सर्जरी के बाद चलने से शुरुआत करें और धीरे-धीरे बढ़ाएं।',
                          imagePath: 'assets/images/module6_sports_walking.png',
                          imageHeight: 65,
                        ),
                        _buildDottedDivider(),
                        _buildRowItem(
                          isGreen: true,
                          text: isEnglish
                              ? 'Light exercise, yoga, cycling, and stretching can be done after recovery.'
                              : 'ठीक होने के बाद हल्का व्यायाम, योग, साइकिल चलाना और स्ट्रेचिंग की जा सकती है।',
                          imagePath: 'assets/images/module6_sports_yoga_stretch.png',
                          imageHeight: 80,
                        ),
                        _buildDottedDivider(),
                        _buildRowItem(
                          isGreen: true,
                          text: isEnglish
                              ? 'Swimming is usually safe after complete healing.'
                              : 'पूरी तरह ठीक होने के बाद तैरना आमतौर पर सुरक्षित होता है।',
                          imagePath: 'assets/images/module6_sports_swimming.png',
                          imageHeight: 60,
                        ),
                        _buildDottedDivider(),
                        _buildRowItem(
                          isGreen: true,
                          text: isEnglish
                              ? 'Return to sports slowly and gradually after doctor/stoma nurse advice.'
                              : 'डॉक्टर/स्टोमा नर्स की सलाह के बाद धीरे-धीरे खेलों में वापसी करें।',
                          imagePath: 'assets/images/module6_sports_sports.png',
                          imageHeight: 80,
                        ),
                        _buildDottedDivider(),
                        _buildRowItem(
                          isGreen: true,
                          text: isEnglish
                              ? 'Empty your pouch before activity and drink enough fluids.'
                              : 'गतिविधि से पहले अपने पाउच को खाली करें और पर्याप्त तरल पदार्थ पिएं।',
                          imagePath: 'assets/images/module6_sports_hydration.png',
                          imageHeight: 65,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // SECTION 2 — WHAT TO AVOID
                  _buildSectionHeader(
                    title: isEnglish ? '✕ WHAT TO AVOID' : '✕ क्या करने से बचें',
                    color: warningRed,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF1F2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFCDDDB), width: 1.2),
                    ),
                    child: Column(
                      children: [
                        _buildRowItem(
                          isGreen: false,
                          text: isEnglish
                              ? 'Avoid heavy lifting or strenuous exercise in the early weeks.'
                              : 'शुरुआती हफ्तों में भारी वजन उठाने या कठिन व्यायाम से बचें।',
                          imagePath: 'assets/images/module6_avoid_lifting.png',
                          imageHeight: 65,
                        ),
                        _buildDottedDivider(),
                        _buildRowItem(
                          isGreen: false,
                          text: isEnglish
                              ? 'Avoid activities causing excess pressure on abdomen.'
                              : 'पेट पर अतिरिक्त दबाव डालने वाली गतिविधियों से बचें।',
                          imagePath: 'assets/images/module6_avoid_pressure.png',
                          imageHeight: 65,
                        ),
                        _buildDottedDivider(),
                        _buildRowItem(
                          isGreen: false,
                          text: isEnglish
                              ? 'Avoid contact sports if there is risk of injury to stoma.'
                              : 'यदि स्टोमा को चोट लगने का जोखिम हो तो कांटेक्ट स्पोर्ट्स से बचें।',
                          imagePath: 'assets/images/module6_avoid_contact.png',
                          imageHeight: 75,
                        ),
                        _buildDottedDivider(),
                        _buildRowItem(
                          isGreen: false,
                          text: isEnglish
                              ? 'Stop activity if you feel pain, leakage, dizziness, or discomfort.'
                              : 'यदि आपको दर्द, रिसाव, चक्कर या बेचैनी महसूस हो तो गतिविधि रोक दें।',
                          imagePath: 'assets/images/module6_avoid_symptoms.png',
                          imageHeight: 80,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // REMEMBER SECTION
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEA),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFF6E7A8), width: 1.2),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Left Remember column
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: Color(0xFFD87C0D),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isEnglish ? 'REMEMBER' : 'याद रखें',
                                    style: const TextStyle(
                                      color: Color(0xFFD87C0D),
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.6,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  children: [
                                    _buildRememberStep(
                                      iconData: Icons.directions_walk_rounded,
                                      text: isEnglish ? 'START\nSLOW' : 'धीरे\nशुरू करें',
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Color(0xFF2E7D32),
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    _buildRememberStep(
                                      iconData: Icons.trending_up_rounded,
                                      text: isEnglish ? 'INCREASE\nGRADUALLY' : 'धीरे-धीरे\nबढ़ाएं',
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      color: Color(0xFF2E7D32),
                                      size: 12,
                                    ),
                                    const SizedBox(width: 4),
                                    _buildRememberStep(
                                      iconData: Icons.favorite_rounded,
                                      text: isEnglish ? 'STAY ACTIVE\nSAFELY' : 'सक्रिय रहें\nसुरक्षित रहें',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Right character image
                        Image.asset(
                          'assets/images/module6_sports_character.png',
                          height: 80,
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
    );
  }

  Widget _buildSectionHeader({required String title, required Color color}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRowItem({
    required bool isGreen,
    required String text,
    required String imagePath,
    required double imageHeight,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isGreen ? Icons.check_circle_rounded : Icons.cancel_rounded,
            color: isGreen ? successGreen : warningRed,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 42,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 58,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRememberStep({required IconData iconData, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF2E7D32), width: 1.2),
          ),
          child: Icon(
            iconData,
            color: const Color(0xFF2E7D32),
            size: 15,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 8.5,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  Widget _buildDottedDivider() {
    return Row(
      children: List.generate(
        80,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : const Color(0xFFCFD8DC),
            height: 1.2,
          ),
        ),
      ),
    );
  }
}
