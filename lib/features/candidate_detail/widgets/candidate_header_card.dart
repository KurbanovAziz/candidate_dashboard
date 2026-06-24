import 'package:candidate_dashboard/core/utils/candidate_colors.dart';
import 'package:candidate_dashboard/core/widgets/base_app_button.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/info_widget.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/status_widget.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/verdict_widget.dart';
import 'package:flutter/material.dart';

class CandidateHeaderCard extends StatelessWidget {
  const CandidateHeaderCard({
    super.key,
    required this.candidate,
    required this.isStatusUpdating,
    required this.onNextStatus,
  });

  final Candidate candidate;
  final bool isStatusUpdating;
  final VoidCallback onNextStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badgeColor = verdictColor(context, candidate.verdictColor);
    final letter = candidate.name.trim().isEmpty
        ? '?'
        : candidate.name.trim()[0].toUpperCase();

    return DecoratedBox(
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
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 6,
              child: ColoredBox(color: badgeColor),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final textBlock = _CandidateTitle(candidate: candidate);
                        final avatar = _CandidateAvatar(letter: letter);
                        if (constraints.maxWidth < 360) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              avatar,
                              const SizedBox(height: 12),
                              textBlock,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            avatar,
                            const SizedBox(width: 14),
                            Expanded(child: textBlock),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
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
                        VerdictWidget(
                          verdict: candidate.verdict,
                          color: candidate.verdictColor,
                        ),
                        StatusWidget(status: candidate.status),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: BaseAppButton(
                        label: 'Перевести в "${candidate.status.next.label}"',
                        icon: Icons.arrow_forward_rounded,
                        isLoading: isStatusUpdating,
                        onTap: onNextStatus,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateAvatar extends StatelessWidget {
  const _CandidateAvatar({required this.letter});

  final String letter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Text(
          letter,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CandidateTitle extends StatelessWidget {
  const _CandidateTitle({required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          candidate.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          candidate.positionLabel,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
