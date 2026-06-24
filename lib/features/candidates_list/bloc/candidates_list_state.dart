import 'package:candidate_dashboard/core/extensions/object_ext.dart';
import 'package:candidate_dashboard/core/utils/filter_candidates.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:equatable/equatable.dart';

enum CandidatesListStatus { initial, loading, success, failure }

enum CandidateDetailStatus { loading, success, notFound, failure }

enum StatusUpdateResult { none, success, failure }

class CandidatesListState extends Equatable {
  const CandidatesListState({
    this.status = CandidatesListStatus.initial,
    this.allCandidates = const [],
    this.visibleCandidates = const [],
    this.verdict,
    this.query = '',
    this.sort = CandidateSort.dateAdded,
    this.visibleCount = 10,
    this.filteredCount = 0,
    this.isPageLoading = false,
    this.isOffline = false,
    this.hasPendingSync = false,
    this.isRefreshing = false,
    this.selectedCandidateId,
    this.isStatusUpdating = false,
    this.statusUpdateResult = StatusUpdateResult.none,
    this.errorMessage,
  });

  final CandidatesListStatus status;
  final List<Candidate> allCandidates;
  final List<Candidate> visibleCandidates;
  final Verdict? verdict;
  final String query;
  final CandidateSort sort;
  final int visibleCount;
  final int filteredCount;
  final bool isPageLoading;
  final bool isOffline;
  final bool hasPendingSync;
  final bool isRefreshing;
  final String? selectedCandidateId;
  final bool isStatusUpdating;
  final StatusUpdateResult statusUpdateResult;
  final String? errorMessage;

  bool get hasMore => visibleCandidates.length < filteredCount;

  Candidate? get selectedCandidate => allCandidates
      .where((candidate) => candidate.id == selectedCandidateId)
      .firstOrNull;

  CandidateDetailStatus get detailStatus {
    if (status == CandidatesListStatus.loading ||
        status == CandidatesListStatus.initial) {
      return CandidateDetailStatus.loading;
    }
    if (status == CandidatesListStatus.failure) {
      return CandidateDetailStatus.failure;
    }
    return selectedCandidate == null
        ? CandidateDetailStatus.notFound
        : CandidateDetailStatus.success;
  }

  CandidatesListState loading() {
    return copyWith(
      status: CandidatesListStatus.loading,
      clearErrorMessage: true,
    );
  }

  CandidatesListState failure(String message, {bool isRefreshing = false}) {
    return copyWith(
      status: CandidatesListStatus.failure,
      isRefreshing: isRefreshing,
      errorMessage: message,
    );
  }

  CandidatesListState withFilteredCandidates({
    List<Candidate>? candidates,
    Verdict? verdict,
    bool clearVerdict = false,
    String? query,
    CandidateSort? sort,
    int? visibleCount,
    bool? isOffline,
    bool? hasPendingSync,
    bool? isRefreshing,
    bool? isPageLoading,
    String? selectedCandidateId,
    bool? isStatusUpdating,
    StatusUpdateResult? statusUpdateResult,
    CandidatesListStatus status = CandidatesListStatus.success,
    bool clearErrorMessage = false,
  }) {
    final source = candidates ?? allCandidates;
    final nextVerdict = clearVerdict ? null : verdict ?? this.verdict;
    final nextQuery = query ?? this.query;
    final nextSort = sort ?? this.sort;
    final nextVisibleCount = visibleCount ?? this.visibleCount;
    final filtered = filterAndSortCandidates(
      source: source,
      verdict: nextVerdict,
      query: nextQuery,
      sort: nextSort,
    );

    return copyWith(
      status: status,
      allCandidates: source,
      visibleCandidates: filtered.take(nextVisibleCount).toList(),
      filteredCount: filtered.length,
      verdict: nextVerdict,
      clearVerdict: clearVerdict,
      query: nextQuery,
      sort: nextSort,
      visibleCount: nextVisibleCount,
      isOffline: isOffline,
      hasPendingSync: hasPendingSync,
      isRefreshing: isRefreshing,
      isPageLoading: isPageLoading,
      selectedCandidateId: selectedCandidateId,
      isStatusUpdating: isStatusUpdating,
      statusUpdateResult: statusUpdateResult,
      clearErrorMessage: clearErrorMessage,
    );
  }

  CandidatesListState copyWith({
    CandidatesListStatus? status,
    List<Candidate>? allCandidates,
    List<Candidate>? visibleCandidates,
    Verdict? verdict,
    bool clearVerdict = false,
    String? query,
    CandidateSort? sort,
    int? visibleCount,
    int? filteredCount,
    bool? isPageLoading,
    bool? isOffline,
    bool? hasPendingSync,
    bool? isRefreshing,
    String? selectedCandidateId,
    bool clearSelectedCandidateId = false,
    bool? isStatusUpdating,
    StatusUpdateResult? statusUpdateResult,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return CandidatesListState(
      status: status ?? this.status,
      allCandidates: allCandidates ?? this.allCandidates,
      visibleCandidates: visibleCandidates ?? this.visibleCandidates,
      verdict: clearVerdict ? null : verdict ?? this.verdict,
      query: query ?? this.query,
      sort: sort ?? this.sort,
      visibleCount: visibleCount ?? this.visibleCount,
      filteredCount: filteredCount ?? this.filteredCount,
      isPageLoading: isPageLoading ?? this.isPageLoading,
      isOffline: isOffline ?? this.isOffline,
      hasPendingSync: hasPendingSync ?? this.hasPendingSync,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      selectedCandidateId: clearSelectedCandidateId
          ? null
          : selectedCandidateId ?? this.selectedCandidateId,
      isStatusUpdating: isStatusUpdating ?? this.isStatusUpdating,
      statusUpdateResult: statusUpdateResult ?? this.statusUpdateResult,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allCandidates,
    visibleCandidates,
    verdict,
    query,
    sort,
    visibleCount,
    filteredCount,
    isPageLoading,
    isOffline,
    hasPendingSync,
    isRefreshing,
    selectedCandidateId,
    isStatusUpdating,
    statusUpdateResult,
    errorMessage,
  ];
}
