import 'package:flutter/material.dart';
import '../models/app_models.dart';
import '../models/modules_data.dart';
import '../utils/theme_utils.dart';
import '../screens/module_1/module_one_screen.dart';
import '../screens/module_2/module_two_screen.dart';
import '../screens/module_5/index.dart';
import '../screens/module_6/index.dart';

// Language Chip Widget
class LanguageChip extends StatelessWidget {
  const LanguageChip({
    required this.language,
    required this.onLanguageChanged,
    this.dark = false,
    this.visible = false,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;
  final bool dark;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return PopupMenuButton<AppLanguage>(
      onSelected: onLanguageChanged,
      itemBuilder: (context) => const [
        PopupMenuItem(value: AppLanguage.english, child: Text('English')),
        PopupMenuItem(value: AppLanguage.hindi, child: Text('हिंदी')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: dark ? Colors.white.withValues(alpha: 0.14) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: 0.4)
                : const Color(0xFFD6E3F5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, size: 18, color: dark ? Colors.white : null),
            const SizedBox(width: 6),
            Text(
              language == AppLanguage.english ? 'English' : 'हिंदी',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: dark ? Colors.white : const Color(0xFF173C8A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ModuleSevenBanner extends StatelessWidget {
  const ModuleSevenBanner({
    super.key,
    required this.module,
    required this.language,
    required this.onTap,
  });

  final ModuleData module;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translated texts
    final badgeText = isEnglish ? 'Module 7' : 'मॉड्यूल 7';
    final titleText = isEnglish ? 'WARNING SIGNS' : 'चेतावनी के संकेत';
    final subtitleText = isEnglish ? '(When to Seek Help)' : '(कब सहायता लेनी चाहिए)';
    final descText = isEnglish
        ? 'It is important to recognize early warning signs\nto prevent serious complications.'
        : 'गंभीर समस्याओं से बचने के लिए शुरुआती चेतावनी\nसंकेतों को पहचानना महत्वपूर्ण है।';
    final highlightText = isEnglish
        ? 'If you notice these signs, do not ignore—\ntake action immediately.'
        : 'यदि आप इन संकेतों को देखते हैं, तो अनदेखा न करें—\nतुरंत कार्रवाई करें।';
    final cardTitle = isEnglish ? 'Why it’s Important?' : 'यह क्यों महत्वपूर्ण है?';
    final point1Text = isEnglish
        ? 'Early action can prevent\nserious complications.'
        : 'शुरुआती कार्रवाई गंभीर\nजटिलताओं को रोक सकती है।';
    final point2Text = isEnglish
        ? 'Your health and safety\nare our priority.'
        : 'आपका स्वास्थ्य और सुरक्षा\nहमारी प्राथमिकता है।';

    return Card(
      elevation: 4,
      shadowColor: const Color(0x120F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          child: AspectRatio(
            aspectRatio: 975 / 253, // Match reference aspect ratio exactly
            child: LayoutBuilder(
              builder: (context, constraints) {
                return FittedBox(
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 975,
                    height: 253,
                    child: Stack(
                      children: [
                        // Left Illustration (Worried Patient)
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: SizedBox(
                            width: 175,
                            height: 246,
                            child: Image.asset(
                              'assets/images/module7_patient.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                        
                        // Top Left Badge
                        Positioned(
                          left: 12,
                          top: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              badgeText,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),

                        // Middle Content
                        Positioned(
                          left: 150,
                          top: 12,
                          right: 340,
                          bottom: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Row with Warning Icon and Title/Subtitle
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 112,
                                    height: 88,
                                    child: Image.asset(
                                      'assets/images/module7_warning_triangle.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        titleText,
                                        style: const TextStyle(
                                          color: Color(0xFFD60000),
                                          fontSize: 34,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                      Text(
                                        subtitleText,
                                        style: const TextStyle(
                                          color: Color(0xFF1E3A8A),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                ],
                              ),
                              const SizedBox(height: 8),
                              
                              // Description
                              Text(
                                descText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFF1F2937),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  height: 1.25,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Highlight Box
                              Container(
                                width: 445,
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFDF0),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFFFFE082), width: 1.2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '“ ',
                                      style: TextStyle(
                                        color: Color(0xFFE65100),
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        highlightText,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2,
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      ' ”',
                                      style: TextStyle(
                                        color: Color(0xFFE65100),
                                        fontSize: 26,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Nurse Illustration
                        Positioned(
                          right: 215,
                          bottom: 0,
                          child: SizedBox(
                            width: 140,
                            height: 202,
                            child: Image.asset(
                              'assets/images/module7_nurse.png',
                              fit: BoxFit.contain,
                              alignment: Alignment.bottomRight,
                            ),
                          ),
                        ),

                        // Right Information Card
                        Positioned(
                          right: 12,
                          top: 12,
                          bottom: 12,
                          child: Container(
                            width: 215,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x060F172A),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cardTitle,
                                  style: const TextStyle(
                                    color: Color(0xFFD60000),
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Divider(color: Color(0xFFF1F5F9), height: 1),
                                const SizedBox(height: 10),
                                
                                // Point 1
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 41,
                                      height: 44,
                                      child: Image.asset(
                                        'assets/images/module7_shield.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        point1Text,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                
                                // Point 2
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Image.asset(
                                        'assets/images/module7_heart_hand.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        point2Text,
                                        style: const TextStyle(
                                          color: Color(0xFF1F2937),
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w700,
                                          height: 1.25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// Module Card Widget
class ModuleCard extends StatefulWidget {
  const ModuleCard({
    super.key,
    required this.module,
    required this.language,
    required this.onTap,
  });

  final ModuleData module;
  final AppLanguage language;
  final VoidCallback onTap;

  @override
  State<ModuleCard> createState() => _ModuleCardState();
}

class _ModuleCardState extends State<ModuleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSeven = widget.module.number == 7;
    final scale = _isPressed ? 0.95 : 1.0;
    final shadowBlur = _isPressed ? 28.0 : 18.0;
    final shadowOpacity = _isPressed ? 0.16 : 0.07;
    final shadowOffset = _isPressed ? const Offset(0, 12) : const Offset(0, 8);

    Widget artwork;
    if (isSeven) {
      artwork = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Center(
          child: Image.asset(
            'assets/images/module7_warning_triangle.png',
            fit: BoxFit.contain,
          ),
        ),
      );
    } else {
      artwork = _ModuleArtwork(module: widget.module);
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: Transform.scale(
        scale: scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFEAF0F8), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: const Color(0x120F172A).withValues(alpha: shadowOpacity),
                blurRadius: shadowBlur,
                offset: shadowOffset,
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
          child: Column(
            children: [
              Expanded(child: artwork),
              const SizedBox(height: 12),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.module.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.module.color.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  '${widget.module.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.module.title.value(widget.language),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Module Artwork Widget
class _ModuleArtwork extends StatelessWidget {
  const _ModuleArtwork({required this.module});

  final ModuleData module;

  @override
  Widget build(BuildContext context) {
    final isFirst = module.number == 1;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            module.color.withValues(alpha: 0.18),
            module.color.withValues(alpha: 0.05),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: EdgeInsets.all(isFirst ? 14 : 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                module.homeIconAsset,
                fit: isFirst ? BoxFit.contain : BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// Module Screen Widget
class ModuleScreen extends StatelessWidget {
  const ModuleScreen({
    super.key,
    required this.module,
    required this.language,
    required this.onLanguageChanged,
  });

  final ModuleData module;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final text = AppText(language);

    if (module.number == 1) {
      return ModuleOneScreen(
        module: module,
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }

    if (module.number == 2) {
      return ModuleTwoScreen(
        module: module,
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: module.color,
            foregroundColor: Colors.white,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                  dark: true,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          module.color.withValues(alpha: 0.92),
                          darken(module.color, 0.18),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 96,
                    child: Container(
                      width: 132,
                      height: 132,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(28),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.asset(
                        module.imageAsset,
                        fit: BoxFit.cover,
                        alignment: module.headerImageAlignment,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 100, 168, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '${text.module} ${module.number}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          module.title.value(language),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          module.subtitle.value(language),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoBanner(
                    color: module.color,
                    title: text.moduleOverview,
                    body: module.overview.value(language),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    text.lessons,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            sliver: SliverList.separated(
              itemCount: module.lessons.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final lesson = module.lessons[index];
                return _LessonTile(
                  number: index + 1,
                  color: lesson.color,
                  title: lesson.title.value(language),
                  subtitle: lesson.summary.value(language),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(
                          module: module,
                          lesson: lesson,
                          language: language,
                          onLanguageChanged: onLanguageChanged,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Lesson Screen Widget
class LessonScreen extends StatelessWidget {
  const LessonScreen({
    super.key,
    required this.module,
    required this.lesson,
    required this.language,
    required this.onLanguageChanged,
  });

  final ModuleData module;
  final LessonData lesson;
  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    print('DEBUG WIDGETS: LessonScreen build - module: ${module.number}, lesson: ${lesson.title.en}');
    if (module.number == 5 && (module.lessons.isEmpty || module.lessons.indexOf(lesson) == 0 || lesson.title.en.contains('Early Ambulation'))) {
      return ModuleFiveEarlyAmbulationScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 5 && (module.lessons.indexOf(lesson) == 1 || lesson.title.en.contains('Abdominal Strengthening'))) {
      return ModuleFiveAbdominalStrengtheningScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 5 && (module.lessons.indexOf(lesson) == 2 || lesson.title.en.contains('Hernia Prevention'))) {
      return ModuleFiveHerniaPreventionScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 5 && (module.lessons.indexOf(lesson) == 3 || lesson.title.en.contains('Lifting'))) {
      return ModuleFiveLiftingPrecautionsScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 5 && (module.lessons.indexOf(lesson) == 4 || lesson.title.en.contains('Timeline') || lesson.title.en.contains('Progression'))) {
      return ModuleFiveActivityTimelineScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 5 && (module.lessons.indexOf(lesson) == 5 || lesson.title.en.contains('Stop') || lesson.title.en.contains('Nurse'))) {
      return ModuleFiveStopExerciseScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 6 &&
        (lesson.title.en.toLowerCase().contains('travel tips') ||
         lesson.title.hi.contains('यात्रा के सुझाव'))) {
      return ModuleSixTravelTipsScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 6 &&
        (lesson.title.en.toLowerCase().contains('managing') ||
         lesson.title.en.toLowerCase().contains('long travel') ||
         lesson.title.hi.contains('लंबी यात्रा'))) {
      return ModuleSixManagingTravelScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 6 &&
        (lesson.title.en.toLowerCase().contains('clothing') ||
         lesson.title.hi.contains('कपड़ों के सुझाव'))) {
      return ModuleSixClothingTipsScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 6 &&
        (lesson.title.en.toLowerCase().contains('intimacy') ||
         lesson.title.hi.contains('निकटता और रिश्ते'))) {
      return ModuleSixIntimacyRelationshipsScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 6 &&
        (lesson.title.en.toLowerCase().contains('return to work') ||
         lesson.title.hi.contains('काम पर वापसी'))) {
      return ModuleSixReturnToWorkScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 6 &&
        (lesson.title.en.toLowerCase().contains('carrying supplies') ||
         lesson.title.en.toLowerCase().contains('supplies discreetly') ||
         lesson.title.hi.contains('सामान को गोपनीय'))) {
      return ModuleSixCarryingSuppliesScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 1 && module.lessons.indexOf(lesson) == 3) {
      return _ModuleOneLessonFourScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 2 && identical(lesson, module.lessons[2])) {
      return _ModuleTwoMeasuringGuideScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 0) {
      return _ModuleSevenLessonOneScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 1) {
      return _ModuleSevenLessonTwoScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 2) {
      return _ModuleSevenLessonThreeScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 3) {
      return _ModuleSevenLessonFourScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 4) {
      return _ModuleSevenLessonFiveScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 5) {
      return _ModuleSevenLessonSixScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 6) {
      return _ModuleSevenLessonSevenScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }
    if (module.number == 7 && module.lessons.indexOf(lesson) == 7) {
      return _ModuleSevenLessonEightScreen(
        language: language,
        onLanguageChanged: onLanguageChanged,
      );
    }

    final text = AppText(language);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title.value(language)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  lesson.color.withValues(alpha: 0.96),
                  darken(lesson.color, 0.18),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title.value(language),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        lesson.summary.value(language),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    module.imageAsset,
                    fit: BoxFit.cover,
                    alignment: module.lessonImageAlignment,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoBanner(
            color: lesson.color,
            title: text.quickSummary,
            body: lesson.summary.value(language),
          ),
          const SizedBox(height: 16),
          _TextCard(
            title: text.keyPoints,
            color: lesson.color,
            items: lesson.points.map((item) => item.value(language)).toList(),
          ),
          if (lesson.tips.isNotEmpty) ...[
            const SizedBox(height: 16),
            _TextCard(
              title: text.tips,
              color: const Color(0xFF2E7D32),
              items: lesson.tips.map((item) => item.value(language)).toList(),
              icon: Icons.lightbulb_outline,
            ),
          ],
          if (lesson.warnings.isNotEmpty) ...[
            const SizedBox(height: 16),
            _TextCard(
              title: text.caution,
              color: const Color(0xFFD84315),
              items: lesson.warnings
                  .map((item) => item.value(language))
                  .toList(),
              icon: Icons.warning_amber_rounded,
            ),
          ],
        ],
      ),
    );
  }
}

// Info Banner Widget
class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.color,
    required this.title,
    required this.body,
  });

  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}

// Text Card Widget
class _TextCard extends StatelessWidget {
  const _TextCard({
    required this.title,
    required this.color,
    required this.items,
    this.icon = Icons.check_circle_outline,
  });

  final String title;
  final Color color;
  final List<String> items;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(Icons.circle, size: 8, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(item, style: const TextStyle(fontSize: 15)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

// Lesson Tile Widget
class _LessonTile extends StatelessWidget {
  const _LessonTile({
    required this.number,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final int number;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.blueGrey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: color, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// Reference Lesson Tile Widget
class ReferenceLessonTile extends StatelessWidget {
  const ReferenceLessonTile({
    required this.number,
    required this.color,
    required this.title,
    required this.onTap,
  });

  final int number;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final referenceColor = switch (number) {
      1 => const Color(0xFF22B72E),
      2 => const Color(0xFF129BFF),
      3 => const Color(0xFF7B5CE8),
      4 => const Color(0xFFFF3B4F),
      5 => const Color(0xFFFFA515),
      6 => const Color(0xFF10AFC2),
      _ => color,
    };

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 8, 2),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: referenceColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: referenceColor.withValues(alpha: 0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: number == 6
                  ? const Icon(
                      Icons.water_drop_rounded,
                      color: Colors.white,
                      size: 23,
                    )
                  : Text(
                      '$number',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: number == 6 ? 15.2 : 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF171717),
                  height: 1.25,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: darken(referenceColor, 0.18),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}

// Module Two Lesson Tile Widget
class ModuleTwoLessonTile extends StatefulWidget {
  const ModuleTwoLessonTile({
    required this.number,
    required this.color,
    required this.title,
    required this.onTap,
  });

  final int number;
  final Color color;
  final String title;
  final VoidCallback onTap;

  @override
  State<ModuleTwoLessonTile> createState() => _ModuleTwoLessonTileState();
}

class _ModuleTwoLessonTileState extends State<ModuleTwoLessonTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          onTapDown: (_) {
            setState(() => _isPressed = true);
          },
          onTapCancel: () {
            setState(() => _isPressed = false);
          },
          onTapUp: (_) {
            setState(() => _isPressed = false);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFE8EEF3)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x11000000),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${widget.number}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF162E43),
                      height: 1.3,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: darken(widget.color, 0.18),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ModuleTwoMeasuringGuideOption extends StatelessWidget {
  const _ModuleTwoMeasuringGuideOption();

  static const _purple = Color(0xFF5A35C8);
  static const _ink = Color(0xFF25185D);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE7DDF8), width: 1.4),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x245A35C8),
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Text(
                    'Measuring Guide & Scissors',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _ink,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      height: 1.08,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 210,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _GuideColumn(
                    title: 'Measuring guide',
                    body: 'Helps check\nsize of stoma',
                    visual: CustomPaint(painter: _MeasuringGuidePainter()),
                  ),
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  color: const Color(0xFFE5E0EE),
                ),
                Expanded(
                  child: _GuideColumn(
                    title: 'Scissors',
                    body: 'Used to cut pouch\nopening to correct size',
                    visual: CustomPaint(painter: _ScissorsPainter()),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.lightbulb_outline_rounded, color: _purple, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Opening should fit closely - not too tight, not too loose.',
                  style: TextStyle(
                    color: _purple,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GuideColumn extends StatelessWidget {
  const _GuideColumn({
    required this.title,
    required this.body,
    required this.visual,
  });

  final String title;
  final String body;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: _ModuleTwoMeasuringGuideOption._purple,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          body,
          style: const TextStyle(
            color: _ModuleTwoMeasuringGuideOption._ink,
            fontSize: 13,
            fontWeight: FontWeight.w800,
            height: 1.35,
          ),
        ),
        const Spacer(),
        Align(
          alignment: Alignment.center,
          child: SizedBox(width: 135, height: 116, child: visual),
        ),
      ],
    );
  }
}

class _MeasuringGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.55, size.height * 0.48);
    final outline = Paint()
      ..color = const Color(0xFFD7D7D7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final mark = Paint()
      ..color = const Color(0xFF777777)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(center, size.width * 0.44, outline);
    for (final radius in [0.34, 0.27, 0.20]) {
      canvas.drawCircle(center, size.width * radius, mark);
    }
    canvas.drawCircle(center, size.width * 0.14, outline..strokeWidth = 2);
    canvas.drawCircle(center.translate(-size.width * 0.33, 0), 3.2, mark);
    canvas.drawCircle(center.translate(size.width * 0.33, 0), 3.2, mark);

    final labels = ['30', '40', '50', '60'];
    for (var i = 0; i < labels.length; i++) {
      final painter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xFF5D5D5D),
            fontSize: 7,
            fontWeight: FontWeight.w800,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      painter.paint(
        canvas,
        Offset(center.dx - painter.width / 2, center.dy - 45 + (i * 16)),
      );
    }
    final mm = TextPainter(
      text: const TextSpan(
        text: 'mm',
        style: TextStyle(
          color: Color(0xFF444444),
          fontSize: 7,
          fontWeight: FontWeight.w900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    mm.paint(canvas, Offset(center.dx - mm.width / 2, center.dy + 55));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScissorsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final steel = Paint()
      ..color = const Color(0xFFD8D8D8)
      ..style = PaintingStyle.fill;
    final edge = Paint()
      ..color = const Color(0xFF4B4B4B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final black = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final cutout = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final bladeTop = Path()
      ..moveTo(size.width * 0.46, size.height * 0.45)
      ..lineTo(size.width * 0.98, size.height * 0.17)
      ..lineTo(size.width * 0.55, size.height * 0.56)
      ..close();
    final bladeBottom = Path()
      ..moveTo(size.width * 0.50, size.height * 0.55)
      ..lineTo(size.width * 0.98, size.height * 0.18)
      ..lineTo(size.width * 0.61, size.height * 0.67)
      ..close();
    canvas.drawPath(bladeTop, steel);
    canvas.drawPath(bladeBottom, steel);
    canvas.drawPath(bladeTop, edge);
    canvas.drawPath(bladeBottom, edge);

    final handle = Path()
      ..moveTo(size.width * 0.48, size.height * 0.48)
      ..quadraticBezierTo(size.width * 0.28, size.height * 0.50,
          size.width * 0.18, size.height * 0.66)
      ..quadraticBezierTo(size.width * 0.03, size.height * 0.90,
          size.width * 0.30, size.height * 0.90)
      ..quadraticBezierTo(size.width * 0.46, size.height * 0.89,
          size.width * 0.53, size.height * 0.70)
      ..quadraticBezierTo(size.width * 0.58, size.height * 0.87,
          size.width * 0.76, size.height * 0.91)
      ..quadraticBezierTo(size.width * 0.98, size.height * 0.94,
          size.width * 0.91, size.height * 0.75)
      ..quadraticBezierTo(size.width * 0.84, size.height * 0.56,
          size.width * 0.59, size.height * 0.56)
      ..lineTo(size.width * 0.60, size.height * 0.42)
      ..quadraticBezierTo(size.width * 0.54, size.height * 0.47,
          size.width * 0.48, size.height * 0.48)
      ..close();
    canvas.drawPath(handle, black);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.24, size.height * 0.75),
        width: size.width * 0.26,
        height: size.height * 0.20,
      ),
      cutout,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.72, size.height * 0.76),
        width: size.width * 0.28,
        height: size.height * 0.20,
      ),
      cutout,
    );
    canvas.drawCircle(Offset(size.width * 0.61, size.height * 0.47), 4, edge);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ModuleTwoMeasuringGuideScreen extends StatelessWidget {
  const _ModuleTwoMeasuringGuideScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FC),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
          children: [
            Row(
              children: [
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(),
                  elevation: 1,
                  shadowColor: Colors.black12,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Color(0xFF5A35C8),
                        size: 18,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                LanguageChip(
                  language: language,
                  onLanguageChanged: onLanguageChanged,
                ),
              ],
            ),
            const SizedBox(height: 18),
            const _ModuleTwoMeasuringGuideOption(),
          ],
        ),
      ),
    );
  }
}

// Quick Tips Tile Widget
class QuickTipsTile extends StatefulWidget {
  const QuickTipsTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  State<QuickTipsTile> createState() => _QuickTipsTileState();
}

class _QuickTipsTileState extends State<QuickTipsTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: Material(
        color: const Color(0xFFEFF7EE),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapCancel: () => setState(() => _isPressed = false),
          onTapUp: (_) => setState(() => _isPressed = false),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFF7EE),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD4E8D8)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x22000000),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.lightbulb_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF2E7D32),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: darken(const Color(0xFF2E7D32), 0.22),
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Module Two Navigation Bar Widget
class ModuleTwoNavigationBar extends StatelessWidget {
  const ModuleTwoNavigationBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -10),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            active: false,
          ),
          _NavItem(
            label: 'Learn',
            icon: Icons.menu_book_rounded,
            active: true,
          ),
          _NavItem(
            label: 'Care Tips',
            icon: Icons.health_and_safety_outlined,
            active: false,
          ),
          _NavItem(
            label: 'Community',
            icon: Icons.people_outline,
            active: false,
          ),
          _NavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            active: false,
          ),
        ],
      ),
    );
  }
}

// Navigation Item Widget
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.active,
  });

  final String label;
  final IconData icon;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final iconColor = active ? Colors.white : const Color(0xFF4B5563);
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: active ? const Color(0xFF2E7D32) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: active ? const Color(0xFF2E7D32) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

// Stoma Care Kit Illustration Widget
class StomaCareKitIllustration extends StatelessWidget {
  const StomaCareKitIllustration();

  final double width = 150;
  final double height = 210;
  final bool showShadow = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Green care kit bag
          Container(
            width: 95,
            height: 85,
            margin: const EdgeInsets.only(left: 20, top: 35),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(2, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Color(0xFF2E7D32),
                  size: 22,
                ),
              ),
            ),
          ),
          // Pouch 1 (beige/tan)
          Positioned(
            left: 5,
            top: 10,
            child: Container(
              width: 48,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFFF5DEB3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFD2B48C), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 6,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDEB887),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF8B7355), width: 1),
                  ),
                ),
              ),
            ),
          ),
          // Pouch 2 (beige)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              width: 42,
              height: 52,
              decoration: BoxDecoration(
                color: const Color(0xFFEAD9C3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFC9B8A0), width: 1),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCDB8A0),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF9B8B7B), width: 0.8),
                  ),
                ),
              ),
            ),
          ),
          // White bottle
          Positioned(
            right: 18,
            top: 15,
            child: Container(
              width: 22,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 4,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 8,
                    height: 6,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC0C0C0),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F4F8),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Blue wipes box
          Positioned(
            bottom: 25,
            left: 30,
            child: Container(
              width: 50,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: BorderRadius.circular(4),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x20000000),
                    blurRadius: 5,
                    offset: Offset(1, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'WIPES',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          // Scissors
          Positioned(
            bottom: 20,
            right: 10,
            child: Transform.rotate(
              angle: -0.5,
              child: Icon(
                Icons.content_cut_rounded,
                color: const Color(0xFFB0BEC5),
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Export all widgets

class _ModuleSevenLessonOneScreen extends StatelessWidget {
  const _ModuleSevenLessonOneScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Stoma-Related Changes' : 'स्टोमा से संबंधित परिवर्तन';
    
    final sign1Text = isEnglish 
        ? 'Stoma becomes black, pale, bluish, or dark' 
        : 'स्टोमा काला, फीका, नीला या गहरा रंग का हो जाए';
        
    final sign2Text = isEnglish 
        ? 'Sudden change in size or shape' 
        : 'आकार या आकृति में अचानक परिवर्तन';
        
    final sign3Text = isEnglish 
        ? 'Continuous or heavy bleeding from stoma' 
        : 'स्टोमा से लगातार या अधिक रक्तस्राव';
        
    final alertText = isEnglish 
        ? 'Any change in your stoma should never be ignored.' 
        : 'स्टोमा में किसी भी परिवर्तन को कभी नजरअंदाज न करें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD60000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '1',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFFD60000),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 20),
                
                // Warning Sign 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        'assets/images/module7_stoma_colors.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 20),
                
                // Warning Sign 2
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        'assets/images/module7_stoma_size_shape.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 20),
                
                // Warning Sign 3
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 6,
                      child: Image.asset(
                        'assets/images/module7_stoma_bleeding.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 28),
                
                // Bottom Emergency Alert Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6F6),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFEE2E2), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD60000),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFFD60000),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
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
      ),
    );
  }
}

class _ModuleSevenLessonTwoScreen extends StatelessWidget {
  const _ModuleSevenLessonTwoScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Output Problems' : 'आउटपुट संबंधी समस्याएँ';
    
    final sign1Text = isEnglish 
        ? 'No output for a long time (especially with pain)' 
        : 'लंबे समय तक आउटपुट न आना (विशेषकर दर्द के साथ)';
        
    final sign2Text = isEnglish 
        ? 'Sudden decrease in output' 
        : 'आउटपुट में अचानक कमी';
        
    final sign3Text = isEnglish 
        ? 'Excessive watery output (diarrhea)' 
        : 'अत्यधिक पतला/पानी जैसा आउटपुट (दस्त)';
        
    final alertText = isEnglish 
        ? 'Call your nurse if output is not normal.' 
        : 'यदि आउटपुट सामान्य नहीं है तो अपनी नर्स से संपर्क करें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF57C00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFFF57C00),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_output_no_output.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_output_decrease.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_output_watery.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x66FFD54F), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFF57C00),
                        size: 32,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFFD84315),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
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
      ),
    );
  }
}

