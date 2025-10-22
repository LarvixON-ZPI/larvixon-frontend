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
    testWidgets('clears validation errors on input change', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const AuthForm(initialMode: AuthFormMode.signIn)),
      );

      final emailField = find.widgetWithText(TextFormField, 'Email');
      expect(emailField, findsOneWidget);

      await tester.enterText(emailField, 'invalid_email');
      await tester.pump();

      final signInButton = find.byKey(const ValueKey(AuthFormMode.signIn));
      await tester.tap(signInButton);
      await tester.pump();

      expect(find.text('Invalid email format'), findsOneWidget);

      await tester.enterText(emailField, 'valid@example.com');
      await tester.pump();

      expect(find.text('Invalid email format'), findsNothing);
    });

    testWidgets('clears server-side field errors on input change', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(const AuthForm(initialMode: AuthFormMode.signIn)),
      );

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      final signInButton = find.byKey(const ValueKey(AuthFormMode.signIn));

      await tester.enterText(emailField, 'invalid_email');
      await tester.enterText(passwordField, 'password123');
      await tester.tap(signInButton);
      await tester.pump();

      expect(find.text('Invalid email format'), findsOneWidget);

      await tester.enterText(emailField, 'valid2@example.com');
      await tester.pump();

      expect(find.text('Invalid email format'), findsNothing);
    });
  });
}
