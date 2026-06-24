import 'package:bloc_test/bloc_test.dart';
import 'package:candidate_dashboard/core/utils/result.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/data/repositories/candidate_repository.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_bloc.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_event.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/candidate_factory.dart';

class _MockCandidateRepository extends Mock implements CandidateRepository {}

CandidatesListBloc _buildBloc(CandidateRepository repository) =>
    CandidatesListBloc(repository);

void main() {
  late _MockCandidateRepository repository;
  late Candidate candidate;

  setUpAll(() {
    registerFallbackValue(CandidateStatus.fresh);
  });

  setUp(() {
    repository = _MockCandidateRepository();
    candidate = candidateFactory(id: 'candidate_1');

    when(
      () => repository.watchCandidates(),
    ).thenAnswer((_) => const Stream.empty());
    when(() => repository.hasPendingSync).thenReturn(false);
  });

  blocTest<CandidatesListBloc, CandidatesListState>(
    'emits notFound when candidate is absent',
    setUp: () {
      when(() => repository.fetchCandidates()).thenAnswer(
        (_) async => const Success(
          CandidatesSnapshot(
            candidates: [],
            isOffline: false,
            hasPendingSync: false,
          ),
        ),
      );
    },
    build: () => _buildBloc(repository),
    act: (bloc) => bloc.add(CandidateDetailOpened(candidate.id)),
    expect: () => [
      isA<CandidatesListState>().having(
        (state) => state.detailStatus,
        'detail status',
        CandidateDetailStatus.loading,
      ),
      isA<CandidatesListState>().having(
        (state) => state.detailStatus,
        'detail status',
        CandidateDetailStatus.loading,
      ),
      isA<CandidatesListState>().having(
        (state) => state.detailStatus,
        'detail status',
        CandidateDetailStatus.notFound,
      ),
    ],
  );

  blocTest<CandidatesListBloc, CandidatesListState>(
    'updates status optimistically on success',
    setUp: () {
      when(() => repository.fetchCandidates()).thenAnswer(
        (_) async => Success(
          CandidatesSnapshot(
            candidates: [candidate],
            isOffline: false,
            hasPendingSync: false,
          ),
        ),
      );
      when(
        () => repository.updateStatus(
          candidateId: candidate.id,
          status: CandidateStatus.review,
        ),
      ).thenAnswer((_) async => const Success(null));
    },
    build: () => _buildBloc(repository),
    act: (bloc) async {
      bloc.add(CandidateDetailOpened(candidate.id));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const CandidateNextStatusPressed());
    },
    wait: const Duration(milliseconds: 10),
    verify: (bloc) {
      expect(bloc.state.selectedCandidate?.status, CandidateStatus.review);
      expect(
        bloc.state.visibleCandidates.single.status,
        CandidateStatus.review,
      );
      expect(bloc.state.isStatusUpdating, false);
      expect(bloc.state.statusUpdateResult, StatusUpdateResult.success);
    },
  );

  blocTest<CandidatesListBloc, CandidatesListState>(
    'rolls status back when update fails',
    setUp: () {
      when(() => repository.fetchCandidates()).thenAnswer(
        (_) async => Success(
          CandidatesSnapshot(
            candidates: [candidate],
            isOffline: false,
            hasPendingSync: false,
          ),
        ),
      );
      when(
        () => repository.updateStatus(
          candidateId: candidate.id,
          status: CandidateStatus.review,
        ),
      ).thenAnswer((_) async => Failure(Exception('server error')));
    },
    build: () => _buildBloc(repository),
    act: (bloc) async {
      bloc.add(CandidateDetailOpened(candidate.id));
      await Future<void>.delayed(Duration.zero);
      bloc.add(const CandidateNextStatusPressed());
    },
    wait: const Duration(milliseconds: 10),
    verify: (bloc) {
      expect(bloc.state.selectedCandidate?.status, CandidateStatus.fresh);
      expect(bloc.state.isStatusUpdating, false);
      expect(bloc.state.statusUpdateResult, StatusUpdateResult.failure);
    },
  );
}