class _ModuleSevenLessonThreeScreen extends StatelessWidget {
  const _ModuleSevenLessonThreeScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Signs of Dehydration' : 'निर्जलीकरण के संकेत';
    
    final sign1Text = isEnglish 
        ? 'Dry mouth' 
        : 'मुंह सूखना';
        
    final sign2Text = isEnglish 
        ? 'Reduced urine' 
        : 'पेशाब कम होना';
        
    final sign3Text = isEnglish 
        ? 'Weakness or dizziness' 
        : 'कमजोरी या चक्कर आना';
        
    final alertText = isEnglish 
        ? 'Drink plenty of fluids and seek help if symptoms continue.' 
        : 'पर्याप्त तरल पदार्थ पिएं और लक्षण बने रहने पर सहायता लें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/module7_dehydration_droplet.png',
                      width: 28,
                      height: 28,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Dry mouth)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_dehydration_dry_mouth.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Reduced urine)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_dehydration_urine.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3 (Weakness/Dizziness)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_dehydration_dizzy.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Hydration Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF7FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x662196F3), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/module7_dehydration_droplet.png',
                        width: 26,
                        height: 26,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            height: 1.3,
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
      ),
    );
  }
}

class _ModuleSevenLessonFourScreen extends StatelessWidget {
  const _ModuleSevenLessonFourScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Skin Problems\nAround Stoma' : 'स्टोमा के आसपास\nत्वचा संबंधी समस्याएँ';
    
