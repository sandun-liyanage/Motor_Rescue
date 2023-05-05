// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:motor_rescue/src/auth/driver_login.dart';

// void main() {

// }

void main() {
  group('DriverLogin widget tests', () {
    testWidgets('DriverLogin widget has a Login button',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: DriverLogin()));
      expect(find.widgetWithText(ElevatedButton, 'LOGIN'), findsOneWidget);
    });

    testWidgets('Verify that email and password fields are empty by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DriverLogin(),
        ),
      );

      final emailField = find.byType(TextField).at(0);
      final passwordField = find.byType(TextField).at(1);

      expect((emailField.evaluate().first.widget as TextField).controller?.text,
          '');
      expect(
          (passwordField.evaluate().first.widget as TextField).controller?.text,
          '');
    });

    testWidgets('Verify that the login button is disabled by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DriverLogin(),
        ),
      );

      final loginButton = find.byType(ElevatedButton);

      expect((loginButton.evaluate().first.widget as ElevatedButton).enabled,
          isFalse);
    });
  });
}
