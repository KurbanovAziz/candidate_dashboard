import 'package:candidate_dashboard/core/extensions/build_context_ext.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/features/candidate_detail/widgets/candidate_detail_sections.dart';
import 'package:candidate_dashboard/features/candidate_detail/widgets/candidate_header_card.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_bloc.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateDetailContent extends StatelessWidget {
  const CandidateDetailContent({
    super.key,
    required this.candidate,
    required this.isStatusUpdating,
  });

  final Candidate candidate;
  final bool isStatusUpdating;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _DetailTopBar(candidate: candidate),
        SliverPadding(
          padding: EdgeInsets.symmetric(
            horizontal: context.pageHorizontalPadding,
            vertical: context.pageHorizontalPadding,
          ),
          sliver: SliverList.list(
            children: [
              CandidateHeaderCard(
                candidate: candidate,
                isStatusUpdating: isStatusUpdating,
                onNextStatus: () => context.read<CandidatesListBloc>().add(
                  const CandidateNextStatusPressed(),
                ),
              ),
              const SizedBox(height: 12),
              _CandidateInfoGrid(candidate: candidate),
              const SizedBox(height: 12),
              DetailSection(
                title: 'Вопросы для собеседования',
                child: QuestionsBlock(questions: candidate.questions),
              ),
              const SizedBox(height: 12),
              DetailSection(title: 'Summary', child: Text(candidate.summary)),
              SizedBox(height: context.bottomContentPadding),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailTopBar extends StatelessWidget {
  const _DetailTopBar({required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.pageHorizontalPadding),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            IconButton.filledTonal(
              onPressed: Navigator.of(context).maybePop,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Карточка кандидата',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    candidate.positionLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CandidateInfoGrid extends StatelessWidget {
  const _CandidateInfoGrid({required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    if (context.isTablet) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _LeftColumn(candidate: candidate)),
          const SizedBox(width: 12),
          Expanded(child: _RightColumn(candidate: candidate)),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _LeftColumn(candidate: candidate),
        const SizedBox(height: 12),
        _RightColumn(candidate: candidate),
      ],
    );
  }
}

class _LeftColumn extends StatelessWidget {
  const _LeftColumn({required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DetailSection(
          title: 'Контакты',
          child: ContactsBlock(candidate: candidate),
        ),
        const SizedBox(height: 12),
        DetailSection(
          title: 'Стек',
          child: StackBlock(stack: candidate.stack),
        ),
        const SizedBox(height: 12),
        DetailSection(title: 'Образование', child: Text(candidate.edu)),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn({required this.candidate});

  final Candidate candidate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DetailSection(
          title: 'Опыт работы',
          child: ExperienceBlock(items: candidate.exp),
        ),
        const SizedBox(height: 12),
        DetailSection(
          title: 'Критерии оценки',
          child: CriteriaBlock(criteria: candidate.criteria),
        ),
      ],
    );
  }
}
