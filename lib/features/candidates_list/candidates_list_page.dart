import 'package:candidate_dashboard/core/di/service_locator.dart';
import 'package:candidate_dashboard/core/extensions/build_context_ext.dart';
import 'package:candidate_dashboard/core/router/app_route_path.dart';
import 'package:candidate_dashboard/core/theme/theme_controller.dart';
import 'package:candidate_dashboard/core/widgets/base_app_input.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_bloc.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_event.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_state.dart';
import 'package:candidate_dashboard/features/candidates_list/widgets/candidate_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class CandidatesListPage extends StatefulWidget {
  const CandidatesListPage({super.key});

  @override
  State<CandidatesListPage> createState() => _CandidatesListPageState();
}

class _CandidatesListPageState extends State<CandidatesListPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CandidatesListBloc>();
    if (bloc.state.status == CandidatesListStatus.initial) {
      bloc.add(const CandidatesListStarted());
    }
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final preloadOffset = MediaQuery.sizeOf(context).height * 0.35;
    if (position.pixels >= position.maxScrollExtent - preloadOffset) {
      context.read<CandidatesListBloc>().add(
        const CandidatesNextPageRequested(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator.adaptive(
          onRefresh: () {
            final bloc = context.read<CandidatesListBloc>()
              ..add(const CandidatesListRefreshed());
            return bloc.stream.firstWhere((state) => !state.isRefreshing);
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              BlocBuilder<CandidatesListBloc, CandidatesListState>(
                buildWhen: (previous, current) =>
                    previous.isOffline != current.isOffline ||
                    previous.hasPendingSync != current.hasPendingSync ||
                    previous.allCandidates.length !=
                        current.allCandidates.length,
                builder: (context, state) {
                  return _CandidatesHeader(
                    isOffline: state.isOffline,
                    hasPendingSync: state.hasPendingSync,
                    totalCount: state.allCandidates.length,
                  );
                },
              ),
              BlocBuilder<CandidatesListBloc, CandidatesListState>(
                buildWhen: (previous, current) =>
                    previous.verdict != current.verdict ||
                    previous.sort != current.sort,
                builder: (context, state) {
                  return _CandidatesFilters(
                    selectedVerdict: state.verdict,
                    selectedSort: state.sort,
                  );
                },
              ),
              BlocBuilder<CandidatesListBloc, CandidatesListState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.visibleCandidates != current.visibleCandidates ||
                    previous.hasMore != current.hasMore ||
                    previous.isPageLoading != current.isPageLoading ||
                    previous.errorMessage != current.errorMessage,
                builder: (context, state) => _CandidatesResult(state: state),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: context.bottomContentPadding),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CandidatesHeader extends StatelessWidget {
  const _CandidatesHeader({
    required this.isOffline,
    required this.hasPendingSync,
    required this.totalCount,
  });

  final bool isOffline;
  final bool hasPendingSync;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeController = getIt.isRegistered<ThemeController>()
        ? getIt<ThemeController>()
        : null;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.pageHorizontalPadding,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.18),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Кандидаты',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalCount кандидатов в базе',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    if (isOffline)
                      const _HeaderPill(
                        icon: Icons.cloud_off_outlined,
                        title: 'Офлайн',
                      ),
                    if (hasPendingSync)
                      const _HeaderPill(
                        icon: Icons.sync_rounded,
                        title: 'Ждет синхр.',
                      ),
                    if (themeController != null)
                      ListenableBuilder(
                        listenable: themeController,
                        builder: (context, child) {
                          return IconButton.filledTonal(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.16,
                              ),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: themeController.toggleDarkMode,
                            icon: Icon(
                              themeController.isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CandidatesFilters extends StatelessWidget {
  const _CandidatesFilters({
    required this.selectedVerdict,
    required this.selectedSort,
  });

  final Verdict? selectedVerdict;
  final CandidateSort selectedSort;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.pageHorizontalPadding,
          vertical: 12,
        ),
        child: DecoratedBox(
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
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: BaseAppInput(
                        key: const ValueKey('candidate-search'),
                        onChanged: (query) => context
                            .read<CandidatesListBloc>()
                            .add(CandidatesSearchChanged(query)),
                        prefixIcon: Icons.search_rounded,
                        hintText: 'Поиск по ФИО',
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () => _showSortSheet(context, selectedSort),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.tune_rounded,
                              size: 20,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              selectedSort.label,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _VerdictChip(
                        key: const ValueKey('verdict-filter-all'),
                        label: 'Все',
                        selected: selectedVerdict == null,
                        onTap: () => context.read<CandidatesListBloc>().add(
                          const CandidatesVerdictChanged(null),
                        ),
                      ),
                      for (final verdict in Verdict.values)
                        _VerdictChip(
                          key: ValueKey('verdict-filter-${verdict.name}'),
                          label: verdict.label,
                          selected: selectedVerdict == verdict,
                          onTap: () => context.read<CandidatesListBloc>().add(
                            CandidatesVerdictChanged(verdict),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showSortSheet(BuildContext context, CandidateSort selected) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final sort in CandidateSort.values)
                ListTile(
                  leading: Icon(
                    selected == sort
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  title: Text(sort.label),
                  onTap: () {
                    context.read<CandidatesListBloc>().add(
                      CandidatesSortChanged(sort),
                    );
                    Navigator.of(sheetContext).pop();
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _CandidatesResult extends StatelessWidget {
  const _CandidatesResult({required this.state});

  final CandidatesListState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == CandidatesListStatus.loading) {
      return const _CandidatesLoading();
    }
    if (state.status == CandidatesListStatus.failure) {
      return _CandidatesError(
        message: state.errorMessage ?? 'Ошибка загрузки',
        onRetry: () => context.read<CandidatesListBloc>().add(
          const CandidatesListStarted(),
        ),
      );
    }
    if (state.visibleCandidates.isEmpty) {
      return const _CandidatesEmpty(title: 'Кандидаты не найдены');
    }

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.pageHorizontalPadding),
      sliver: SliverList.separated(
        itemCount: state.visibleCandidates.length + (state.hasMore ? 1 : 0),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >= state.visibleCandidates.length) {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: state.isPageLoading
                  ? const Padding(
                      key: ValueKey('page-loader'),
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('page-loader-empty')),
            );
          }
          final candidate = state.visibleCandidates[index];
          return CandidateCard(
            key: ValueKey(candidate.id),
            candidate: candidate,
            onTap: () =>
                context.push(AppRoutePath.candidateDetail(candidate.id)),
          );
        },
      ),
    );
  }
}

class _CandidatesLoading extends StatelessWidget {
  const _CandidatesLoading();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList.separated(
        itemBuilder: (context, index) => const _SkeletonCard(),
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemCount: 8,
      ),
    );
  }
}

class _CandidatesEmpty extends StatelessWidget {
  const _CandidatesEmpty({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_search_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Попробуйте изменить фильтр или поисковый запрос',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CandidatesError extends StatelessWidget {
  const _CandidatesError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerdictChip extends StatelessWidget {
  const _VerdictChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.all(14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;
    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const SizedBox(height: 136),
      ),
    );
  }
}
