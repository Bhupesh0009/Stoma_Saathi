import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../widgets/index.dart';

class ModuleSixClothingTipsScreen extends StatelessWidget {
  const ModuleSixClothingTipsScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  static const _accentPink = Color(0xFFE96A8D);
  static const _wearGreen = Color(0xFF5BAA58);
  static const _avoidRed = Color(0xFFD9534F);
  static const _pageBackground = Color(0xFFFFF5F6); // Soft pink background

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
                border: Border.all(color: const Color(0xFFFCEEEF), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE96A8D).withValues(alpha: 0.06),
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
                          Color(0xFFEC7E9C),
                          Color(0xFFE96A8D),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            isEnglish ? '6. CLOTHING TIPS' : '6. कपड़ों के सुझाव',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        CustomPaint(
                          size: const Size(32, 32),
                          painter: _TShirtPainter(),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // WEAR SECTION
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 480;

                            final wearText = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // WEAR Label
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF5EA),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFD0E8D0), width: 1),
                                  ),
                                  child: Text(
                                    isEnglish ? 'WEAR' : 'पहनें',
                                    style: const TextStyle(
                                      color: _wearGreen,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _buildWearRow(
                                  isEnglish ? 'Loose, comfortable clothes' : 'ढीले, आरामदायक कपड़े',
                                ),
                                const SizedBox(height: 10),
                                _buildWearRow(
                                  isEnglish ? 'High-waist garments' : 'हाई-वेस्ट कपड़े',
                                ),
                              ],
                            );

                            final wearIllustration = SizedBox(
                              width: 120,
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  heightFactor: 0.58,
                                  child: Image.asset(
                                    'assets/images/module6_clothing_tips.png',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: wearText),
                                  const SizedBox(width: 16),
                                  wearIllustration,
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: wearText),
                                  const SizedBox(width: 8),
                                  wearIllustration,
                                ],
                              );
                            }
                          },
                        ),
                        
                        // Divider Line
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          child: Divider(
                            color: Color(0xFFFBE4E7),
                            height: 1.5,
                            thickness: 1.5,
                          ),
                        ),

                        // AVOID SECTION
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 480;

                            final avoidText = Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // AVOID Label
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF0F2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFFCDDDF), width: 1),
                                  ),
                                  child: Text(
                                    isEnglish ? 'AVOID' : 'बचें',
                                    style: const TextStyle(
                                      color: _avoidRed,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                _buildAvoidRow(
                                  isEnglish ? 'Tight belts or tight waistbands' : 'तंग बेल्ट या तंग कमरबंद',
                                ),
                              ],
                            );

                            final avoidIllustration = SizedBox(
                              width: 120,
                              child: ClipRect(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  heightFactor: 0.42,
                                  child: Image.asset(
                                    'assets/images/module6_clothing_tips.png',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            );

                            if (isWide) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: avoidText),
                                  const SizedBox(width: 16),
                                  avoidIllustration,
                                ],
                              );
                            } else {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(child: avoidText),
                                  const SizedBox(width: 8),
                                  avoidIllustration,
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),

                        // Bottom Comfort Info Strip
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF0F2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFCDDDF), width: 1),
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
                                child: Text(
                                  isEnglish
                                      ? 'Choose what makes you feel comfortable and confident'
                                      : 'वही चुनें जो आपको सहज और आत्मविश्वासी बनाए',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF6A1B29),
                                    height: 1.35,
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

  Widget _buildWearRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: _wearGreen,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D3748),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvoidRow(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.cancel_rounded,
          color: _avoidRed,
          size: 22,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D3748),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _TShirtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    final path = Path();
    // Neck collar curve
    path.moveTo(w * 0.35, h * 0.15);
    path.quadraticBezierTo(w * 0.5, h * 0.25, w * 0.65, h * 0.15);
    // Shoulder right
    path.lineTo(w * 0.82, h * 0.22);
    // Sleeve right out
    path.lineTo(w * 0.95, h * 0.40);
    // Sleeve right bottom
    path.lineTo(w * 0.80, h * 0.48);
    // Underarm right
    path.lineTo(w * 0.75, h * 0.38);
    // Body right bottom
    path.lineTo(w * 0.75, h * 0.85);
    // Bottom hem
    path.lineTo(w * 0.25, h * 0.85);
    // Body left bottom
    path.lineTo(w * 0.25, h * 0.38);
    // Underarm left
    path.lineTo(w * 0.20, h * 0.48);
    // Sleeve left bottom
    path.lineTo(w * 0.05, h * 0.40);
    // Shoulder left
    path.lineTo(w * 0.18, h * 0.22);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