    final sign1Text = isEnglish 
        ? 'Redness, rash, or irritation' 
        : 'लालिमा, चकत्ते या जलन';
        
    final sign2Text = isEnglish 
        ? 'Swelling or pain' 
        : 'सूजन या दर्द';
        
    final sign3Text = isEnglish 
        ? 'Pus or discharge' 
        : 'मवाद या स्राव';
        
    final alertText = isEnglish 
        ? 'Keep the area clean and dry.\nContact nurse if problem persists.' 
        : 'क्षेत्र को साफ और सूखा रखें।\nसमस्या बनी रहे तो नर्स से संपर्क करें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '4',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Redness)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_skin_redness.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Swelling)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_skin_swelling.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3 (Discharge)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_skin_discharge.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Care Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF8EE),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x6643A047), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/module7_shield.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
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
        ),
      ),
    );
  }
}

class _ModuleSevenLessonFiveScreen extends StatelessWidget {
  const _ModuleSevenLessonFiveScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Pain & Discomfort' : 'दर्द और असुविधा';
    
    final sign1Text = isEnglish 
        ? 'Persistent abdominal pain' 
        : 'लगातार पेट दर्द';
        
    final sign2Text = isEnglish 
        ? 'Pain around stoma site' 
        : 'स्टोमा के आसपास दर्द';
        
