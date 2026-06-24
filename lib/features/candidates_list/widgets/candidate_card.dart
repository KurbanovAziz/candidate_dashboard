import 'package:candidate_dashboard/core/utils/candidate_colors.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/info_widget.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/skill_chip.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/status_widget.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/verdict_widget.dart';
import 'package:flutter/material.dart';

class CandidateCard extends StatelessWidget {
  const CandidateCard({
    super.key,
    required this.candidate,
    required this.onTap,
  });

  final Candidate candidate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final verdictWidgetColor = verdictColor(context, candidate.verdictColor);

    final stackItems = candidate.stack
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .take(4)
        .toList();

    final letter = candidate.name.trim().isEmpty
        ? '?'
        : candidate.name.trim()[0].toUpperCase();

    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.045),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              Positioned.fill(
                right: null,
                child: ColoredBox(
                  color: verdictWidgetColor,
                  child: const SizedBox(width: 6),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  theme.colorScheme.primary,
                                  theme.colorScheme.tertiary,
                                ],
                              ),
                            ),
                            child: Text(
                              letter,
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  candidate.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  candidate.stack,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoWidget(
                            icon: Icons.location_on_outlined,
                            text: candidate.city,
                          ),
                          InfoWidget(
                            icon: Icons.work_outline_rounded,
                            text: candidate.totalExperience,
                          ),
                          StatusWidget(status: candidate.status),
                        ],
                      ),

                      if (stackItems.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final item in stackItems)
                              SkillChip(text: item),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          VerdictWidget(
                            verdict: candidate.verdict,
                            color: candidate.verdictColor,
                          ),
                          const Spacer(),
                          Text(
                            'Подробнее',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
