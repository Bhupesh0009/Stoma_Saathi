import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/modules_data.dart';
import '../../widgets/index.dart';

class ModuleOneScreen extends StatelessWidget {
  const ModuleOneScreen({
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
    const showProgress = true;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 18),
          children: [
            Row(
              children: [
                Image.asset('assets/images/logo.jpg', width: 36, height: 36),
                const SizedBox(width: 8),
                Text(
                  text.appName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF087329),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, right: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${text.module} ${module.number}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF151D67),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          module.title.value(language),
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF11195D),
                            height: 1.12,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          module.subtitle.value(language),
                          style: const TextStyle(
                            fontSize: 13,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF171717),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 146,
                  height: 186,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/images/module1_header_person.jpg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            if (showProgress) ...[
              const SizedBox(height: 12),
              const SizedBox.shrink(),
              Text(
                language == AppLanguage.english
                    ? '0% Completed'
                    : '0% पूरा हुआ',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 18),
            ],
            for (var i = 0; i < module.lessons.length; i++) ...[
              ReferenceLessonTile(
                number: i + 1,
                color: module.lessons[i].color,
                title: module.lessons[i].title.value(language),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        module: module,
                        lesson: module.lessons[i],
                        language: language,
                        onLanguageChanged: onLanguageChanged,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 18),
            ],
          ],
        ),
      ),
    );
  }
}