import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/authentication/presentation/auth_form.dart';
import 'package:larvixon_frontend/src/authentication/bloc/auth_bloc.dart';
import 'package:larvixon_frontend/src/authentication/domain/repositories/auth_repository.dart';
import 'package:mockito/annotations.dart';

import 'auth_form_validation_clear_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  Widget createTestWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
      home: Scaffold(
        body: BlocProvider<AuthBloc>.value(value: authBloc, child: child),
      ),
    );
  }

  group('AuthFormValidationClear', () {
    testWidgets('shows and validates email field errors', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const AuthForm(initialMode: AuthFormMode.signIn)),
      );

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final signInButton = find.byIcon(Icons.arrow_forward);

      // Enter invalid email and submit
      await tester.enterText(emailField, 'invalid_email');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Should show validation error
      expect(find.text('Invalid email format'), findsOneWidget);
    });

    testWidgets('validates password field', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const AuthForm(initialMode: AuthFormMode.signIn)),
      );

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final signInButton = find.byIcon(Icons.arrow_forward);

      // Enter valid email but no password
      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, '');
      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      // Should show required error for password
      expect(find.text('This field is required'), findsOneWidget);
    });
  });
}
