import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:larvixon_frontend/core/errors/api_failures.dart';
import 'package:larvixon_frontend/core/errors/failures.dart';
import 'package:larvixon_frontend/src/analysis/blocs/analysis_bloc/analysis_bloc.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis.dart';
import 'package:larvixon_frontend/src/analysis/domain/entities/analysis_progress_status.dart';
import 'package:larvixon_frontend/src/analysis/domain/failures/failures.dart';
import 'package:larvixon_frontend/src/analysis/domain/repositories/analysis_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'analysis_bloc_retry_test.mocks.dart';

@GenerateMocks([AnalysisRepository])
void main() {
  setUpAll(() {
    // Provide dummies for Mockito
    provideDummy<TaskEither<Failure, Analysis>>(
      TaskEither<Failure, Analysis>.right(
        Analysis(id: 1, uploadedAt: DateTime.now()),
      ),
    );
    provideDummy<TaskEither<Failure, bool>>(
      TaskEither<Failure, bool>.right(true),
    );
    provideDummy<Stream<Either<Failure, Analysis>>>(
      Stream.value(
        Either<Failure, Analysis>.right(
          Analysis(id: 1, uploadedAt: DateTime.now()),
        ),
      ),
    );
  });

  group('AnalysisBloc - RetryAnalysis', () {
    late MockAnalysisRepository mockRepository;
    late AnalysisBloc analysisBloc;
    late StreamController<int> updatesController;

    setUp(() {
      mockRepository = MockAnalysisRepository();
      updatesController = StreamController<int>.broadcast();

      // Mock the analysisUpdatesStream
      when(
        mockRepository.analysisUpdatesStream,
      ).thenAnswer((_) => updatesController.stream);

      analysisBloc = AnalysisBloc(repository: mockRepository);
    });

    tearDown(() {
      updatesController.close();
      analysisBloc.close();
    });

    group('Successful retry scenarios', () {
      blocTest<AnalysisBloc, AnalysisState>(
        'emits [loading, success] when retry succeeds',
        build: () {
          final retriedAnalysis = Analysis(
            id: 123,
            uploadedAt: DateTime.now(),
            description: 'Test Analysis',
          );

          when(
            mockRepository.retryAnalysis(id: 123),
          ).thenReturn(TaskEither<Failure, Analysis>.right(retriedAnalysis));

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.success)
              .having((s) => s.analysis?.id, 'analysis.id', 123)
              .having(
                (s) => s.analysis?.status,
                'analysis.status',
                AnalysisProgressStatus.pending,
              )
              .having((s) => s.progress, 'progress', 0.0),
        ],
        verify: (_) {
          verify(mockRepository.retryAnalysis(id: 123)).called(1);
        },
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'updates progress value correctly when analysis status is pending',
        build: () {
          final retriedAnalysis = Analysis(id: 456, uploadedAt: DateTime.now());

          when(
            mockRepository.retryAnalysis(id: 456),
          ).thenReturn(TaskEither<Failure, Analysis>.right(retriedAnalysis));

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 456)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.progress, 'progress', 0.0)
              .having(
                (s) => s.analysis?.status,
                'analysis.status',
                AnalysisProgressStatus.pending,
              ),
        ],
      );
    });

    group('Error scenarios', () {
      blocTest<AnalysisBloc, AnalysisState>(
        'emits [loading, error] when retry fails with not found error',
        build: () {
          when(mockRepository.retryAnalysis(id: 999)).thenReturn(
            TaskEither<Failure, Analysis>.left(
              const AnalysisNotFoundFailure(message: 'Analysis not found'),
            ),
          );

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 999)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.error)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Analysis not found',
              ),
        ],
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'emits [loading, error] when retry fails with API error (400 Bad Request)',
        build: () {
          when(mockRepository.retryAnalysis(id: 123)).thenReturn(
            TaskEither<Failure, Analysis>.left(
              const AnalysisApiFailure(
                apiFailure: BadRequestFailure(
                  message: 'Analysis cannot be retried',
                ),
                message: 'Analysis cannot be retried',
              ),
            ),
          );

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.error)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Analysis cannot be retried',
              ),
        ],
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'emits [loading, error] when retry fails with network timeout',
        build: () {
          when(mockRepository.retryAnalysis(id: 789)).thenReturn(
            TaskEither<Failure, Analysis>.left(
              const AnalysisApiFailure(
                apiFailure: RequestTimeoutFailure(message: 'Request timeout'),
                message: 'Request timeout',
              ),
            ),
          );

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 789)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.error)
              .having((s) => s.errorMessage, 'errorMessage', 'Request timeout'),
        ],
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'emits [loading, error] when retry fails with server error (500)',
        build: () {
          when(mockRepository.retryAnalysis(id: 123)).thenReturn(
            TaskEither<Failure, Analysis>.left(
              const AnalysisApiFailure(
                apiFailure: InternalServerErrorFailure(
                  message: 'Internal server error',
                ),
                message: 'Internal server error',
              ),
            ),
          );

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.error)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Internal server error',
              ),
        ],
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'emits [loading, error] when retry fails with unknown error',
        build: () {
          when(mockRepository.retryAnalysis(id: 123)).thenReturn(
            TaskEither<Failure, Analysis>.left(
              const UnknownAnalysisFailure(
                message: 'Unexpected error occurred',
              ),
            ),
          );

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.error)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Unexpected error occurred',
              ),
        ],
      );
    });

    group('Edge cases', () {
      blocTest<AnalysisBloc, AnalysisState>(
        'handles retry of analysis that was created within 14 day limit',
        build: () {
          final recentAnalysis = Analysis(
            id: 123,
            uploadedAt: DateTime.now().subtract(const Duration(days: 13)),
            description: 'Recent Analysis',
          );

          when(
            mockRepository.retryAnalysis(id: 123),
          ).thenReturn(TaskEither<Failure, Analysis>.right(recentAnalysis));

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.success)
              .having((s) => s.analysis?.id, 'analysis.id', 123),
        ],
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'handles retry of analysis without a video file',
        build: () {
          when(mockRepository.retryAnalysis(id: 123)).thenReturn(
            TaskEither<Failure, Analysis>.left(
              const AnalysisApiFailure(
                apiFailure: BadRequestFailure(
                  message: 'Analysis must have a video file',
                ),
                message: 'Analysis must have a video file',
              ),
            ),
          );

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.error)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Analysis must have a video file',
              ),
        ],
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'handles retry of analysis that is not in failed state',
        build: () {
          when(mockRepository.retryAnalysis(id: 123)).thenReturn(
            TaskEither<Failure, Analysis>.left(
              const AnalysisApiFailure(
                apiFailure: BadRequestFailure(
                  message: 'Analysis is not in failed state',
                ),
                message: 'Analysis is not in failed state',
              ),
            ),
          );

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.error)
              .having(
                (s) => s.errorMessage,
                'errorMessage',
                'Analysis is not in failed state',
              ),
        ],
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'handles multiple rapid retry attempts',
        build: () {
          final retriedAnalysis = Analysis(id: 123, uploadedAt: DateTime.now());

          when(
            mockRepository.retryAnalysis(id: 123),
          ).thenReturn(TaskEither<Failure, Analysis>.right(retriedAnalysis));

          return analysisBloc;
        },
        act: (bloc) {
          bloc.add(const RetryAnalysis(analysisId: 123));
          bloc.add(const RetryAnalysis(analysisId: 123));
          bloc.add(const RetryAnalysis(analysisId: 123));
        },
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>().having(
            (s) => s.status,
            'status',
            AnalysisStatus.success,
          ),
          isA<AnalysisState>().having(
            (s) => s.status,
            'status',
            AnalysisStatus.loading,
          ),
          isA<AnalysisState>().having(
            (s) => s.status,
            'status',
            AnalysisStatus.success,
          ),
          isA<AnalysisState>().having(
            (s) => s.status,
            'status',
            AnalysisStatus.loading,
          ),
          isA<AnalysisState>().having(
            (s) => s.status,
            'status',
            AnalysisStatus.success,
          ),
        ],
        verify: (_) {
          verify(mockRepository.retryAnalysis(id: 123)).called(3);
        },
      );

      blocTest<AnalysisBloc, AnalysisState>(
        'handles retry with null analysis description',
        build: () {
          final retriedAnalysis = Analysis(
            id: 123,
            uploadedAt: DateTime.now(),
            description: null, // Edge case: no description
          );

          when(
            mockRepository.retryAnalysis(id: 123),
          ).thenReturn(TaskEither<Failure, Analysis>.right(retriedAnalysis));

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>()
              .having((s) => s.status, 'status', AnalysisStatus.success)
              .having((s) => s.analysis?.description, 'analysis.description', null),
        ],
      );
    });

    group('Integration with analysis updates stream', () {
      test('bloc closes subscriptions on dispose without errors', () async {
        await analysisBloc.close();
        expect(analysisBloc.isClosed, true);
      });

      blocTest<AnalysisBloc, AnalysisState>(
        'bloc successfully processes retry and reaches success state',
        build: () {
          final retriedAnalysis = Analysis(id: 123, uploadedAt: DateTime.now());

          when(
            mockRepository.retryAnalysis(id: 123),
          ).thenReturn(TaskEither<Failure, Analysis>.right(retriedAnalysis));

          return analysisBloc;
        },
        act: (bloc) => bloc.add(const RetryAnalysis(analysisId: 123)),
        expect: () => [
          const AnalysisState(status: AnalysisStatus.loading),
          isA<AnalysisState>().having(
            (s) => s.status,
            'status',
            AnalysisStatus.success,
          ),
        ],
        verify: (_) {
          verify(mockRepository.retryAnalysis(id: 123)).called(1);
        },
      );
    });
  });
}
