import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../lib/main.dart';
import '../lib/screens/products_overview_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Test success login", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());
    await tester.pump(new Duration(seconds: 5));

    // Find email input and enter email.
    expect(find.byKey(ValueKey('email')), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('email')));
    await tester.enterText(
        find.byKey(ValueKey('email')), 'mohamad.hazime90@gmail.com');
    await tester.pump(new Duration(seconds: 2));

    // Find password input and enter password.
    expect(find.byKey(ValueKey('password')), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('password')));
    await tester.enterText(find.byKey(ValueKey('password')), 'Moh@m@d77');
    await tester.pump(new Duration(seconds: 2));

    // Find login button and tap it.
    expect(find.byKey(ValueKey('btn')), findsOneWidget);
    await tester.tap(find.byKey(ValueKey('btn')));
    await tester.pump(new Duration(seconds: 2));

    // Find home screen
    expect(find.byType(ProductsOverviewScreen), findsOneWidget);
    await tester.pump(new Duration(seconds: 2));
  });
}
