import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:larvixon_frontend/src/authentication/domain/failures/auth_error.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_error_dialog.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';

void main() {
  Widget createTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(body: child),
    );
  }

  group('AuthErrorDialog', () {
    testWidgets('should display invalid credentials error correctly', (
      tester,
    ) async {
      // Arrange
      const error = InvalidCredentialsError();

      // Act
      await tester.pumpWidget(createTestWidget(const AuthErrorDialog(error: error)));

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'The email or password you entered is incorrect. Please try again.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display disabled account error correctly', (
      tester,
    ) async {
      // Arrange
      const error = DisabledAccountError();

      // Act
      await tester.pumpWidget(createTestWidget(const AuthErrorDialog(error: error)));

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'Your account has been disabled. Please contact support for assistance.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display MFA required error correctly', (tester) async {
      // Arrange
      const error = MfaRequiredButNoCodeError();

      // Act
      await tester.pumpWidget(createTestWidget(const AuthErrorDialog(error: error)));

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'This account requires multi-factor authentication. Please enter your authentication code.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display field validation errors correctly', (
      tester,
    ) async {
      // Arrange
      const error = FieldValidationError({
        'email': ['This field is required'],
        'password': ['Password too short'],
      });

      // Act
      await tester.pumpWidget(createTestWidget(const AuthErrorDialog(error: error)));

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.textContaining('Email: This field is required'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Password: Password too short'),
        findsOneWidget,
      );
    });

    testWidgets('should display network error correctly', (tester) async {
      // Arrange
      const error = NetworkError('Network connection failed');

      // Act
      await tester.pumpWidget(createTestWidget(const AuthErrorDialog(error: error)));

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'Unable to connect to the server. Please check your internet connection and try again.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should display server error correctly', (tester) async {
      // Arrange
      const error = ServerError('Internal server error');

      // Act
      await tester.pumpWidget(createTestWidget(const AuthErrorDialog(error: error)));

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('The server is experiencing issues. Please try again later.'),
        findsOneWidget,
      );
    });

    testWidgets('should display invalid MFA code error correctly', (
      tester,
    ) async {
      // Arrange
      const error = InvalidMfaCodeError();

      // Act
      await tester.pumpWidget(createTestWidget(const AuthErrorDialog(error: error)));

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'The authentication code you entered is invalid. Please try again.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('should close dialog when cancel button is tapped', (
      tester,
    ) async {
      // Arrange
      const error = InvalidCredentialsError();
      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => const AuthErrorDialog(error: error),
                  );
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Show the dialog
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Find and tap cancel button
      await tester.tap(find.text('Cancel').last);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsNothing);
    });

    testWidgets('should display dialog using static show method', (
      tester,
    ) async {
      // Arrange
      const error = InvalidCredentialsError();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en')],
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  AuthErrorDialog.show(context, error: error);
                },
                child: const Text('Show Dialog'),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Show Dialog'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'The email or password you entered is incorrect. Please try again.',
        ),
        findsOneWidget,
      );
    });
  });
}