    final alertText = isEnglish 
        ? 'Do not ignore ongoing pain.\nGet it checked.' 
        : 'लगातार दर्द को नजरअंदाज न करें।\nइसकी जांच करवाएं।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3F51B5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF3F51B5),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Persistent abdominal pain)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_pain_patient.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Pain around stoma site)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_pain_stoma.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x665C6BC0), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF5C6BC0),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF3F51B5),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
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
        ),
      ),
    );
  }
}

class _ModuleSevenLessonSixScreen extends StatelessWidget {
  const _ModuleSevenLessonSixScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Signs of Infection' : 'संक्रमण के संकेत';
    
    final sign1Text = isEnglish 
        ? 'Fever' 
        : 'बुखार';
        
    final sign2Text = isEnglish 
        ? 'Warmth or swelling around stoma' 
        : 'स्टोमा के आसपास गर्माहट या सूजन';
        
    final sign3Text = isEnglish 
        ? 'Foul-smelling discharge' 
        : 'दुर्गंधयुक्त स्राव';
        
    final alertText = isEnglish 
        ? 'Infection can get serious.\nSeek help early.' 
        : 'संक्रमण गंभीर हो सकता है।\nसमय रहते सहायता लें।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00796B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '6',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF00796B),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/module7_infection_germ.png',
                      width: 32,
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 1 (Fever)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_infection_thermometer.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign1Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 2 (Warmth or swelling)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_infection_warmth.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign2Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFEAEAEA), height: 1, thickness: 1.5),
                const SizedBox(height: 16),
                
                // Warning Sign 3 (Foul discharge)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Image.asset(
                        'assets/images/module7_infection_discharge.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 6,
                      child: Text(
                        sign3Text,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF9F8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x6600897B), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/module7_shield.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF00796B),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
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
        ),
      ),
    );
  }
}

