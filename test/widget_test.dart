// This is a basic Flutter widget test for HealthMate app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:healthmate/main.dart';
import 'package:healthmate/providers/theme_provider.dart';

void main() {
  testWidgets('HealthMate app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: const HealthMateApp(),
      ),
    );

    // Verify that the app loads without errors.
    expect(find.byType(Scaffold), findsWidgets);
    expect(find.text('Hello, Sir!'), findsOneWidget);
  });
}
