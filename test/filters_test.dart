import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/core/utils/filter_candidates.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/candidate_factory.dart';

void main() {
  test('candidate status labels match task text', () {
    expect(CandidateStatus.fresh.label, 'Новый');
    expect(CandidateStatus.review.label, 'На рассмотрении');
    expect(CandidateStatus.invited.label, 'Приглашён');
    expect(CandidateStatus.rejected.label, 'Отклонён');
  });

  group('filterAndSortCandidates', () {
    test('filters by verdict and name query', () {
      final candidates = [
        candidateFactory(id: 'a', name: 'Айбек Токтосунов'),
        candidateFactory(
          id: 'b',
          name: 'Мария Иванова',
          verdict: Verdict.partial,
          verdictColor: VerdictColor.orange,
        ),
      ];

      final result = filterAndSortCandidates(
        source: candidates,
        verdict: Verdict.partial,
        query: 'мария',
        sort: CandidateSort.name,
      );

      expect(result, hasLength(1));
      expect(result.single.id, 'b');
    });

    test('sorts by experience desc and date added desc', () {
      final low = candidateFactory(
        id: 'low',
        totalExperience: '~1.2 г.',
        dateAdded: DateTime(2026, 1, 1),
      );
      final high = candidateFactory(
        id: 'high',
        totalExperience: '~5.8 г.',
        dateAdded: DateTime(2026, 1, 2),
      );

      final byExperience = filterAndSortCandidates(
        source: [low, high],
        verdict: null,
        query: '',
        sort: CandidateSort.experience,
      );
      final byDate = filterAndSortCandidates(
        source: [low, high],
        verdict: null,
        query: '',
        sort: CandidateSort.dateAdded,
      );

      expect(byExperience.first.id, 'high');
      expect(byDate.first.id, 'high');
    });

    test('returns empty list for empty source', () {
      final result = filterAndSortCandidates(
        source: const [],
        verdict: null,
        query: 'anything',
        sort: CandidateSort.name,
      );

      expect(result, isEmpty);
    });
  });
}
