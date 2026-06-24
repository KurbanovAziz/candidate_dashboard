import 'package:candidate_dashboard/core/utils/result.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/data/repositories/candidate_repository.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_bloc.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_event.dart';
import 'package:candidate_dashboard/features/candidates_list/candidates_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/candidate_factory.dart';

class _MockCandidateRepository extends Mock implements CandidateRepository {}

void main() {
  late _MockCandidateRepository repository;

  setUp(() {
    repository = _MockCandidateRepository();
    when(
      () => repository.watchCandidates(),
    ).thenAnswer((_) => const Stream.empty());
    when(() => repository.hasPendingSync).thenReturn(false);
  });

  testWidgets('renders candidate cards and filters by verdict', (tester) async {
    final candidates = [
      candidateFactory(id: 'ok', name: 'Подходящий Кандидат'),
      candidateFactory(
        id: 'partial',
        name: 'Частичный Кандидат',
        verdict: Verdict.partial,
        verdictColor: VerdictColor.orange,
      ),
    ];
    when(() => repository.fetchCandidates()).thenAnswer(
      (_) async => Success(
        CandidatesSnapshot(
          candidates: candidates,
          isOffline: false,
          hasPendingSync: false,
        ),
      ),
    );

    await tester.pumpWidget(_TestApp(repository: repository));
    await tester.pump();

    expect(find.text('Подходящий Кандидат'), findsOneWidget);
    expect(find.text('Частичный Кандидат'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('verdict-filter-partial')));
    await tester.pump();

    expect(find.text('Подходящий Кандидат'), findsNothing);
    expect(find.text('Частичный Кандидат'), findsOneWidget);
  });

  testWidgets('renders empty state', (tester) async {
    when(() => repository.fetchCandidates()).thenAnswer(
      (_) async => const Success(
        CandidatesSnapshot(
          candidates: [],
          isOffline: false,
          hasPendingSync: false,
        ),
      ),
    );

    await tester.pumpWidget(_TestApp(repository: repository));
    await tester.pump();

    expect(find.text('Кандидаты не найдены'), findsOneWidget);
  });

  testWidgets('renders offline and pending sync indicators', (tester) async {
    when(() => repository.fetchCandidates()).thenAnswer(
      (_) async => Success(
        CandidatesSnapshot(
          candidates: [candidateFactory()],
          isOffline: true,
          hasPendingSync: true,
        ),
      ),
    );

    await tester.pumpWidget(_TestApp(repository: repository));
    await tester.pump();

    expect(find.text('Офлайн'), findsOneWidget);
    expect(find.text('Ждет синхр.'), findsOneWidget);
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.repository});

  final CandidateRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) =>
            CandidatesListBloc(repository)..add(const CandidatesListStarted()),
        child: const CandidatesListPage(),
      ),
    );
  }
}
