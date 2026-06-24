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

CandidatesListBloc _buildBloc(CandidateRepository repository) {
  return CandidatesListBloc(repository);
}

void main() {
  late _MockCandidateRepository repository;
  late List<Candidate> candidates;

  setUp(() {
    repository = _MockCandidateRepository();
    candidates = List.generate(
      12,
      (index) => candidateFactory(
        id: 'id_$index',
        name: 'Candidate $index',
        verdict: index.isEven ? Verdict.suitable : Verdict.partial,
        verdictColor: index.isEven ? VerdictColor.green : VerdictColor.orange,
      ),
    );

    when(
      () => repository.watchCandidates(),
    ).thenAnswer((_) => const Stream.empty());
    when(() => repository.hasPendingSync).thenReturn(false);
    when(() => repository.fetchCandidates()).thenAnswer(
      (_) async => Success(
        CandidatesSnapshot(
          candidates: candidates,
          isOffline: false,
          hasPendingSync: false,
        ),
      ),
    );
  });

  blocTest<CandidatesListBloc, CandidatesListState>(
    'loads first page and keeps pagination metadata',
    build: () => _buildBloc(repository),
    act: (bloc) => bloc.add(const CandidatesListStarted()),
    expect: () => [
      isA<CandidatesListState>().having(
        (state) => state.status,
        'status',
        CandidatesListStatus.loading,
      ),
      isA<CandidatesListState>()
          .having(
            (state) => state.status,
            'status',
            CandidatesListStatus.success,
          )
          .having(
            (state) => state.visibleCandidates.length,
            'visible count',
            10,
          )
          .having((state) => state.visibleCount, 'page size', 10)
          .having((state) => state.hasMore, 'has more', true),
    ],
  );

  blocTest<CandidatesListBloc, CandidatesListState>(
    'filters by verdict',
    build: () => _buildBloc(repository),
    act: (bloc) {
      bloc
        ..add(const CandidatesListStarted())
        ..add(const CandidatesVerdictChanged(Verdict.partial));
    },
    wait: const Duration(milliseconds: 10),
    verify: (bloc) {
      expect(
        bloc.state.visibleCandidates,
        everyElement(
          isA<Candidate>().having(
            (item) => item.verdict,
            'verdict',
            Verdict.partial,
          ),
        ),
      );
    },
  );

  blocTest<CandidatesListBloc, CandidatesListState>(
    'loads next page with loading flag',
    build: () => _buildBloc(repository),
    act: (bloc) async {
      bloc.add(const CandidatesListStarted());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const CandidatesNextPageRequested());
    },
    wait: const Duration(milliseconds: 260),
    verify: (bloc) {
      expect(bloc.state.visibleCandidates.length, 12);
      expect(bloc.state.hasMore, false);
      expect(bloc.state.isPageLoading, false);
    },
  );

  blocTest<CandidatesListBloc, CandidatesListState>(
    'does not apply search before 300 ms debounce',
    build: () => _buildBloc(repository),
    act: (bloc) async {
      bloc.add(const CandidatesListStarted());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const CandidatesSearchChanged('Candidate 11'));
    },
    wait: const Duration(milliseconds: 250),
    verify: (bloc) {
      expect(bloc.state.query, isEmpty);
      expect(bloc.state.visibleCandidates.length, 10);
    },
  );

  blocTest<CandidatesListBloc, CandidatesListState>(
    'search uses debounce and applies last query',
    build: () => _buildBloc(repository),
    act: (bloc) async {
      bloc.add(const CandidatesListStarted());
      bloc
        ..add(const CandidatesSearchChanged('Candidate 1'))
        ..add(const CandidatesSearchChanged('Candidate 11'));
    },
    wait: const Duration(milliseconds: 350),
    verify: (bloc) {
      expect(bloc.state.query, 'Candidate 11');
      expect(bloc.state.visibleCandidates.single.id, 'id_11');
      verify(() => repository.fetchCandidates()).called(1);
    },
  );

  blocTest<CandidatesListBloc, CandidatesListState>(
    'emits failure when repository fails without cache',
    setUp: () {
      when(
        () => repository.fetchCandidates(),
      ).thenAnswer((_) async => Failure(Exception('network')));
    },
    build: () => _buildBloc(repository),
    act: (bloc) => bloc.add(const CandidatesListStarted()),
    expect: () => [
      isA<CandidatesListState>().having(
        (state) => state.status,
        'status',
        CandidatesListStatus.loading,
      ),
      isA<CandidatesListState>().having(
        (state) => state.status,
        'status',
        CandidatesListStatus.failure,
      ),
    ],
  );
}
