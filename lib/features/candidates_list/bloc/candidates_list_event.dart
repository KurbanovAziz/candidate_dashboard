import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:equatable/equatable.dart';

sealed class CandidatesListEvent extends Equatable {
  const CandidatesListEvent();

  @override
  List<Object?> get props => const [];
}

final class CandidatesListStarted extends CandidatesListEvent {
  const CandidatesListStarted();
}

final class CandidatesListRefreshed extends CandidatesListEvent {
  const CandidatesListRefreshed();
}

final class CandidatesVerdictChanged extends CandidatesListEvent {
  const CandidatesVerdictChanged(this.verdict);

  final Verdict? verdict;

  @override
  List<Object?> get props => [verdict];
}

final class CandidatesSearchChanged extends CandidatesListEvent {
  const CandidatesSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class CandidatesSortChanged extends CandidatesListEvent {
  const CandidatesSortChanged(this.sort);

  final CandidateSort sort;

  @override
  List<Object?> get props => [sort];
}

final class CandidatesNextPageRequested extends CandidatesListEvent {
  const CandidatesNextPageRequested();
}

final class CandidatesCacheChanged extends CandidatesListEvent {
  const CandidatesCacheChanged(this.candidates);

  final List<Candidate> candidates;

  @override
  List<Object?> get props => [candidates];
}

final class CandidateDetailOpened extends CandidatesListEvent {
  const CandidateDetailOpened(this.candidateId);

  final String candidateId;

  @override
  List<Object?> get props => [candidateId];
}

final class CandidateNextStatusPressed extends CandidatesListEvent {
  const CandidateNextStatusPressed();
}

final class CandidateStatusResultConsumed extends CandidatesListEvent {
  const CandidateStatusResultConsumed();
}
