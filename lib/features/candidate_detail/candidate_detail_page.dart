import 'package:candidate_dashboard/core/extensions/build_context_ext.dart';
import 'package:candidate_dashboard/core/widgets/base_app_button.dart';
import 'package:candidate_dashboard/features/candidate_detail/widgets/candidate_detail_content.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_bloc.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_event.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidateDetailPage extends StatefulWidget {
  const CandidateDetailPage({super.key, required this.candidateId});

  final String candidateId;

  @override
  State<CandidateDetailPage> createState() => _CandidateDetailPageState();
}

class _CandidateDetailPageState extends State<CandidateDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<CandidatesListBloc>().add(
      CandidateDetailOpened(widget.candidateId),
    );
  }

  @override
  void didUpdateWidget(covariant CandidateDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.candidateId == widget.candidateId) return;
    context.read<CandidatesListBloc>().add(
      CandidateDetailOpened(widget.candidateId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CandidatesListBloc, CandidatesListState>(
      listenWhen: (previous, current) =>
          previous.statusUpdateResult != current.statusUpdateResult,
      listener: _listenStatusUpdate,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        body: SafeArea(
          bottom: false,
          child: BlocBuilder<CandidatesListBloc, CandidatesListState>(
            builder: (context, state) {
              return switch (state.detailStatus) {
                CandidateDetailStatus.loading => const Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
                CandidateDetailStatus.failure => DetailErrorView(
                  message: state.errorMessage ?? 'Ошибка загрузки',
                  onRetry: () => context.read<CandidatesListBloc>().add(
                    CandidateDetailOpened(state.selectedCandidateId ?? ''),
                  ),
                ),
                CandidateDetailStatus.notFound => const DetailNotFoundView(),
                CandidateDetailStatus.success => CandidateDetailContent(
                  candidate: state.selectedCandidate!,
                  isStatusUpdating: state.isStatusUpdating,
                ),
              };
            },
          ),
        ),
      ),
    );
  }

  void _listenStatusUpdate(BuildContext context, CandidatesListState state) {
    final result = state.statusUpdateResult;
    if (result == StatusUpdateResult.none) return;

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          result == StatusUpdateResult.success
              ? 'Статус обновлен'
              : state.errorMessage ?? 'Ошибка изменения статуса',
        ),
      ),
    );

    context.read<CandidatesListBloc>().add(
      const CandidateStatusResultConsumed(),
    );
  }
}

class DetailNotFoundView extends StatelessWidget {
  const DetailNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.pageHorizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_off_outlined, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              'Кандидат не найден',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailErrorView extends StatelessWidget {
  const DetailErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.pageHorizontalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: theme.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            BaseAppButton(
              label: 'Повторить',
              icon: Icons.refresh_rounded,
              onTap: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
