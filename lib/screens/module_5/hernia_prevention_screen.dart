import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleFiveHerniaPreventionScreen extends StatelessWidget {
  const ModuleFiveHerniaPreventionScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentPurple = Color(0xFF432A9C);
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
                    color: const Color(0xFF2C0F3E).withValues(alpha: 0.05),
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
                          color: _accentPurple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '3',
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
                              ? 'Hernia Prevention Techniques'
                              : 'हर्निया से बचाव के तरीके',
                          style: const TextStyle(
                            color: _accentPurple,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Vertical List of Items
                  _buildListItem(
                    imagePath: 'assets/images/module5_hernia_pillow.png',
                    text: isEnglish
                        ? 'Support your abdomen with a pillow while coughing/sneezing'
                        : 'खांसते/छींकते समय अपने पेट को तकिये से सहारा दें',
                  ),
                  const SizedBox(height: 20),
                  _buildListItem(
                    imagePath: 'assets/images/module5_hernia_strain.png',
                    text: isEnglish ? 'Avoid sudden strain' : 'अचानक पड़ने वाले दबाव से बचें',
                  ),
                  const SizedBox(height: 20),
                  _buildListItem(
                    imagePath: 'assets/images/module5_hernia_posture.png',
                    text: isEnglish ? 'Maintain proper posture' : 'सही मुद्रा (पोस्चर) बनाए रखें',
                  ),
                  const SizedBox(height: 20),
                  _buildListItem(
                    imagePath: 'assets/images/module5_hernia_belt.png',
                    text: isEnglish ? 'Use support belt if advised' : 'सलाह मिलने पर सपोर्ट बेल्ट का उपयोग करें',
                  ),
                  const SizedBox(height: 24),

                  // Bottom Info Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F1FC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8E5F8), width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.east_rounded,
                          color: _accentPurple,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isEnglish
                                ? 'Helps prevent parastomal hernia'
                                : 'पैरास्टोमल हर्निया से बचाव में मदद करता है',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: _accentPurple,
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

  Widget _buildListItem({required String imagePath, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Circular Image Frame
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFECEFF1), width: 1.5),
            color: Colors.white,
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        // Right Text Description
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
    );
  }
}
