import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixTravelTipsScreen extends StatelessWidget {
  const ModuleSixTravelTipsScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentBlue = Color(0xFF1565C0);
  static const _pageBackground = Color(0xFFF7FBFA);
  static const _infoText = Color(0xFF1E293B);
  static const _infoBackground = Color(0xFFF0FDF4); // very light green tint
  static const _infoBorder = Color(0xFFDCFCE7);

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
                    color: const Color(0xFF0F223E).withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Row: Badge & Title + Airplane Illustration on the right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _accentBlue,
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
                          isEnglish ? 'Travel Tips' : 'यात्रा के सुझाव',
                          style: const TextStyle(
                            color: _accentBlue,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Header Airplane Image
                      Image.asset(
                        'assets/images/module6_travel_header_airplane.png',
                        width: 90,
                        height: 45,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Section 1: Before Travel
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _accentBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isEnglish ? 'Before Travel:' : 'यात्रा से पहले:',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 550;

                      final textColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBulletRow(
                            isEnglish
                                ? 'Carry extra supplies\n(2–3 times needed amount)'
                                : 'अतिरिक्त आपूर्ति साथ रखें\n(ज़रूरत से 2–3 गुना अधिक)',
                          ),
                          _buildBulletRow(
                            isEnglish
                                ? 'Keep supplies in\nhandbag (not luggage)'
                                : 'सामान हैंडबैग में रखें\n(लगेज में नहीं)',
                          ),
                          _buildBulletRow(
                            isEnglish
                                ? 'Carry a doctor’s note\n(if possible)'
                                : 'डॉक्टर का पर्चा साथ रखें\n(यदि संभव हो)',
                          ),
                        ],
                      );

                      final imageWidget = Container(
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: Image.asset(
                          'assets/images/module6_travel_before.png',
                          fit: BoxFit.contain,
                        ),
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 5, child: textColumn),
                            const SizedBox(width: 16),
                            Expanded(flex: 4, child: imageWidget),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            textColumn,
                            const SizedBox(height: 16),
                            Center(child: imageWidget),
                          ],
                        );
                      }
                    },
                  ),

                  // Divider (Dotted style simulation)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: _buildDottedDivider(),
                  ),

                  // Section 2: During Travel
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: _accentBlue,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isEnglish ? 'During Travel:' : 'यात्रा के दौरान:',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 550;

                      final textColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBulletRow(
                            isEnglish ? 'Empty pouch before starting' : 'यात्रा शुरू करने से पहले पाउच खाली करें',
                          ),
                          _buildBulletRow(
                            isEnglish
                                ? 'Keep a small\nemergency kit ready'
                                : 'एक छोटी\nइमरजेंसी किट तैयार रखें',
                          ),
                        ],
                      );

                      final imageWidget = Container(
                        constraints: const BoxConstraints(maxHeight: 190),
                        child: Image.asset(
                          'assets/images/module6_travel_during.png',
                          fit: BoxFit.contain,
                        ),
                      );

                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 5, child: textColumn),
                            const SizedBox(width: 16),
                            Expanded(flex: 4, child: imageWidget),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            textColumn,
                            const SizedBox(height: 16),
                            Center(child: imageWidget),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Bottom Info Strip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: _infoBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _infoBorder, width: 1.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lightbulb_rounded,
                          color: Color(0xFFFBC02D),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isEnglish
                                ? 'Travel is safe with proper planning.'
                                : 'उचित योजना के साथ यात्रा सुरक्षित है।',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: _infoText,
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

  Widget _buildBulletRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2.0, right: 12.0),
            child: Icon(
              Icons.check_circle,
              size: 20,
              color: _accentBlue,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDottedDivider() {
    return Row(
      children: List.generate(
        150,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : const Color(0xFFECEFF1),
            height: 1.5,
          ),
        ),
      ),
    );
  }
}
