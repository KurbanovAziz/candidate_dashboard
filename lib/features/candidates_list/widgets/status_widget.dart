import 'package:candidate_dashboard/core/utils/candidate_colors.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:flutter/material.dart';

class StatusWidget extends StatelessWidget {
  const StatusWidget({super.key, required this.status});

  final CandidateStatus status;

  @override
  Widget build(BuildContext context) {
    final color = processingStatusColor(context, status);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          status.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
