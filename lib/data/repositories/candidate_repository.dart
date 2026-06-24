import 'package:candidate_dashboard/core/utils/result.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';

abstract interface class CandidateRepository {
  Future<Result<CandidatesSnapshot>> fetchCandidates();

  Future<Result<void>> updateStatus({
    required String candidateId,
    required CandidateStatus status,
  });

  Stream<List<Candidate>> watchCandidates();

  bool get hasPendingSync;
}

class CandidatesSnapshot {
  const CandidatesSnapshot({
    required this.candidates,
    required this.isOffline,
    required this.hasPendingSync,
  });

  final List<Candidate> candidates;
  final bool isOffline;
  final bool hasPendingSync;
}
