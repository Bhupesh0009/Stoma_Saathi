import 'package:flutter/material.dart';
import '../../models/app_models.dart';
import '../../models/modules_data.dart';
import '../../widgets/index.dart';

class ModuleTwoScreen extends StatelessWidget {
  const ModuleTwoScreen({
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

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FB),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.white,
                          shape: const CircleBorder(),
                          elevation: 2,
                          shadowColor: Colors.black12,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(26),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                color: Color(0xFF2E7D32),
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          '${text.module} ${module.number}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFE8F1F5)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x11000000),
                            blurRadius: 24,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 20, 18, 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  module.title.value(language),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF162E43),
                                    height: 1.1,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  module.subtitle.value(language),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    height: 1.6,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF5F6B7B),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F8F4),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: Text(
                                    language == AppLanguage.english
                                        ? 'Learn about the essential items for daily stoma care.'
                                        : 'रोज़ की स्टोमा देखभाल के लिए आवश्यक वस्तुओं के बारे में जानें।',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF2E7D32),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        language == AppLanguage.english
                                            ? '0% Completed'
                                            : '0% पूरा हुआ',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF475569),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: const LinearProgressIndicator(
                                    value: 0,
                                    minHeight: 7,
                                    backgroundColor: Color(0xFFE9F5ED),
                                    color: Color(0xFF2E7D32),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          SizedBox(
                            width: 136,
                            height: 150,
                            child: StomaCareKitIllustration(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),
                    Column(
                      children: [
                        for (var i = 0; i < module.lessons.length; i++) ...[
                          ModuleTwoLessonTile(
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
                          const SizedBox(height: 16),
                        ],
                        QuickTipsTile(
                          title: language == AppLanguage.english
                              ? 'Quick Help'
                              : 'त्वरित सहायता',
                          subtitle: language == AppLanguage.english
                              ? 'Need assistance? Call your nurse or check daily reminders.'
                              : 'सहायता चाहिए? अपनी नर्स को कॉल करें या दैनिक अनुस्मारक देखें।',
                          onTap: () {
                            // Add navigation to Quick Tips if needed
                          },
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
  }
}