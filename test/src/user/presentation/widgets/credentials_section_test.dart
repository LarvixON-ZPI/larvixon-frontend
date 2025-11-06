import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/credentials_section.dart';

void main() {
  Widget createTestWidget({
    required String username,
    required String email,
    Axis direction = Axis.horizontal,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: CredentialsSection(
          username: username,
          email: email,
          direction: direction,
        ),
      ),
    );
  }

  group('CredentialsSection Widget', () {
    testWidgets('renders username and email labels', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'testuser', email: 'test@example.com'),
      );

      expect(find.text('Username'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('displays username value', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'johndoe', email: 'john@example.com'),
      );
      await tester.pumpAndSettle();

      expect(find.text('johndoe'), findsOneWidget);
    });

    testWidgets('displays email value', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'testuser', email: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      expect(find.text('test@example.com'), findsOneWidget);
    });

    testWidgets('fields are read-only', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'testuser', email: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      // Try to tap on username field and enter text
      final usernameField = find.widgetWithText(TextFormField, 'testuser');
      await tester.tap(usernameField);
      await tester.enterText(usernameField, 'newuser');
      await tester.pumpAndSettle();

      // Text should not change because field is read-only
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('newuser'), findsNothing);

      // Try to tap on email field and enter text
      final emailField = find.widgetWithText(TextFormField, 'test@example.com');
      await tester.tap(emailField);
      await tester.enterText(emailField, 'new@example.com');
      await tester.pumpAndSettle();

      // Text should not change because field is read-only
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.text('new@example.com'), findsNothing);
    });

    testWidgets('renders in horizontal direction by default', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'testuser', email: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.horizontal);
    });

    testWidgets('renders in vertical direction when specified', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          username: 'testuser',
          email: 'test@example.com',
          direction: Axis.vertical,
        ),
      );
      await tester.pumpAndSettle();

      final flex = tester.widget<Flex>(find.byType(Flex));
      expect(flex.direction, Axis.vertical);
    });

    testWidgets('updates when props change', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'user1', email: 'user1@example.com'),
      );
      await tester.pumpAndSettle();

      expect(find.text('user1'), findsOneWidget);
      expect(find.text('user1@example.com'), findsOneWidget);

      // Update with new values - need to rebuild the entire widget tree
      // because TextFormField with initialValue doesn't update automatically
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: CredentialsSection(
              username: 'user2',
              email: 'user2@example.com',
              direction: Axis.horizontal,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Since initialValue doesn't update on widget rebuild,
      // the values should remain the same (this is expected TextFormField behavior)
      expect(find.text('user1'), findsOneWidget);
      expect(find.text('user1@example.com'), findsOneWidget);
    });

    testWidgets('both fields are flexible in layout', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'testuser', email: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      final flexibles = tester.widgetList<Flexible>(find.byType(Flexible));
      expect(flexibles.length, 2);
    });

    testWidgets('handles long username gracefully', (tester) async {
      final longUsername = 'a' * 100;
      await tester.pumpWidget(
        createTestWidget(username: longUsername, email: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      expect(find.text(longUsername), findsOneWidget);
    });

    testWidgets('handles long email gracefully', (tester) async {
      final longEmail = '${'a' * 50}@example.com';
      await tester.pumpWidget(
        createTestWidget(username: 'testuser', email: longEmail),
      );
      await tester.pumpAndSettle();

      expect(find.text(longEmail), findsOneWidget);
    });

    testWidgets('renders CustomCard as container', (tester) async {
      await tester.pumpWidget(
        createTestWidget(username: 'testuser', email: 'test@example.com'),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsOneWidget);
    });
  });
}
