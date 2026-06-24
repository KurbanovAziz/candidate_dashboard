import 'package:candidate_dashboard/core/utils/candidate_colors.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/info_widget.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/skill_chip.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class ContactsBlock extends StatelessWidget {
  const ContactsBlock({super.key, required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactTile(
          icon: Icons.phone_outlined,
          title: candidate.phone,
          onTap: () => _launch('tel:${candidate.phone}'),
        ),
        _ContactTile(
          icon: Icons.mail_outline_rounded,
          title: candidate.email,
          onTap: () => _launch('mailto:${candidate.email}'),
        ),
        _ContactTile(
          icon: Icons.telegram,
          title: candidate.tg,
          onTap: () =>
              _launch('https://t.me/${candidate.tg.replaceFirst('@', '')}'),
        ),
      ],
    );
  }

  Future<void> _launch(String uri) async {
    await launchUrl(Uri.parse(uri), mode: LaunchMode.externalApplication);
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.45,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Icon(icon, color: theme.colorScheme.primary),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Icon(
                Icons.open_in_new_rounded,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StackBlock extends StatelessWidget {
  const StackBlock({super.key, required this.stack});

  final String stack;

  @override
  Widget build(BuildContext context) {
    final items = stack
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList(growable: false);

    if (items.isEmpty) {
      return const Text('Стек не указан');
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [for (final item in items) SkillChip(text: item)],
    );
  }
}

class ExperienceBlock extends StatelessWidget {
  const ExperienceBlock({super.key, required this.items});

  final List<Experience> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (items.isEmpty) {
      return const Text('Опыт работы не указан');
    }

    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.08,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          Icons.work_outline_rounded,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.role,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.company,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              InfoWidget(
                                icon: Icons.calendar_month_outlined,
                                text: item.period,
                              ),
                              InfoWidget(
                                icon: Icons.schedule_rounded,
                                text: item.duration,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class CriteriaBlock extends StatelessWidget {
  const CriteriaBlock({super.key, required this.criteria});

  final List<Criterion> criteria;

  @override
  Widget build(BuildContext context) {
    if (criteria.isEmpty) {
      return const Text('Критерии не указаны');
    }

    return Column(
      children: [
        for (final criterion in criteria)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: criterionColor(
                  context,
                  criterion.status,
                ).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _icon(criterion.status),
                      color: criterionColor(context, criterion.status),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(criterion.text)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  IconData _icon(CriterionStatus status) {
    return switch (status) {
      CriterionStatus.ok => Icons.check_circle_outline_rounded,
      CriterionStatus.warn => Icons.error_outline_rounded,
      CriterionStatus.no => Icons.cancel_outlined,
    };
  }
}

class QuestionsBlock extends StatelessWidget {
  const QuestionsBlock({super.key, required this.questions});

  final List<String> questions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (questions.isEmpty) {
      return const Text('Вопросы не указаны');
    }

    return Column(
      children: [
        for (final question in questions)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.45,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help_outline_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(question)),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
