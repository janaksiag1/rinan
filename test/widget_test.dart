// Basic smoke test: the Riण app boots to the splash screen.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rinan/app.dart';

void main() {
  testWidgets('App boots to splash', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: RinanApp()));
    await tester.pump();

    // Splash shows the brand mark.
    expect(find.text('Riण'), findsWidgets);
  });
}
