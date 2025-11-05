import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/user/data/models/user_dto.dart';
import 'package:larvixon_frontend/src/user/data/user_datasource.dart';
import 'package:larvixon_frontend/src/user/domain/entities/user.dart';
import 'package:larvixon_frontend/src/user/domain/repositories/user_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserDataSource])
void main() {
  late MockUserDataSource mockDataSource;
  late UserRepositoryImpl repository;

  setUp(() {
    mockDataSource = MockUserDataSource();
    repository = UserRepositoryImpl(dataSource: mockDataSource);
  });

  tearDown(() {
    repository.dispose();
  });

  group('UserRepositoryImpl', () {
    group('fetchUserProfile', () {
      final testUserDTO = UserProfileDTO(
        username: 'testuser',
        email: 'test@example.com',
        first_name: 'Test',
        last_name: 'User',
        profile: UserProfileDetailsDTO(
          phone_number: '+48 123 456 789',
          organization: 'Test Org',
          bio: 'Test bio',
        ),
      );

      test('returns User entity on success', () async {
        when(
          mockDataSource.getUserProfile(),
        ).thenAnswer((_) async => testUserDTO);

        final result = await repository.fetchUserProfile().run();

        expect(result.isRight(), true);
        result.match((l) => fail('Should not be left'), (user) {
          expect(user.username, 'testuser');
          expect(user.email, 'test@example.com');
          expect(user.firstName, 'Test');
          expect(user.lastName, 'User');
        });
        verify(mockDataSource.getUserProfile()).called(1);
      });

      test('emits user to userStream on success', () async {
        when(
          mockDataSource.getUserProfile(),
        ).thenAnswer((_) async => testUserDTO);

        expectLater(
          repository.userStream,
          emits(isA<User>().having((u) => u.username, 'username', 'testuser')),
        );

        await repository.fetchUserProfile().run();
      });

      test(
        'returns ServiceUnavailableFailure when DioException occurs with no response',
        () async {
          when(mockDataSource.getUserProfile()).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/api/user'),
              type: DioExceptionType.connectionError,
            ),
          );

          final result = await repository.fetchUserProfile().run();

          expect(result.isLeft(), true);
          result.match(
            (failure) => expect(failure, isA<ServiceUnavailableFailure>()),
            (r) => fail('Should not be right'),
          );
        },
      );

      test(
        'returns appropriate ApiFailure for different status codes',
        () async {
          when(mockDataSource.getUserProfile()).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/api/user'),
              response: Response(
                requestOptions: RequestOptions(path: '/api/user'),
                statusCode: 404,
                statusMessage: 'Not Found',
              ),
              type: DioExceptionType.badResponse,
            ),
          );

          final result = await repository.fetchUserProfile().run();

          expect(result.isLeft(), true);
          result.match(
            (failure) => expect(failure, isA<NotFoundFailure>()),
            (r) => fail('Should not be right'),
          );
        },
      );

      test('returns UnknownFailure for non-DioException errors', () async {
        when(
          mockDataSource.getUserProfile(),
        ).thenThrow(Exception('Unknown error'));

        final result = await repository.fetchUserProfile().run();

        expect(result.isLeft(), true);
        result.match((failure) {
          expect(failure, isA<UnknownFailure>());
          expect(failure.message, contains('Exception: Unknown error'));
        }, (r) => fail('Should not be right'));
      });
    });

    group('updateUserProfileDetails', () {
      test('succeeds and fetches updated profile', () async {
        when(
          mockDataSource.updateUserProfileDetails(
            profileDetails: anyNamed('profileDetails'),
          ),
        ).thenAnswer((_) async => UserProfileDetailsDTO());

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'Test',
            last_name: 'User',
            profile: UserProfileDetailsDTO(
              phone_number: '+48 987 654 321',
              organization: 'Updated Org',
              bio: 'Updated bio',
            ),
          ),
        );

        final result = await repository
            .updateUserProfileDetails(
              phoneNumber: '+48 987 654 321',
              bio: 'Updated bio',
              org: 'Updated Org',
            )
            .run();

        expect(result.isRight(), true);
        verify(
          mockDataSource.updateUserProfileDetails(
            profileDetails: anyNamed('profileDetails'),
          ),
        ).called(1);
      });

      test('handles null optional parameters', () async {
        when(
          mockDataSource.updateUserProfileDetails(
            profileDetails: anyNamed('profileDetails'),
          ),
        ).thenAnswer((_) async => UserProfileDetailsDTO());

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'Test',
            last_name: 'User',
          ),
        );

        final result = await repository.updateUserProfileDetails().run();

        expect(result.isRight(), true);
        verify(
          mockDataSource.updateUserProfileDetails(
            profileDetails: anyNamed('profileDetails'),
          ),
        ).called(1);
      });

      test(
        'returns ValidationFailure for 400 bad request with field errors',
        () async {
          when(
            mockDataSource.updateUserProfileDetails(
              profileDetails: anyNamed('profileDetails'),
            ),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: '/api/user/profile'),
              response: Response(
                requestOptions: RequestOptions(path: '/api/user/profile'),
                statusCode: 400,
                data: {
                  'phone_number': ['Invalid phone format'],
                  'organization': ['Organization is required'],
                },
              ),
              type: DioExceptionType.badResponse,
            ),
          );

          final result = await repository
              .updateUserProfileDetails(phoneNumber: 'invalid', org: '')
              .run();

          expect(result.isLeft(), true);
          result.match((failure) {
            expect(failure, isA<ValidationFailure>());
            final validationFailure = failure as ValidationFailure;
            expect(
              validationFailure.fieldErrors['phone_number'],
              'Invalid phone format',
            );
            expect(
              validationFailure.fieldErrors['organization'],
              'Organization is required',
            );
          }, (r) => fail('Should not be right'));
        },
      );

      test('returns appropriate failure for server error', () async {
        when(
          mockDataSource.updateUserProfileDetails(
            profileDetails: anyNamed('profileDetails'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/user/profile'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/user/profile'),
              statusCode: 500,
              statusMessage: 'Internal Server Error',
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository
            .updateUserProfileDetails(phoneNumber: '+48 123 456 789')
            .run();

        expect(result.isLeft(), true);
        result.match(
          (failure) => expect(failure, isA<InternalServerErrorFailure>()),
          (r) => fail('Should not be right'),
        );
      });

      test('creates correct DTO with provided parameters', () async {
        when(
          mockDataSource.updateUserProfileDetails(
            profileDetails: anyNamed('profileDetails'),
          ),
        ).thenAnswer((_) async => UserProfileDetailsDTO());

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'Test',
            last_name: 'User',
          ),
        );

        await repository
            .updateUserProfileDetails(
              phoneNumber: '+1234567890',
              bio: 'My bio',
              org: 'My Company',
            )
            .run();

        final captured = verify(
          mockDataSource.updateUserProfileDetails(
            profileDetails: captureAnyNamed('profileDetails'),
          ),
        ).captured;

        expect(captured.length, 1);
        final dto = captured[0] as UserProfileDetailsDTO;
        expect(dto.phone_number, '+1234567890');
        expect(dto.bio, 'My bio');
        expect(dto.organization, 'My Company');
      });
    });

    group('updateUserProfileBasicInfo', () {
      test('succeeds and fetches updated profile', () async {
        when(
          mockDataSource.updateUserProfile(dto: anyNamed('dto')),
        ).thenAnswer((_) async => UserProfileDTO());

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'John',
            last_name: 'Doe',
          ),
        );

        final result = await repository
            .updateUserProfileBasicInfo(firstName: 'John', lastName: 'Doe')
            .run();

        expect(result.isRight(), true);
        verify(
          mockDataSource.updateUserProfile(dto: anyNamed('dto')),
        ).called(1);
      });

      test('returns ValidationFailure for empty required fields', () async {
        when(mockDataSource.updateUserProfile(dto: anyNamed('dto'))).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/user'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/user'),
              statusCode: 400,
              data: {
                'first_name': ['This field is required'],
                'last_name': ['This field is required'],
              },
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository
            .updateUserProfileBasicInfo(firstName: '', lastName: '')
            .run();

        expect(result.isLeft(), true);
        result.match((failure) {
          expect(failure, isA<ValidationFailure>());
          final validationFailure = failure as ValidationFailure;
          expect(validationFailure.fieldErrors, isNotEmpty);
        }, (r) => fail('Should not be right'));
      });

      test('creates correct DTO with provided names', () async {
        when(
          mockDataSource.updateUserProfile(dto: anyNamed('dto')),
        ).thenAnswer((_) async => UserProfileDTO());

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'Jane',
            last_name: 'Smith',
          ),
        );

        await repository
            .updateUserProfileBasicInfo(firstName: 'Jane', lastName: 'Smith')
            .run();

        final captured = verify(
          mockDataSource.updateUserProfile(dto: captureAnyNamed('dto')),
        ).captured;

        expect(captured.length, 1);
        final dto = captured[0] as UserProfileDTO;
        expect(dto.first_name, 'Jane');
        expect(dto.last_name, 'Smith');
      });
    });

    group('updateUserProfilePhoto', () {
      final testBytes = Uint8List.fromList([1, 2, 3, 4]);
      const testFileName = 'photo.jpg';

      test('succeeds and fetches updated profile', () async {
        when(
          mockDataSource.updateUserProfilePhoto(
            bytes: anyNamed('bytes'),
            fileName: anyNamed('fileName'),
          ),
        ).thenAnswer((_) async {});

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'Test',
            last_name: 'User',
          ),
        );

        final result = await repository
            .updateUserProfilePhoto(bytes: testBytes, fileName: testFileName)
            .run();

        expect(result.isRight(), true);
        verify(
          mockDataSource.updateUserProfilePhoto(
            bytes: testBytes,
            fileName: testFileName,
          ),
        ).called(1);
      });

      test('returns BadRequestFailure for invalid file format', () async {
        when(
          mockDataSource.updateUserProfilePhoto(
            bytes: anyNamed('bytes'),
            fileName: anyNamed('fileName'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/user/photo'),
            response: Response(
              requestOptions: RequestOptions(path: '/api/user/photo'),
              statusCode: 400,
              statusMessage: 'Invalid file format',
            ),
            type: DioExceptionType.badResponse,
          ),
        );

        final result = await repository
            .updateUserProfilePhoto(bytes: testBytes, fileName: 'invalid.txt')
            .run();

        expect(result.isLeft(), true);
        result.match(
          (failure) => expect(failure, isA<BadRequestFailure>()),
          (r) => fail('Should not be right'),
        );
      });

      test('handles large file upload', () async {
        final largeBytes = Uint8List(1024 * 1024); // 1MB

        when(
          mockDataSource.updateUserProfilePhoto(
            bytes: anyNamed('bytes'),
            fileName: anyNamed('fileName'),
          ),
        ).thenAnswer((_) async {});

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'Test',
            last_name: 'User',
          ),
        );

        final result = await repository
            .updateUserProfilePhoto(
              bytes: largeBytes,
              fileName: 'large_photo.jpg',
            )
            .run();

        expect(result.isRight(), true);
        verify(
          mockDataSource.updateUserProfilePhoto(
            bytes: largeBytes,
            fileName: 'large_photo.jpg',
          ),
        ).called(1);
      });

      test('passes correct parameters to data source', () async {
        when(
          mockDataSource.updateUserProfilePhoto(
            bytes: anyNamed('bytes'),
            fileName: anyNamed('fileName'),
          ),
        ).thenAnswer((_) async {});

        when(mockDataSource.getUserProfile()).thenAnswer(
          (_) async => UserProfileDTO(
            username: 'testuser',
            email: 'test@example.com',
            first_name: 'Test',
            last_name: 'User',
          ),
        );

        await repository
            .updateUserProfilePhoto(bytes: testBytes, fileName: testFileName)
            .run();

        verify(
          mockDataSource.updateUserProfilePhoto(
            bytes: testBytes,
            fileName: testFileName,
          ),
        ).called(1);
      });
    });

    group('userStream', () {
      test('emits users when fetchUserProfile is called', () async {
        final testUserDTO = UserProfileDTO(
          username: 'testuser',
          email: 'test@example.com',
          first_name: 'Test',
          last_name: 'User',
        );

        when(
          mockDataSource.getUserProfile(),
        ).thenAnswer((_) async => testUserDTO);

        expectLater(
          repository.userStream,
          emitsInOrder([
            isA<User>().having((u) => u.username, 'username', 'testuser'),
          ]),
        );

        await repository.fetchUserProfile().run();
      });

      test('does not emit on failed fetch', () async {
        when(mockDataSource.getUserProfile()).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: '/api/user'),
            type: DioExceptionType.connectionError,
          ),
        );

        expectLater(
          repository.userStream,
          emitsInOrder([]), // No emissions
        );

        await repository.fetchUserProfile().run();
      });
    });

    group('dispose', () {
      test('closes the user stream controller', () {
        repository.dispose();
        // If we try to add to stream after dispose, it should throw
        expect(() => repository.fetchUserProfile().run(), returnsNormally);
      });
    });
  });
}