class _ModuleSevenLessonSevenScreen extends StatelessWidget {
  const _ModuleSevenLessonSevenScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Gastrointestinal Symptoms' : 'जठरांत्र संबंधी लक्षण';
    
    final sign1Text = isEnglish 
        ? 'Nausea\nor vomiting' 
        : 'मतली या उल्टी';
        
    final sign2Text = isEnglish 
        ? 'Abdominal bloating\nor swelling' 
        : 'पेट फूलना या सूजन';
        
    final alertText = isEnglish 
        ? 'These symptoms can lead to dehydration and other complications.' 
        : 'ये लक्षण निर्जलीकरण और अन्य जटिलताओं का कारण बन सकते हैं।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '7',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        headerTitle,
                        style: const TextStyle(
                          color: Color(0xFF1565C0),
                          fontSize: 23,
                          fontWeight: FontWeight.w900,
                          height: 1.15,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Symptom Two-Column Layout
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left Column: Nausea
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/module7_gi_nausea.png',
                              height: 140,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              sign1Text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        color: Color(0xFFEAEAEA),
                        thickness: 1.5,
                        width: 24,
                      ),
                      // Right Column: Bloating
                      Expanded(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/module7_gi_bloating.png',
                              height: 140,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              sign2Text,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF6FF),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0x661E88E5), width: 1.5),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1E88E5),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          '!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
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
        ),
      ),
    );
  }
}

