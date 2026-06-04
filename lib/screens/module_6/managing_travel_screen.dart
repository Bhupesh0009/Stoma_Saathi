import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixManagingTravelScreen extends StatelessWidget {
  const ModuleSixManagingTravelScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentTeal = Color(0xFF00796B);
  static const _pageBackground = Color(0xFFF7FBFA);
  static const _tipText = Color(0xFF1E293B);
  static const _infoBackground = Color(0xFFE0F2F1); // very light teal
  static const _infoBorder = Color(0xFFB2DFDB);

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
                    color: const Color(0xFF0F3E3B).withValues(alpha: 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header Row: Badge & Title + Bus Illustration on the right
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _accentTeal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '2',
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
                          isEnglish ? 'Managing Ostomy During Long Travel' : 'लंबी यात्रा के दौरान स्टोमा संभालना',
                          style: const TextStyle(
                            color: _accentTeal,
                            fontSize: 18.5,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Header Bus Image
                      Image.asset(
                        'assets/images/module6_travel_bus_header.png',
                        width: 70,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tips Vertical List
                  _buildTipRow(
                    imageAsset: 'assets/images/module6_travel_circle_pouch.png',
                    text: isEnglish ? 'Empty pouch regularly' : 'नियमित रूप से पाउच खाली करें',
                  ),
                  const SizedBox(height: 12),
                  _buildTipRow(
                    imageAsset: 'assets/images/module6_travel_circle_food.png',
                    text: isEnglish ? 'Avoid overeating before travel' : 'यात्रा से पहले अधिक खाने से बचें',
                  ),
                  const SizedBox(height: 12),
                  _buildTipRow(
                    imageAsset: 'assets/images/module6_travel_circle_water.png',
                    text: isEnglish ? 'Stay hydrated' : 'शरीर में पानी की कमी न होने दें',
                  ),
                  const SizedBox(height: 24),

                  // Bottom Scenery Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/module6_travel_scenery.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),

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
                          Icons.water_drop_rounded,
                          color: _accentTeal,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isEnglish
                                ? 'Plan ahead, stay comfortable, stay confident.'
                                : 'पहले से योजना बनाएं, सहज रहें, आत्मविश्वासी रहें।',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: _accentTeal,
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

  Widget _buildTipRow({required String imageAsset, required String text}) {
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
            imageAsset,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 16),
        // Right Text Description
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _tipText,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
