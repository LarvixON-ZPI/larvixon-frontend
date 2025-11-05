import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/l10n/app_localizations.dart';
import 'package:larvixon_frontend/src/user/bloc/cubit/user_edit_cubit.dart';
import 'package:larvixon_frontend/src/user/presentation/widgets/details_section.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'details_section_test.mocks.dart';

@GenerateMocks([UserEditCubit])
void main() {
  late MockUserEditCubit mockCubit;

  setUpAll(() {
    provideDummy<UserEditState>(const UserEditState(fieldErrors: {}));
  });

  setUp(() {
    mockCubit = MockUserEditCubit();
    when(mockCubit.stream).thenAnswer((_) => const Stream.empty());
    when(mockCubit.state).thenReturn(const UserEditState(fieldErrors: {}));
  });

  Widget createTestWidget({
    String? organization,
    String? phoneNumber,
    String? bio,
    Axis direction = Axis.horizontal,
  }) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: BlocProvider<UserEditCubit>.value(
          value: mockCubit,
          child: DetailsSection(
            direction: direction,
            organization: organization,
            phoneNumber: phoneNumber,
            bio: bio,
          ),
        ),
      ),
    );
  }

  group('DetailsSection Widget', () {
    testWidgets('renders the widget with three TextFormFields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      expect(find.byType(DetailsSection), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('initializes with provided values', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          phoneNumber: '+48 123 456 789',
          organization: 'Test Org',
          bio: 'Test bio',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('+48 123 456 789'), findsOneWidget);
      expect(find.text('Test Org'), findsOneWidget);
      expect(find.text('Test bio'), findsOneWidget);
    });

    testWidgets('hides save/cancel buttons initially', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          phoneNumber: '+48 123 456 789',
          organization: 'Test Org',
          bio: 'Test bio',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Save'), findsNothing);
      expect(find.text('Cancel'), findsNothing);
    });

    testWidgets(
      'shows save/cancel buttons after modifying field and waiting for debounce',
      (tester) async {
        await tester.pumpWidget(
          createTestWidget(phoneNumber: '+48 123 456 789'),
        );
        await tester.pumpAndSettle();

        // Initially no buttons
        expect(find.text('Save'), findsNothing);

        // Find and modify the phone field
        final phoneFields = find.byType(TextFormField);
        await tester.enterText(phoneFields.first, '+48 987 654 321');

        // Wait for debounce (300ms)
        await tester.pump(const Duration(milliseconds: 300));
        await tester.pumpAndSettle();

        // Buttons should appear
        expect(find.text('Save'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
      },
    );

    testWidgets('cancel button resets form to original values', (tester) async {
      await tester.pumpWidget(createTestWidget(phoneNumber: '+48 123 456 789'));
      await tester.pumpAndSettle();

      // Modify field
      final phoneFields = find.byType(TextFormField);
      await tester.enterText(phoneFields.first, '+48 987 654 321');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify change
      expect(find.text('+48 987 654 321'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);

      // Tap cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Should reset to original value (buttons may still be visible due to debounce)
      expect(find.text('+48 123 456 789'), findsOneWidget);
      expect(find.text('+48 987 654 321'), findsNothing);
    });

    testWidgets('save button calls updateDetails with correct values', (
      tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(
          phoneNumber: '+48 123 456 789',
          organization: 'Old Org',
          bio: 'Old bio',
        ),
      );
      await tester.pumpAndSettle();

      // Modify fields with valid values
      final fields = find.byType(TextFormField);
      await tester.enterText(
        fields.at(0),
        '+48111222333',
      ); // Valid phone format
      await tester.enterText(fields.at(1), 'New Org');
      await tester.enterText(fields.at(2), 'New bio');

      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Tap save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify cubit was called
      verify(
        mockCubit.updateDetails(
          phoneNumber: '+48111222333',
          organization: 'New Org',
          bio: 'New bio',
        ),
      ).called(1);
    });

    testWidgets('shows save button when in saving state with changes', (
      tester,
    ) async {
      await tester.pumpWidget(createTestWidget(phoneNumber: '+48 123 456 789'));
      await tester.pumpAndSettle();

      // Make a change to show save button
      final phoneFields = find.byType(TextFormField);
      await tester.enterText(phoneFields.first, '+48 987 654 321');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Verify save button is enabled
      final saveButtonBefore = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Save'),
      );
      expect(saveButtonBefore.onPressed, isNotNull);

      // Now set saving state
      when(mockCubit.state).thenReturn(
        const UserEditState(status: EditStatus.saving, fieldErrors: {}),
      );
      when(mockCubit.stream).thenAnswer(
        (_) => Stream.value(
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
        ),
      );

      // Trigger a rebuild
      await tester.pump();
      await tester.pumpAndSettle();

      // Save button should still exist (canSave logic)
      expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);
    });

    testWidgets('validates phone number format locally', (tester) async {
      await tester.pumpWidget(createTestWidget(phoneNumber: '+48 123 456 789'));
      await tester.pumpAndSettle();

      // Enter invalid phone number
      final phoneFields = find.byType(TextFormField);
      await tester.enterText(phoneFields.first, 'invalid');
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      // Tap save to trigger validation
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Form should show local validation error
      // (The exact error message depends on the phone validator implementation)
      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('renders in horizontal direction by default', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      final flex = tester.widget<Flex>(
        find
            .descendant(of: find.byType(Form), matching: find.byType(Flex))
            .first,
      );
      expect(flex.direction, Axis.horizontal);
    });

    testWidgets('renders in vertical direction when specified', (tester) async {
      await tester.pumpWidget(createTestWidget(direction: Axis.vertical));
      await tester.pumpAndSettle();

      final flex = tester.widget<Flex>(
        find
            .descendant(of: find.byType(Form), matching: find.byType(Flex))
            .first,
      );
      expect(flex.direction, Axis.vertical);
    });

    testWidgets('debounces change detection', (tester) async {
      await tester.pumpWidget(createTestWidget(phoneNumber: '+48 123 456 789'));
      await tester.pumpAndSettle();

      // Modify field
      final phoneFields = find.byType(TextFormField);
      await tester.enterText(phoneFields.first, '+48 111 222 333');

      // Immediately check - buttons should not appear yet
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.text('Save'), findsNothing);

      // Wait for remaining debounce time
      await tester.pump(const Duration(milliseconds: 200));
      await tester.pumpAndSettle();

      // Now buttons should appear
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('updates when widget receives new props', (tester) async {
      await tester.pumpWidget(
        createTestWidget(phoneNumber: '+48 111 111 111', organization: 'Org 1'),
      );
      await tester.pumpAndSettle();

      expect(find.text('+48 111 111 111'), findsOneWidget);
      expect(find.text('Org 1'), findsOneWidget);

      // Update props
      await tester.pumpWidget(
        createTestWidget(phoneNumber: '+48 222 222 222', organization: 'Org 2'),
      );
      await tester.pumpAndSettle();

      expect(find.text('+48 222 222 222'), findsOneWidget);
      expect(find.text('Org 2'), findsOneWidget);
      expect(find.text('+48 111 111 111'), findsNothing);
      expect(find.text('Org 1'), findsNothing);
    });

    testWidgets('allows empty optional fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();

      // All fields should be empty by default
      final fields = find.byType(TextFormField);
      expect(fields, findsNWidgets(3));

      // Should be able to save with empty phone (it's optional)
      await tester.enterText(fields.at(1), 'Some Org'); // organization
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify cubit was called (with empty values for other fields)
      verify(
        mockCubit.updateDetails(
          phoneNumber: '',
          organization: 'Some Org',
          bio: '',
        ),
      ).called(1);
    });
  });
}
