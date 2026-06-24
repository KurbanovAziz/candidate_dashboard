import 'package:candidate_dashboard/core/utils/candidate_colors.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:flutter/material.dart';

class VerdictWidget extends StatelessWidget {
  const VerdictWidget({super.key, required this.verdict, required this.color});

  final Verdict verdict;
  final VerdictColor color;

  @override
  Widget build(BuildContext context) {
    final verdictWidgetColor = verdictColor(context, color);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: verdictWidgetColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          verdict.label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: verdictWidgetColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
