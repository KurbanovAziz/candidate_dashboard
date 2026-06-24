import 'package:candidate_dashboard/data/models/candidate.dart';

const int candidatesPageSize = 10;

List<Candidate> filterAndSortCandidates({
  required List<Candidate> source,
  required Verdict? verdict,
  required String query,
  required CandidateSort sort,
}) {
  final normalizedQuery = query.trim().toLowerCase();
  final filtered = source.where((candidate) {
    final matchesVerdict = verdict == null || candidate.verdict == verdict;
    final matchesQuery =
        normalizedQuery.isEmpty ||
        candidate.name.toLowerCase().contains(normalizedQuery);
    return matchesVerdict && matchesQuery;
  }).toList();

  filtered.sort((a, b) {
    return switch (sort) {
      CandidateSort.name => a.name.compareTo(b.name),
      CandidateSort.experience => _experienceYears(
        b,
      ).compareTo(_experienceYears(a)),
      CandidateSort.dateAdded => (b.dateAdded ?? DateTime(1900)).compareTo(
        a.dateAdded ?? DateTime(1900),
      ),
    };
  });

  return filtered;
}

double _experienceYears(Candidate candidate) {
  final match = RegExp(
    r'(\d+(?:[.,]\d+)?)',
  ).firstMatch(candidate.totalExperience);
  return double.tryParse(match?.group(1)?.replaceAll(',', '.') ?? '') ?? 0;
}
