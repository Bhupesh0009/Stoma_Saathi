import 'package:flutter/material.dart';

enum AppLanguage { english, hindi }

class LocalizedText {
  const LocalizedText(this.en, this.hi);

  final String en;
  final String hi;

  String value(AppLanguage language) {
    return language == AppLanguage.english ? en : hi;
  }
}

class LessonData {
  const LessonData({
    required this.title,
    required this.summary,
    required this.points,
    required this.color,
    this.tips = const [],
    this.warnings = const [],
  });

  final LocalizedText title;
  final LocalizedText summary;
  final List<LocalizedText> points;
  final List<LocalizedText> tips;
  final List<LocalizedText> warnings;
  final Color color;
}

class ModuleData {
  const ModuleData({
    required this.number,
    required this.color,
    required this.icon,
    required this.homeIconAsset,
    required this.title,
    required this.subtitle,
    required this.overview,
    required this.imageAsset,
    required this.cardImageAlignment,
    required this.headerImageAlignment,
    required this.lessonImageAlignment,
    required this.lessons,
  });

  final int number;
  final Color color;
  final IconData icon;
  final String homeIconAsset;
  final LocalizedText title;
  final LocalizedText subtitle;
  final LocalizedText overview;
  final String imageAsset;
  final Alignment cardImageAlignment;
  final Alignment headerImageAlignment;
  final Alignment lessonImageAlignment;
  final List<LessonData> lessons;
}

class AppText {
  const AppText(this.language);

  final AppLanguage language;

  String get appName =>
      language == AppLanguage.english ? 'Stoma Saathi' : 'स्टोमा साथी';
  String get tagline => language == AppLanguage.english
      ? 'Care • Confidence • Companion'
      : 'देखभाल • आत्मविश्वास • साथ';
  String get homeWelcome => language == AppLanguage.english
      ? 'Learn with confidence'
      : 'आत्मविश्वास के साथ सीखें';
  String get homeSubtitle => language == AppLanguage.english
      ? 'Easy stoma education, daily care guidance, warning signs and support in one place.'
      : 'स्टोमा की जानकारी, रोज़ की देखभाल, चेतावनी संकेत और सहायता एक ही जगह पर।';
  String get navHome => language == AppLanguage.english ? 'Home' : 'होम';
  String get navLearn => language == AppLanguage.english ? 'Learn' : 'सीखें';
  String get navCareTips =>
      language == AppLanguage.english ? 'Care Tips' : 'केयर टिप्स';
  String get navSupport =>
      language == AppLanguage.english ? 'Support' : 'सहायता';
  String get module => language == AppLanguage.english ? 'Module' : 'मॉड्यूल';
  String get moduleOverview =>
      language == AppLanguage.english ? 'Module Overview' : 'मॉड्यूल परिचय';
  String get lessons => language == AppLanguage.english ? 'Lessons' : 'पाठ';
  String get quickSummary =>
      language == AppLanguage.english ? 'Quick Summary' : 'संक्षिप्त सार';
  String get keyPoints =>
      language == AppLanguage.english ? 'Key Points' : 'मुख्य बिंदु';
  String get tips =>
      language == AppLanguage.english ? 'Helpful Tips' : 'उपयोगी सुझाव';
  String get caution => language == AppLanguage.english ? 'Caution' : 'सावधानी';

  String get drawerHome => language == AppLanguage.english ? 'Home' : 'होम';
  String get drawerModule1 => language == AppLanguage.english ? 'Module 1' : 'मॉड्यूल 1';
  String get drawerModule2 => language == AppLanguage.english ? 'Module 2' : 'मॉड्यूल 2';
  String get drawerModule3 => language == AppLanguage.english ? 'Module 3' : 'मॉड्यूल 3';
  String get drawerModule4 => language == AppLanguage.english
      ? 'Module 4 – Diet & Nutrition'
      : 'मॉड्यूल 4 – आहार और पोषण';
  String get drawerModule5 => language == AppLanguage.english
      ? 'Module 5 – Exercise & Recovery'
      : 'मॉड्यूल 5 – व्यायाम और रिकवरी';
  String get drawerModule6 => language == AppLanguage.english
      ? 'Module 6 – Travel & Lifestyle'
      : 'मॉड्यूल 6 – यात्रा और जीवनशैली';
  String get drawerModule7 => language == AppLanguage.english
      ? 'Module 7 – Warning Signs'
      : 'मॉड्यूल 7 – चेतावनी संकेत';
  String get drawerModule8 => language == AppLanguage.english
      ? 'Module 8 – Quick Help & Support'
      : 'मॉड्यूल 8 – त्वरित सहायता और समर्थन';
  String get drawerLogout => language == AppLanguage.english ? 'Logout' : 'लॉगआउट';
  String get loginCardTitle => language == AppLanguage.english ? 'Login to your account' : 'अपने खाते में लॉगिन करें';
  String get logoutSnackbar => language == AppLanguage.english ? 'Logged out successfully!' : 'लॉगआउट सफल रहा!';
  String get quickHelp => language == AppLanguage.english ? 'Quick Help' : 'त्वरित सहायता';
  String get needAssistance => language == AppLanguage.english ? 'Need Assistance?' : 'सहायता चाहिए?';
  String get callYourNurse => language == AppLanguage.english ? 'Call Your Nurse' : 'अपनी नर्स से संपर्क करें';
  String get emergencyContact => language == AppLanguage.english ? 'Emergency Contact' : 'आपातकालीन संपर्क';
  String get importantReminder => language == AppLanguage.english ? 'Important Reminder' : 'महत्वपूर्ण अनुस्मारक';