class _ModuleSevenLessonEightScreen extends StatelessWidget {
  const _ModuleSevenLessonEightScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final headerTitle = isEnglish ? 'Emergency Signs (Do NOT Delay)' : 'आपातकालीन संकेत (देरी न करें)';
    
    // Left card
    final leftHeader = isEnglish 
        ? 'Go to hospital\nIMMEDIATELY if you have:' 
        : 'यदि आपको ये लक्षण हैं तो तुरंत अस्पताल जाएँ:';
    final leftItem1 = isEnglish ? 'Black or pale stoma' : 'काला या फीका स्टोमा';
    final leftItem2 = isEnglish ? 'No output +\nsevere pain' : 'आउटपुट न होना +\nगंभीर दर्द';
    final leftItem3 = isEnglish ? 'Heavy bleeding' : 'अत्यधिक रक्तस्राव';
    final leftItem4 = isEnglish ? 'Persistent vomiting' : 'लगातार उल्टी';
    
    // Right card
    final rightHeader = isEnglish 
        ? 'Contact nurse\nIMMEDIATELY if you have:' 
        : 'यदि आपको ये लक्षण हैं तो तुरंत नर्स से संपर्क करें:';
    final rightItem1 = isEnglish ? 'Color change\nin stoma' : 'स्टोमा के रंग में बदलाव';
    final rightItem2 = isEnglish ? 'No output /\nexcessive output' : 'आउटपुट न होना /\nअत्यधिक आउटपुट';
    final rightItem3 = isEnglish ? 'Skin irritation\nor infection' : 'त्वचा में जलन या संक्रमण';
    final rightItem4 = isEnglish ? 'Severe pain\nor vomiting' : 'गंभीर दर्द या उल्टी';
    
