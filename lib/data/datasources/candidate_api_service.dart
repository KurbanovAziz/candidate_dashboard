import 'package:candidate_dashboard/data/models/candidate.dart';

abstract interface class CandidateApiService {
  Future<List<Candidate>> getCandidates();

  Future<void> updateCandidateStatus({
    required String candidateId,
    required CandidateStatus status,
  });
}
