import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stoma_saathi/main.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    GoogleFonts.config.allowRuntimeFetching = false;
    final imageAssets = Directory('assets/images')
        .listSync(recursive: true)
        .whereType<File>()
        .map((file) => file.path.replaceAll(r'\', '/'))
        .toList(growable: false);
    final jsonManifest = jsonEncode({
      for (final asset in imageAssets) asset: [],
    });
    final binaryManifest = const StandardMessageCodec().encodeMessage({
      for (final asset in imageAssets)
        asset: [
          {'asset': asset},
        ],
    });
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler('flutter/assets', (message) async {
          final key = utf8.decode(message!.buffer.asUint8List());
          if (key == 'AssetManifest.json') {
            return ByteData.view(utf8.encode(jsonManifest).buffer);
          }
          if (key == 'AssetManifest.bin') {
            return binaryManifest;
          }
          if (imageAssets.contains(key)) {
            final bytes = await File(key).readAsBytes();
            return ByteData.view(bytes.buffer);
          }
          return null;
        });
  });

  testWidgets('app shows splash and then home content', (tester) async {
    SharedPreferences.setMockInitialValues({'stoma_logged_in': true});

    await tester.pumpWidget(const StomaSaathiApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump();

    expect(find.text('Stoma Saathi'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Stoma Basics'), findsOneWidget);
  });
}