    // Bottom banner
    final alertText = isEnglish 
        ? "When in doubt, ask for help. It's always better to be safe." 
        : 'संदेह होने पर सहायता लें। सुरक्षित रहना हमेशा बेहतर है।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFEAEAEA), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0C000000),
                  blurRadius: 16,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD50000),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '8',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          Text(
                            headerTitle,
                            style: const TextStyle(
                              color: Color(0xFFD50000),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              height: 1.15,
                            ),
                          ),
                          Image.asset(
                            'assets/images/module7_emergency_siren.png',
                            width: 32,
                            height: 32,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Three-Column Layout
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left Card (Red)
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFD50000), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFD50000),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Text(
                                  leftHeader,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    // Row 1
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l1_black_stoma.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem1,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 2
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l2_no_output.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem2,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 3
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l3_blood.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem3,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 4
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_l4_vomit.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            leftItem4,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
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
                      const SizedBox(width: 8),
                      // Center Panel (Hospital & Cross)
                      Expanded(
                        flex: 3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/module7_emergency_arrow_left.png',
                                  width: 14,
                                  height: 14,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 4),
                                Image.asset(
                                  'assets/images/module7_emergency_cross.png',
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 4),
                                Image.asset(
                                  'assets/images/module7_emergency_arrow_right.png',
                                  width: 14,
                                  height: 14,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Image.asset(
                              'assets/images/module7_emergency_hospital.png',
                              width: 84,
                              height: 84,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Right Card (Orange)
                      Expanded(
                        flex: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF57C00), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF57C00),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(14),
                                    topRight: Radius.circular(14),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                                child: Text(
                                  rightHeader,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    height: 1.25,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Column(
                                  children: [
                                    // Row 1
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r1_color_change.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem1,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 2
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r2_excessive.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem2,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 3
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r3_infection.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem3,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Row 4
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/module7_emergency_r4_pain.png',
                                          width: 36,
                                          height: 36,
                                          fit: BoxFit.contain,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            rightItem4,
                                            style: const TextStyle(
                                              color: Color(0xFF111827),
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              height: 1.2,
                                            ),
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
                
                const SizedBox(height: 24),
                
                // Bottom Warning Banner
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD50000),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          alertText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
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
      ),
    );
  }
}

