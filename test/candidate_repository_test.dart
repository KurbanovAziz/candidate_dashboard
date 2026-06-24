import 'package:candidate_dashboard/core/utils/result.dart';
import 'package:candidate_dashboard/data/datasources/candidate_api_service.dart';
import 'package:candidate_dashboard/data/datasources/candidate_local_data_source.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/data/repositories/candidate_repository_impl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/candidate_factory.dart';

class _MockCandidateApiService extends Mock implements CandidateApiService {}

class _MockLocalDataSource extends Mock implements CandidateLocalDataSource {}

void main() {
  late _MockCandidateApiService apiService;
  late _MockLocalDataSource local;
  late CandidateRepositoryImpl repository;
  late Candidate candidate;

  setUpAll(() {
    registerFallbackValue(CandidateStatus.fresh);
  });

  setUp(() {
    apiService = _MockCandidateApiService();
    local = _MockLocalDataSource();
    repository = CandidateRepositoryImpl(
      apiService: apiService,
      localDataSource: local,
    );
    candidate = candidateFactory(id: 'ivan');

    when(() => local.pendingStatusSync()).thenReturn(const {});
    when(() => local.watchCandidates()).thenAnswer((_) => const Stream.empty());
    when(() => local.saveCandidates(any())).thenAnswer((_) async {});
    when(() => local.readCandidates()).thenAnswer((_) async => [candidate]);
    when(() => local.saveStatus(any(), any())).thenAnswer((_) async {});
    when(() => local.removeStatusSync(any())).thenAnswer((_) async {});
    when(() => local.enqueueStatusSync(any(), any())).thenAnswer((_) async {});
  });

  test('fetchCandidates saves remote candidates to cache', () async {
    when(() => apiService.getCandidates()).thenAnswer((_) async => [candidate]);

    final result = await repository.fetchCandidates();

    expect(result, isA<Success>());
    verify(() => local.saveCandidates([candidate])).called(1);
  });

  test('fetchCandidates returns cached data as offline fallback', () async {
    when(() => apiService.getCandidates()).thenThrow(Exception('offline'));

    final result = await repository.fetchCandidates();

    expect(result, isA<Success>());
    final snapshot = (result as Success).data;
    expect(snapshot.isOffline, true);
    expect(snapshot.candidates.single.id, candidate.id);
  });

  test('updateStatus rolls back local status on server error', () async {
    when(
      () => apiService.updateCandidateStatus(
        candidateId: candidate.id,
        status: CandidateStatus.review,
      ),
    ).thenThrow(Exception('patch failed'));

    final result = await repository.updateStatus(
      candidateId: candidate.id,
      status: CandidateStatus.review,
    );

    expect(result, isA<Failure>());
    verify(
      () => local.saveStatus(candidate.id, CandidateStatus.review),
    ).called(1);
    verify(
      () => local.saveStatus(candidate.id, CandidateStatus.fresh),
    ).called(1);
    verifyNever(
      () => local.enqueueStatusSync(candidate.id, CandidateStatus.review),
    );
  });

  test(
    'updateStatus keeps local status and queues sync on connection error',
    () async {
      when(
        () => apiService.updateCandidateStatus(
          candidateId: candidate.id,
          status: CandidateStatus.review,
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/candidates/ivan/status'),
          type: DioExceptionType.connectionError,
        ),
      );

      final result = await repository.updateStatus(
        candidateId: candidate.id,
        status: CandidateStatus.review,
      );

      expect(result, isA<Success>());
      verify(
        () => local.saveStatus(candidate.id, CandidateStatus.review),
      ).called(1);
      verifyNever(() => local.saveStatus(candidate.id, CandidateStatus.fresh));
      verify(
        () => local.enqueueStatusSync(candidate.id, CandidateStatus.review),
      ).called(1);
    },
  );
}
