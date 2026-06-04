import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleFiveLiftingPrecautionsScreen extends StatelessWidget {
  const ModuleFiveLiftingPrecautionsScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentOrange = Color(0xFFE65100);
  static const _avoidRed = Color(0xFFD32F2F);
  static const _safeGreen = Color(0xFF2E7D32);
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
                    color: const Color(0xFF4E2C0F).withValues(alpha: 0.05),
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
                          color: _accentOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '4',
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
                              ? 'Lifting & Straining Precautions'
                              : 'वजन उठाने और ज़ोर लगाने से संबंधित सावधानियां',
                          style: const TextStyle(
                            color: _accentOrange,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Upper Section: Avoid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 550;

                      final textColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEnglish ? 'Avoid:' : 'बचें:',
                            style: const TextStyle(
                              color: _avoidRed,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildBulletRow(
                            isEnglish ? 'Heavy lifting (>5 kg initially)' : 'भारी वजन उठाना (शुरुआत में >5 किलो)',
                          ),
                          _buildBulletRow(
                            isEnglish ? 'Straining during bowel movement' : 'मल त्याग के दौरान ज़ोर लगाना',
                          ),
                          _buildBulletRow(
                            isEnglish ? 'Sudden bending' : 'अचानक झुकना',
                          ),
                        ],
                      );

                      final imageWidget = Container(
                        constraints: const BoxConstraints(maxHeight: 180),
                        child: Image.asset(
                          'assets/images/module5_lifting_avoid.png',
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

                  // Lower Section: Safe Practice
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 550;

                      final textColumn = Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEnglish ? 'Safe Practice:' : 'सुरक्षित अभ्यास:',
                            style: const TextStyle(
                              color: _safeGreen,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildBulletRow(
                            isEnglish ? 'Bend knees while lifting light objects' : 'हल्की चीजें उठाते समय घुटने मोड़ें',
                          ),
                          _buildBulletRow(
                            isEnglish ? 'Ask for help when needed' : 'ज़रूरत पड़ने पर मदद मांगें',
                          ),
                        ],
                      );

                      final imageWidget = Container(
                        constraints: const BoxConstraints(maxHeight: 185),
                        child: Image.asset(
                          'assets/images/module5_lifting_safe.png',
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
            padding: EdgeInsets.only(top: 6.0, right: 10.0),
            child: Icon(
              Icons.fiber_manual_record,
              size: 8,
              color: Color(0xFF1E293B),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15.5,
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