class _ModuleOneLessonFourScreen extends StatelessWidget {
  const _ModuleOneLessonFourScreen({
    required this.language,
    required this.onLanguageChanged,
  });

  final AppLanguage language;
  final ValueChanged<AppLanguage> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final isEnglish = language == AppLanguage.english;

    // Translatable texts
    final bannerTitle = isEnglish ? '4. NORMAL APPEARANCE OF STOMA' : '4. स्टोमा का सामान्य स्वरूप';
    final introText = isEnglish ? 'A healthy stoma should look like:' : 'एक स्वस्थ स्टोमा ऐसा दिखना चाहिए:';

    final colorTitle = isEnglish ? 'COLOR' : 'रंग';
    final colorBody = isEnglish ? 'Pink to red' : 'गुलाबी से लाल';
    final colorSub = isEnglish ? '(like inside of your mouth)' : '(मुंह के अंदर की तरह)';

    final textureTitle = isEnglish ? 'TEXTURE' : 'बनावट';
    final textureBody = isEnglish ? 'Moist and shiny' : 'नम और चमकदार';

    final shapeTitle = isEnglish ? 'SHAPE / SIZE' : 'आकार';
    final shapeBody = isEnglish ? 'Round or oval' : 'गोल या अंडाकार';
    final shapeSub = isEnglish ? '(may be slightly swollen after surgery)' : '(सर्जरी के बाद हल्की सूजन हो सकती है)';

    final warningText = isEnglish ? 'Small bleeding while cleaning is normal.' : 'सफाई करते समय थोड़ा रक्तस्राव सामान्य है।';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF10164F)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LanguageChip(
              language: language,
              onLanguageChanged: onLanguageChanged,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Header Pink Gradient Banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF26885), Color(0xFFE24063)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x19E24063),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                alignment: Alignment.center,
                child: Text(
                  bannerTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 2. Intro Text
              Text(
                introText,
                style: const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              
              const SizedBox(height: 10),
              
              // 3. Decorative Pink Divider
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: Color(0xFFF6C3CD), thickness: 1.5, endIndent: 8),
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE84D73),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: Color(0xFFF6C3CD), thickness: 1.5, indent: 8),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // 4. Two-Column Layout (Realistic Stoma on left, stacked cards on right)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left Column: Stoma Image (with lines extending to right)
                  Expanded(
                    flex: 11,
                    child: Image.asset(
                      'assets/images/module1_normal_stoma.png',
                      height: 360,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                    ),
                  ),
                  
                  const SizedBox(width: 8),
                  
                  // Right Column: Stacked Cards Column
                  Expanded(
                    flex: 12,
                    child: SizedBox(
                      height: 360,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 36),
                          
                          // Card 1: Color (height 84)
                          Container(
                            height: 84,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/module1_normal_color_icon.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        colorTitle,
                                        style: const TextStyle(
                                          color: Color(0xFFE84D73),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        colorBody,
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Text(
                                        colorSub,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 26),
                          
                          // Card 2: Texture (height 84)
                          Container(
                            height: 84,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/module1_normal_texture_icon.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        textureTitle,
                                        style: const TextStyle(
                                          color: Color(0xFF4A90E2),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        textureBody,
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 26),
                          
                          // Card 3: Shape / Size (height 104)
                          Container(
                            height: 104,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x08000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/module1_normal_shape_icon.png',
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        shapeTitle,
                                        style: const TextStyle(
                                          color: Color(0xFF63B45F),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        shapeBody,
                                        style: const TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        shapeSub,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          height: 1.15,
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
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // 5. Bottom Warning Banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF8EF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFF0E0E0), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x05000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/module1_normal_warning.png',
                      width: 44,
                      height: 44,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        warningText,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Image.asset(
                      'assets/images/module1_normal_gauze.png',
                      width: 68,
                      height: 68,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