  // About App Screen Localizations
  String get aboutAppTitle => language == AppLanguage.english ? 'About the App' : 'ऐप के बारे में';
  String get aboutAppSubtitle => language == AppLanguage.english ? 'Your Companion in Self-Care' : 'स्व-देखभाल में आपका साथी';
  String get aboutDescription1 => language == AppLanguage.english 
      ? 'Stoma Saathi is an educational mobile application designed to help intestinal ostomy patients learn and practice self-care easily.' 
      : 'स्टोमा साथी एक शैक्षणिक मोबाइल एप्लिकेशन है जिसे आंतों के ऑस्टोमी रोगियों को स्वयं की देखभाल सीखने और उसका अभ्यास करने में सहायता के लिए विकसित किया गया है।';
  String get aboutDescription2 => language == AppLanguage.english
      ? 'It provides information on stoma care, pouch management, skin care, diet, activities, warning signs and emotional well-being through simple text and demonstration videos.'
      : 'यह स्टोमा देखभाल, पाउच प्रबंधन, त्वचा की देखभाल, आहार, गतिविधियाँ, चेतावनी संकेत तथा भावनात्मक स्वास्थ्य से संबंधित जानकारी सरल पाठ और प्रदर्शन वीडियो के माध्यम से प्रदान करता है।';
  String get aboutDevTitle => language == AppLanguage.english ? 'DEVELOPED BY' : 'विकसित किया गया';
  String get aboutDevName => language == AppLanguage.english ? 'Ms. Anjali' : 'सुश्री अंजलि';
  String get aboutDevDegree => language == AppLanguage.english ? 'MSc Nursing (Oncological Nursing)' : 'एमएससी नर्सिंग (ऑन्कोलॉजिकल नर्सिंग)';
  String get aboutDevInst => language == AppLanguage.english ? 'College of Nursing, AIIMS New Delhi' : 'कॉलेज ऑफ नर्सिंग, एम्स नई दिल्ली';
  String get aboutGuidanceTitle => language == AppLanguage.english ? 'ACADEMIC GUIDANCE' : 'शैक्षणिक मार्गदर्शन';
  String get aboutGuidanceText => language == AppLanguage.english ? 'Under the guidance of Faculty,' : 'फैकल्टी के मार्गदर्शन में,';
  String get aboutGuidanceInst => language == AppLanguage.english ? 'College of Nursing, AIIMS New Delhi' : 'कॉलेज ऑफ नर्सिंग, एम्स नई दिल्ली';
  String get aboutValidationTitle => language == AppLanguage.english ? 'CONTENT VALIDATION' : 'सामग्री सत्यापन';
  String get aboutValidationText => language == AppLanguage.english 
      ? 'The educational content of Stoma Saathi has been reviewed and validated by experts in stoma care and oncology departments to ensure accuracy and patient suitability.' 
      : 'स्टोमा साथी की शैक्षणिक सामग्री की समीक्षा और सत्यापन स्टोमा देखभाल तथा ऑन्कोलॉजी विशेषज्ञों द्वारा किया गया है ताकि इसकी सटीकता और रोगी उपयुक्तता सुनिश्चित की जा सके।';
  String get aboutSupportText1 => language == AppLanguage.english ? 'You are not alone in this journey.' : 'आप इस यात्रा में अकेले नहीं हैं।';
  String get aboutSupportText2 => language == AppLanguage.english ? 'Stoma Saathi is here to support you.' : 'स्टोमा साथी आपकी सहायता के लिए हमेशा साथ है।';

