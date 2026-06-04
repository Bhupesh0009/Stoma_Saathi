import 'package:flutter/material.dart';
import '../models/app_models.dart';

class AboutAppScreen extends StatelessWidget {
  final AppLanguage language;

  const AboutAppScreen({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final text = AppText(language);

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
          language == AppLanguage.english ? 'About the App' : 'ऐप के बारे में',
          style: const TextStyle(
            color: Color(0xFF006D6F),
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Top-Left Wave
          Positioned(
            top: 0,
            left: 0,
            child: ClipPath(
              clipper: _TopLeftWaveClipper(),
              child: Container(
                width: 250,
                height: 160,
                color: const Color(0xFFD5EAE8),
              ),
            ),
          ),
          // Background Top-Right Leaves
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
              'assets/images/about_leaves.png',
              width: 140,
              fit: BoxFit.contain,
            ),
          ),
          // Main scrollable content
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  
                  // Main Logo Section
                  Center(
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF006D6F).withValues(alpha: 0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(4),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  
                  // STOMA SAATHI title
                  Text(
                    text.appName.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF006D6F),
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Subtitle
                  Text(
                    text.aboutAppSubtitle,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF37474F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  
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
                  
                  // Description Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left side: Phone Illustration
                          Center(
                            child: Image.asset(
                              'assets/images/about_phone.png',
                              width: 96,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 14),
                          
                          // Vertical Divider
                          VerticalDivider(
                            color: const Color(0xFF006D6F).withValues(alpha: 0.2),
                            thickness: 1.5,
                            width: 1,
                            indent: 6,
                            endIndent: 6,
                          ),
                          const SizedBox(width: 14),
                          
                          // Right side: Description Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  text.aboutDescription1,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.45,
                                    color: Color(0xFF37474F),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  text.aboutDescription2,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.45,
                                    color: Color(0xFF37474F),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Information Card 1: Developed By
                  _InfoCard(
                    icon: Icons.school_rounded,
                    title: text.aboutDevTitle,
                    details: [
                      Text(
                        text.aboutDevName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF073940),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        text.aboutDevDegree,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF546E7A),
                        ),
                      ),
                      Text(
                        text.aboutDevInst,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF546E7A),
                        ),
                      ),
                    ],
                  ),
                  
                  // Information Card 2: Academic Guidance
                  _InfoCard(
                    icon: Icons.groups_rounded,
                    title: text.aboutGuidanceTitle,
                    details: [
                      Text(
                        text.aboutGuidanceText,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF546E7A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        text.aboutGuidanceInst,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF073940),
                        ),
                      ),
                    ],
                  ),
                  
                  // Information Card 3: Content Validation
                  _InfoCard(
                    icon: Icons.verified_user_rounded,
                    title: text.aboutValidationTitle,
                    details: [
                      Text(
                        text.aboutValidationText,
                        style: const TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF546E7A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Bottom Support Section
                  ClipPath(
                    clipper: _BottomWaveClipper(),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFD5EAE8),
                      padding: const EdgeInsets.fromLTRB(20, 56, 20, 28),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left: Hands holding heart illustration
                          Image.asset(
                            'assets/images/about_hands.png',
                            width: 80,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(width: 14),
                          
                          // Right: Text and small divider
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  text.aboutSupportText1,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF073940),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  text.aboutSupportText2,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF073940),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                
                                // Heart Divider inside bottom support wave
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(
                                      width: 40,
                                      child: Divider(
                                        color: Color(0xFF006D6F),
                                        thickness: 0.8,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      child: Icon(
                                        Icons.favorite_rounded,
                                        color: const Color(0xFF006D6F),
                                        size: 10,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 40,
                                      child: Divider(
                                        color: Color(0xFF006D6F),
                                        thickness: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
  final IconData icon;
  final String title;
  final List<Widget> details;

  const _InfoCard({
    required this.icon,
    required this.title,
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
              // Left: circular container with white icon
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFF073940),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
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
                  padding: const EdgeInsets.fromLTRB(12, 14, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Card Category Title
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF006D6F),
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...details,
                    ],
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

class _BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Start at left, slightly below top offset
    path.moveTo(0, 35);
    // Bezier curve to right, slightly below top offset
    path.quadraticBezierTo(
      size.width * 0.5,
      0,
      size.width,
      30,
    );
    // Draw to bottom right
    path.lineTo(size.width, size.height);
    // Draw to bottom left
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
