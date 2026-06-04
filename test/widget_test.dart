import 'package:flutter_test/flutter_test.dart';
import 'package:stoma_saathi/main.dart';

void main() {
  testWidgets('app shows splash and then home content', (tester) async {
    await tester.pumpWidget(const StomaSaathiApp());

    expect(find.text('Stoma Saathi'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Featured Modules'), findsOneWidget);
  });
}