  // Disclaimer Screen Localizations
  String get disclaimerTitle => language == AppLanguage.english ? 'Disclaimer' : 'अस्वीकरण';
  String get disclaimerImportantNotice => language == AppLanguage.english ? 'IMPORTANT NOTICE' : 'महत्वपूर्ण सूचना';
  String get seekMedicalHelp => language == AppLanguage.english ? 'SEEK MEDICAL HELP IF YOU HAVE' : 'यदि आपको ये लक्षण हों तो तुरंत चिकित्सा सहायता लें';
  String get footerText => language == AppLanguage.english
      ? 'Your health and safety are important. When in doubt, always consult your healthcare provider.'
      : 'आपका स्वास्थ्य और सुरक्षा महत्वपूर्ण हैं। संदेह होने पर हमेशा अपने स्वास्थ्य सेवा प्रदाता से सलाह लें।';

  String get disclaimerNotice1Part1 => language == AppLanguage.english ? 'The information provided in Stoma Saathi is for ' : 'स्टोमा साथी में प्रदान की गई जानकारी केवल ';
  String get disclaimerNotice1Highlight => language == AppLanguage.english ? 'educational and self-care support' : 'शिक्षा और स्व-देखभाल सहायता';
  String get disclaimerNotice1Part2 => language == AppLanguage.english ? ' purposes only.' : ' के उद्देश्य से है।';

  String get disclaimerNotice2Part1 => language == AppLanguage.english ? 'This application ' : 'यह एप्लिकेशन ';
  String get disclaimerNotice2Highlight => language == AppLanguage.english ? 'does not replace' : 'चिकित्सा सलाह, निदान या उपचार का विकल्प नहीं है';
  String get disclaimerNotice2Part2 => language == AppLanguage.english 
      ? ' medical advice, diagnosis, or treatment provided by doctors, nurses, or healthcare professionals.' 
      : ' डॉक्टरों, नर्सों या स्वास्थ्य विशेषज्ञों द्वारा दी जाने वाली।';

  String get disclaimerNotice3Part1 => language == AppLanguage.english
      ? 'Patients are advised to follow the instructions given by their treating doctor or stoma nurse. If you experience '
      : 'रोगियों को अपने चिकित्सक या स्टोमा नर्स द्वारा दिए गए निर्देशों का पालन करना चाहिए। यदि आपको ';
  String get disclaimerNotice3Part2 => language == AppLanguage.english
      ? ', please contact your healthcare provider or visit the hospital immediately.'
      : ' दिखाई दें, तो तुरंत अपने स्वास्थ्य सेवा प्रदाता से संपर्क करें या अस्पताल जाएँ।';

  String get supportMessagePart1 => language == AppLanguage.english ? 'Use this application as a ' : 'स्टोमा स्व-देखभाल सीखने के लिए इस एप्लिकेशन का उपयोग एक ';
  String get supportMessageHighlight => language == AppLanguage.english ? 'supportive guide' : 'सहायक मार्गदर्शिका';
  String get supportMessagePart2 => language == AppLanguage.english ? ' for learning stoma self-care.' : ' के रूप में करें।';

  // Emergency Words (Red highlights)
  String get emWordPain => language == AppLanguage.english ? 'severe pain' : 'गंभीर दर्द';
  String get emWordBleeding => language == AppLanguage.english ? 'bleeding' : 'रक्तस्राव';
  String get emWordFever => language == AppLanguage.english ? 'fever' : 'बुखार';
  String get emWordLeakage => language == AppLanguage.english ? 'excessive leakage' : 'अत्यधिक रिसाव';
  String get emWordSkin => language == AppLanguage.english ? 'skin problems around the stoma' : 'स्टोमा के आसपास त्वचा संबंधी समस्या';
  String get emWordColor => language == AppLanguage.english ? 'sudden changes in stoma color' : 'स्टोमा के रंग में अचानक परिवर्तन';
  String get emWordEmergency => language == AppLanguage.english ? 'any emergency symptoms' : 'कोई भी आपातकालीन लक्षण';

  // Emergency Labels (Icon grids)
  String get labelPain => language == AppLanguage.english ? 'Severe\npain' : 'गंभीर\nदर्द';
  String get labelBleeding => language == AppLanguage.english ? 'Bleeding\nfrom stoma' : 'स्टोमा से\nरक्तस्राव';
  String get labelFever => language == AppLanguage.english ? 'Fever' : 'बुखार';
  String get labelLeakage => language == AppLanguage.english ? 'Excessive\nleakage' : 'अत्यधिक\nरिसाव';
  String get labelColor => language == AppLanguage.english ? 'Sudden change\nin stoma color' : 'स्टोमा के रंग में\nअचानक परिवर्तन';
  String get labelSkin => language == AppLanguage.english ? 'Skin problems\naround stoma' : 'स्टोमा के आसपास\nत्वचा समस्या';
}


