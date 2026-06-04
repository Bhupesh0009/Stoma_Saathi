import 'package:flutter/material.dart';
import '../models/app_models.dart';

class DisclaimerScreen extends StatelessWidget {
  final AppLanguage language;

  const DisclaimerScreen({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppText(language);
    final isEnglish = language == AppLanguage.english;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFA),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: kToolbarHeight,
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF006D6F),
            size: 26,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          isEnglish ? 'DISCLAIMER' : 'अस्वीकरण',
          style: const TextStyle(
            color: Color(0xFF006D6F),
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
        color: const Color(0xFF073940),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              const Icon(
                Icons.monitor_heart_rounded,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text.footerText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.health_and_safety_rounded,
                color: Colors.white,
                size: 22,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Top-Left Wave (Responsive width)
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: _TopLeftWaveClipper(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 180,
                color: const Color(0xFFD5EAE8),
              ),
            ),
          ),
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 550;
                      if (isWide) {
                        return SizedBox(
                          height: 160,
                          child: Stack(
                            children: [
                              // Centered Shield Logo and Titles
                              Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 160, // Offset to avoid overlapping the branding on right
                                    top: 20,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Main Shield Logo
                                      Image.asset(
                                        'assets/images/disclaimer_shield.png',
                                        width: 68,
                                        fit: BoxFit.contain,
                                      ),
                                      const SizedBox(height: 12),
                                      // Main Titles
                                      Text(
                                        isEnglish ? 'DISCLAIMER' : 'अस्वीकरण',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF073940),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        text.disclaimerImportantNotice,
                                        style: const TextStyle(
                                          fontSize: 16.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF006D6F),
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Top-Right Branding Section
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    right: 24,
                                    top: 16,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(alpha: 0.06),
                                              blurRadius: 10,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        padding: const EdgeInsets.all(3),
                                        child: ClipOval(
                                          child: Image.asset(
                                            'assets/images/logo.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        text.appName.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF073940),
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isEnglish ? 'Your Companion\nin Self-Care' : 'स्व-देखभाल में\nआपका साथी',
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF006D6F),
                                          height: 1.2,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Mobile View: Stack them vertically using a Column
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Branding Section
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.06),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(3),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                text.appName.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF073940),
                                  letterSpacing: 0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isEnglish ? 'Your Companion\nin Self-Care' : 'स्व-देखभाल में\nआपका साथी',
                                style: const TextStyle(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF006D6F),
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24), // Space between branding and shield logo
                              
                              // Shield Logo
                              Image.asset(
                                'assets/images/disclaimer_shield.png',
                                width: 68,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 12),
                              // Titles
                              Text(
                                isEnglish ? 'DISCLAIMER' : 'अस्वीकरण',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF073940),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              Text(
                                text.disclaimerImportantNotice,
                                style: const TextStyle(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF006D6F),
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  
                  // Decorative Divider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 80,
                        child: Divider(
                          color: Color(0xFF006D6F),
                          thickness: 1.2,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: const Color(0xFF006D6F),
                          size: 14,
                        ),
                      ),
                      const SizedBox(
                        width: 80,
                        child: Divider(
                          color: Color(0xFF006D6F),
                          thickness: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Notice Card 1: Educational Purposes
                  _InfoCard(
                    iconAsset: 'assets/images/disclaimer_info_book.png',
                    details: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.45,
                            color: Color(0xFF37474F),
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(text: text.disclaimerNotice1Part1),
                            TextSpan(
                              text: text.disclaimerNotice1Highlight,
                              style: const TextStyle(
                                color: Color(0xFF006D6F),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(text: text.disclaimerNotice1Part2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Notice Card 2: Does Not Replace Medical Advice
                  _InfoCard(
                    iconAsset: 'assets/images/disclaimer_steth_x.png',
                    details: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.45,
                            color: Color(0xFF37474F),
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(text: text.disclaimerNotice2Part1),
                            TextSpan(
                              text: text.disclaimerNotice2Highlight,
                              style: const TextStyle(
                                color: Color(0xFF006D6F),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(text: text.disclaimerNotice2Part2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  // Notice Card 3: Instructions & Emergency Warnings
                  _InfoCard(
                    iconAsset: 'assets/images/disclaimer_nurse_plus.png',
                    details: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.45,
                            color: Color(0xFF37474F),
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(text: text.disclaimerNotice3Part1),
                            TextSpan(
                              text: text.emWordPain,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(text: ', '),
                            TextSpan(
                              text: text.emWordBleeding,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(text: ', '),
                            TextSpan(
                              text: text.emWordFever,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(text: ', '),
                            TextSpan(
                              text: text.emWordLeakage,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(text: ', '),
                            TextSpan(
                              text: text.emWordSkin,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const TextSpan(text: ', '),
                            TextSpan(
                              text: text.emWordColor,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: isEnglish ? ', or ' : ', ',
                            ),
                            TextSpan(
                              text: text.emWordEmergency,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(text: text.disclaimerNotice3Part2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Emergency Help Title Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD32F2F).withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          text.seekMedicalHelp,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  // Emergency Help Icons Card
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFFD32F2F).withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          _EmergencyItem(
                            imageAsset: 'assets/images/disclaimer_em_pain.png',
                            label: text.labelPain,
                          ),
                          const SizedBox(width: 12),
                          _EmergencyItem(
                            imageAsset: 'assets/images/disclaimer_em_bleeding.png',
                            label: text.labelBleeding,
                          ),
                          const SizedBox(width: 12),
                          _EmergencyItem(
                            imageAsset: 'assets/images/disclaimer_em_fever.png',
                            label: text.labelFever,
                          ),
                          const SizedBox(width: 12),
                          _EmergencyItem(
                            imageAsset: 'assets/images/disclaimer_em_leakage.png',
                            label: text.labelLeakage,
                          ),
                          const SizedBox(width: 12),
                          _EmergencyItem(
                            imageAsset: 'assets/images/disclaimer_em_color.png',
                            label: text.labelColor,
                          ),
                          const SizedBox(width: 12),
                          _EmergencyItem(
                            imageAsset: 'assets/images/disclaimer_em_skin.png',
                            label: text.labelSkin,
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Support Message Card (with leaves decoration in the bottom right corner)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF4F4),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // Bottom Right Leaves Decoration
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: Opacity(
                              opacity: 0.5,
                              child: Image.asset(
                                'assets/images/about_leaves.png',
                                width: 68,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/disclaimer_hands_heart.png',
                                  width: 48,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        height: 1.45,
                                        color: Color(0xFF37474F),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      children: [
                                        TextSpan(text: text.supportMessagePart1),
                                        TextSpan(
                                          text: text.supportMessageHighlight,
                                          style: const TextStyle(
                                            color: Color(0xFF006D6F),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        TextSpan(text: text.supportMessagePart2),
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
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String iconAsset;
  final List<Widget> details;

  const _InfoCard({
    required this.iconAsset,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF4F4),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: Circular Illustration Image
              Padding(
                padding: const EdgeInsets.all(14.0),
                child: Center(
                  child: Image.asset(
                    iconAsset,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              
              // Vertical Divider
              VerticalDivider(
                color: const Color(0xFF006D6F).withValues(alpha: 0.12),
                thickness: 1.5,
                width: 1,
                indent: 14,
                endIndent: 14,
              ),
              const SizedBox(width: 4),
              
              // Right: Text details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: details,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyItem extends StatelessWidget {
  final String imageAsset;
  final String label;

  const _EmergencyItem({
    required this.imageAsset,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: Column(
        children: [
          Image.asset(
            imageAsset,
            width: 54,
            height: 54,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF073940),
              height: 1.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}

class _TopLeftWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width * 0.45,
      size.height,
      size.width,
      0,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
