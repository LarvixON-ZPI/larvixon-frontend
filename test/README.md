# Testing Strategy for Larvixon Frontend

This directory contains tests for the Larvixon Frontend application, organized to mirror the structure of the `lib` directory.

## Directory Structure

```
test/
└── src/
    ├── authentication/
    │   └── bloc/
    │       └── auth_bloc_test.dart
    └── user/
        └── bloc/
            └── user_bloc_test.dart
```

## Running Tests

To run all tests:

```bash
flutter test
```

To run a specific test file:

```bash
flutter test test/src/authentication/bloc/auth_bloc_test.dart
```

## Test Dependencies

The project uses the following testing libraries:

- `flutter_test`: Core Flutter testing framework
- `bloc_test`: For testing BLoC components
- `mockito`: For mocking dependencies
- `build_runner`: For generating mock classes

## Setting Up New Tests

1. Create a test file mirroring the structure of the source code
2. Use `mockito` to mock external dependencies
3. Use `bloc_test` for testing Bloc components

## Continuous Integration

This project uses GitHub Actions for continuous integration:

1. **Main Workflow (`flutter_ci.yml`)**
   - Runs on every push to main and pull requests
   - Performs code quality checks (formatting, analysis)
   - Runs all tests

## Example Test Structure

```dart
group('SomeBloc', () {
  late MockRepository mockRepository;
  late SomeBloc bloc;

  setUp(() {
    mockRepository = MockRepository();
    bloc = SomeBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is correct', () {
    expect(bloc.state, SomeInitialState());
  });

  blocTest<SomeBloc, SomeState>(
    'emits [loading, success] when operation succeeds',
    build: () => bloc,
    act: (bloc) => bloc.add(SomeEvent()),
    expect: () => [
      SomeLoadingState(),
      SomeSuccessState(),
    ],
  );
});
```
