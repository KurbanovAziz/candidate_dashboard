import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:flutter/material.dart';

Color verdictColor(BuildContext context, VerdictColor color) {
  return switch (color) {
    VerdictColor.green => const Color(0xFF15803D),
    VerdictColor.orange => const Color(0xFFC2410C),
    VerdictColor.red => const Color(0xFFB91C1C),
  };
}

Color criterionColor(BuildContext context, CriterionStatus status) {
  return switch (status) {
    CriterionStatus.ok => const Color(0xFF15803D),
    CriterionStatus.warn => const Color(0xFFC2410C),
    CriterionStatus.no => const Color(0xFFB91C1C),
  };
}

Color processingStatusColor(BuildContext context, CandidateStatus status) {
  return switch (status) {
    CandidateStatus.fresh => Theme.of(context).colorScheme.primary,
    CandidateStatus.review => const Color(0xFF7C3AED),
    CandidateStatus.invited => const Color(0xFF15803D),
    CandidateStatus.rejected => const Color(0xFFB91C1C),
  };
}
