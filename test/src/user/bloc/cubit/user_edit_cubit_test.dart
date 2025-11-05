import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/user/bloc/cubit/user_edit_cubit.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_edit_cubit_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late MockUserRepository mockRepository;
  late UserEditCubit cubit;

  setUp(() {
    mockRepository = MockUserRepository();

    // Provide dummy values for TaskEither return types
    provideDummy<TaskEither<Failure, void>>(
      TaskEither<Failure, void>.right(null),
    );

    cubit = UserEditCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('UserEditCubit', () {
    test('initial state has idle status and empty fieldErrors', () {
      expect(cubit.state.status, EditStatus.idle);
      expect(cubit.state.fieldErrors, isEmpty);
      expect(cubit.state.error, isNull);
    });

    group('updateDetails', () {
      blocTest<UserEditCubit, UserEditState>(
        'emits [saving, success] when update succeeds',
        build: () {
          when(
            mockRepository.updateUserProfileDetails(
              phoneNumber: anyNamed('phoneNumber'),
              bio: anyNamed('bio'),
              org: anyNamed('org'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.updateDetails(
          phoneNumber: '+48 123 456 789',
          bio: 'Test bio',
          organization: 'Test Org',
        ),
        expect: () => [
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
        ],
        verify: (_) {
          verify(
            mockRepository.updateUserProfileDetails(
              phoneNumber: '+48 123 456 789',
              bio: 'Test bio',
              org: 'Test Org',
            ),
          ).called(1);
        },
      );

      blocTest<UserEditCubit, UserEditState>(
        'emits [saving, error] with ValidationFailure when validation fails',
        build: () {
          when(
            mockRepository.updateUserProfileDetails(
              phoneNumber: anyNamed('phoneNumber'),
              bio: anyNamed('bio'),
              org: anyNamed('org'),
            ),
          ).thenReturn(
            TaskEither.left(
              const ValidationFailure(
                fieldErrors: {
                  'phone_number': 'Invalid phone format',
                  'organization': 'Organization is required',
                },
                message: 'Validation failed',
              ),
            ),
          );
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) =>
            cubit.updateDetails(phoneNumber: 'invalid', organization: ''),
        expect: () => [
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(
            status: EditStatus.error,
            error: ValidationFailure(
              fieldErrors: {
                'phone_number': 'Invalid phone format',
                'organization': 'Organization is required',
              },
              message: 'Validation failed',
            ),
            fieldErrors: {
              'phone_number': 'Invalid phone format',
              'organization': 'Organization is required',
            },
          ),
        ],
      );

      blocTest<UserEditCubit, UserEditState>(
        'emits [saving, error] with empty fieldErrors for non-validation failures',
        build: () {
          when(
            mockRepository.updateUserProfileDetails(
              phoneNumber: anyNamed('phoneNumber'),
              bio: anyNamed('bio'),
              org: anyNamed('org'),
            ),
          ).thenReturn(
            TaskEither.left(
              const InternalServerErrorFailure(message: 'Server error'),
            ),
          );
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.updateDetails(phoneNumber: '+48 123 456 789'),
        expect: () => [
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(
            status: EditStatus.error,
            error: InternalServerErrorFailure(message: 'Server error'),
            fieldErrors: {},
          ),
        ],
      );

      blocTest<UserEditCubit, UserEditState>(
        'calls repository with correct parameters',
        build: () {
          when(
            mockRepository.updateUserProfileDetails(
              phoneNumber: anyNamed('phoneNumber'),
              bio: anyNamed('bio'),
              org: anyNamed('org'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.updateDetails(
          phoneNumber: '+1234567890',
          bio: 'My bio',
          organization: 'My Company',
        ),
        verify: (_) {
          verify(
            mockRepository.updateUserProfileDetails(
              phoneNumber: '+1234567890',
              bio: 'My bio',
              org: 'My Company',
            ),
          ).called(1);
        },
      );

      blocTest<UserEditCubit, UserEditState>(
        'handles null optional parameters',
        build: () {
          when(
            mockRepository.updateUserProfileDetails(
              phoneNumber: anyNamed('phoneNumber'),
              bio: anyNamed('bio'),
              org: anyNamed('org'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.updateDetails(),
        verify: (_) {
          verify(
            mockRepository.updateUserProfileDetails(
              phoneNumber: null,
              bio: null,
              org: null,
            ),
          ).called(1);
        },
      );
    });

    group('updateBasicInfo', () {
      blocTest<UserEditCubit, UserEditState>(
        'emits [saving, success] when update succeeds',
        build: () {
          when(
            mockRepository.updateUserProfileBasicInfo(
              firstName: anyNamed('firstName'),
              lastName: anyNamed('lastName'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) =>
            cubit.updateBasicInfo(firstName: 'John', lastName: 'Doe'),
        expect: () => [
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
        ],
        verify: (_) {
          verify(
            mockRepository.updateUserProfileBasicInfo(
              firstName: 'John',
              lastName: 'Doe',
            ),
          ).called(1);
        },
      );

      blocTest<UserEditCubit, UserEditState>(
        'emits [saving, error] with fieldErrors when validation fails',
        build: () {
          when(
            mockRepository.updateUserProfileBasicInfo(
              firstName: anyNamed('firstName'),
              lastName: anyNamed('lastName'),
            ),
          ).thenReturn(
            TaskEither.left(
              const ValidationFailure(
                fieldErrors: {
                  'first_name': 'First name is required',
                  'last_name': 'Last name is required',
                },
                message: 'Validation failed',
              ),
            ),
          );
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.updateBasicInfo(firstName: '', lastName: ''),
        expect: () => [
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(
            status: EditStatus.error,
            error: ValidationFailure(
              fieldErrors: {
                'first_name': 'First name is required',
                'last_name': 'Last name is required',
              },
              message: 'Validation failed',
            ),
            fieldErrors: {
              'first_name': 'First name is required',
              'last_name': 'Last name is required',
            },
          ),
        ],
      );

      blocTest<UserEditCubit, UserEditState>(
        'clears fieldErrors on success',
        build: () {
          when(
            mockRepository.updateUserProfileBasicInfo(
              firstName: anyNamed('firstName'),
              lastName: anyNamed('lastName'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        seed: () => const UserEditState(
          status: EditStatus.error,
          fieldErrors: {'first_name': 'Error'},
        ),
        act: (cubit) =>
            cubit.updateBasicInfo(firstName: 'John', lastName: 'Doe'),
        expect: () => [
          const UserEditState(
            status: EditStatus.saving,
            fieldErrors: {'first_name': 'Error'},
          ),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
        ],
      );
    });

    group('updatePhoto', () {
      final testBytes = Uint8List.fromList([1, 2, 3, 4]);
      const testFileName = 'photo.jpg';

      blocTest<UserEditCubit, UserEditState>(
        'emits [uploadingPhoto, success] when upload succeeds',
        build: () {
          when(
            mockRepository.updateUserProfilePhoto(
              bytes: anyNamed('bytes'),
              fileName: anyNamed('fileName'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) =>
            cubit.updatePhoto(bytes: testBytes, fileName: testFileName),
        expect: () => [
          const UserEditState(
            status: EditStatus.uploadingPhoto,
            fieldErrors: {},
          ),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
        ],
        verify: (_) {
          verify(
            mockRepository.updateUserProfilePhoto(
              bytes: testBytes,
              fileName: testFileName,
            ),
          ).called(1);
        },
      );

      blocTest<UserEditCubit, UserEditState>(
        'emits [uploadingPhoto, error] with errorMessage when upload fails',
        build: () {
          when(
            mockRepository.updateUserProfilePhoto(
              bytes: anyNamed('bytes'),
              fileName: anyNamed('fileName'),
            ),
          ).thenReturn(
            TaskEither.left(
              const BadRequestFailure(message: 'Invalid file format'),
            ),
          );
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) =>
            cubit.updatePhoto(bytes: testBytes, fileName: testFileName),
        expect: () => [
          const UserEditState(
            status: EditStatus.uploadingPhoto,
            fieldErrors: {},
          ),
          const UserEditState(
            status: EditStatus.error,
            errorMessage: 'Invalid file format',
            error: BadRequestFailure(message: 'Invalid file format'),
            fieldErrors: {},
          ),
        ],
      );

      blocTest<UserEditCubit, UserEditState>(
        'handles large file upload',
        build: () {
          when(
            mockRepository.updateUserProfilePhoto(
              bytes: anyNamed('bytes'),
              fileName: anyNamed('fileName'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) {
          final largeBytes = Uint8List(1024 * 1024); // 1MB
          return cubit.updatePhoto(
            bytes: largeBytes,
            fileName: 'large_photo.jpg',
          );
        },
        expect: () => [
          const UserEditState(
            status: EditStatus.uploadingPhoto,
            fieldErrors: {},
          ),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
        ],
      );

      blocTest<UserEditCubit, UserEditState>(
        'clears fieldErrors on successful photo upload',
        build: () {
          when(
            mockRepository.updateUserProfilePhoto(
              bytes: anyNamed('bytes'),
              fileName: anyNamed('fileName'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        seed: () => const UserEditState(
          status: EditStatus.error,
          fieldErrors: {'photo': 'Invalid photo'},
        ),
        act: (cubit) =>
            cubit.updatePhoto(bytes: testBytes, fileName: testFileName),
        expect: () => [
          const UserEditState(
            status: EditStatus.uploadingPhoto,
            fieldErrors: {'photo': 'Invalid photo'},
          ),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
        ],
      );
    });

    group('state transitions', () {
      blocTest<UserEditCubit, UserEditState>(
        'can perform multiple operations in sequence',
        build: () {
          when(
            mockRepository.updateUserProfileDetails(
              phoneNumber: anyNamed('phoneNumber'),
              bio: anyNamed('bio'),
              org: anyNamed('org'),
            ),
          ).thenReturn(TaskEither.right(null));
          when(
            mockRepository.updateUserProfileBasicInfo(
              firstName: anyNamed('firstName'),
              lastName: anyNamed('lastName'),
            ),
          ).thenReturn(TaskEither.right(null));
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) async {
          await cubit.updateDetails(phoneNumber: '+48 123 456 789');
          await cubit.updateBasicInfo(firstName: 'John', lastName: 'Doe');
        },
        expect: () => [
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(status: EditStatus.success, fieldErrors: {}),
        ],
      );

      blocTest<UserEditCubit, UserEditState>(
        'maintains fieldErrors across failed operations',
        build: () {
          when(
            mockRepository.updateUserProfileDetails(
              phoneNumber: anyNamed('phoneNumber'),
              bio: anyNamed('bio'),
              org: anyNamed('org'),
            ),
          ).thenReturn(
            TaskEither.left(
              const ValidationFailure(
                fieldErrors: {'phone_number': 'Invalid format'},
                message: 'Validation failed',
              ),
            ),
          );
          return UserEditCubit(repository: mockRepository);
        },
        act: (cubit) => cubit.updateDetails(phoneNumber: 'invalid'),
        expect: () => [
          const UserEditState(status: EditStatus.saving, fieldErrors: {}),
          const UserEditState(
            status: EditStatus.error,
            error: ValidationFailure(
              fieldErrors: {'phone_number': 'Invalid format'},
              message: 'Validation failed',
            ),
            fieldErrors: {'phone_number': 'Invalid format'},
          ),
        ],
      );
    });
  });
}
