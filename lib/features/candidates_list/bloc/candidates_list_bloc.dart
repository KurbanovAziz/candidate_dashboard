import 'dart:async';

import 'package:candidate_dashboard/core/utils/filter_candidates.dart';
import 'package:candidate_dashboard/core/utils/result.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/data/repositories/candidate_repository.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_event.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CandidatesListBloc
    extends Bloc<CandidatesListEvent, CandidatesListState> {
  CandidatesListBloc(this._repository) : super(const CandidatesListState()) {
    on<CandidatesListStarted>(_onStarted);
    on<CandidatesListRefreshed>(_onRefreshed);
    on<CandidatesVerdictChanged>(_onVerdictChanged);
    on<CandidatesSearchChanged>(_onSearchChanged, transformer: restartable());
    on<CandidatesSortChanged>(_onSortChanged);
    on<CandidatesNextPageRequested>(
      _onNextPageRequested,
      transformer: droppable(),
    );
    on<CandidatesCacheChanged>(_onCacheChanged);
    on<CandidateDetailOpened>(_onDetailOpened);
    on<CandidateNextStatusPressed>(_onNextStatusPressed);
    on<CandidateStatusResultConsumed>(_onStatusResultConsumed);

    _subscription = _repository.watchCandidates().listen((candidates) {
      if (candidates.isNotEmpty) add(CandidatesCacheChanged(candidates));
    });
  }

  final CandidateRepository _repository;
  StreamSubscription<List<Candidate>>? _subscription;

  Future<void> _onStarted(
    CandidatesListStarted event,
    Emitter<CandidatesListState> emit,
  ) async {
    await _loadCandidates(
      emit,
      failureMessage: 'Не удалось загрузить кандидатов',
    );
  }

  Future<void> _onRefreshed(
    CandidatesListRefreshed event,
    Emitter<CandidatesListState> emit,
  ) async {
    await _loadCandidates(
      emit,
      isRefresh: true,
      failureMessage: 'Не удалось обновить список',
    );
  }

  void _onVerdictChanged(
    CandidatesVerdictChanged event,
    Emitter<CandidatesListState> emit,
  ) {
    emit(
      state.withFilteredCandidates(
        verdict: event.verdict,
        clearVerdict: event.verdict == null,
        visibleCount: candidatesPageSize,
      ),
    );
  }

  Future<void> _onSearchChanged(
    CandidatesSearchChanged event,
    Emitter<CandidatesListState> emit,
  ) async {
    await Future<void>.delayed(_searchDebounce);
    if (emit.isDone) return;
    emit(
      state.withFilteredCandidates(
        query: event.query,
        visibleCount: candidatesPageSize,
      ),
    );
  }

  void _onSortChanged(
    CandidatesSortChanged event,
    Emitter<CandidatesListState> emit,
  ) {
    emit(
      state.withFilteredCandidates(
        sort: event.sort,
        visibleCount: candidatesPageSize,
      ),
    );
  }

  Future<void> _onNextPageRequested(
    CandidatesNextPageRequested event,
    Emitter<CandidatesListState> emit,
  ) async {
    if (state.isPageLoading || !state.hasMore) return;
    emit(state.copyWith(isPageLoading: true));
    await Future<void>.delayed(const Duration(milliseconds: 220));
    emit(
      state.withFilteredCandidates(
        visibleCount: state.visibleCount + candidatesPageSize,
        isPageLoading: false,
      ),
    );
  }

  void _onCacheChanged(
    CandidatesCacheChanged event,
    Emitter<CandidatesListState> emit,
  ) {
    emit(
      state.withFilteredCandidates(
        candidates: event.candidates,
        hasPendingSync: _repository.hasPendingSync,
      ),
    );
  }

  Future<void> _onDetailOpened(
    CandidateDetailOpened event,
    Emitter<CandidatesListState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedCandidateId: event.candidateId,
        statusUpdateResult: StatusUpdateResult.none,
        clearErrorMessage: true,
      ),
    );
    if (state.allCandidates.isNotEmpty) return;

    await _loadCandidates(
      emit,
      selectedCandidateId: event.candidateId,
      failureMessage: 'Не удалось загрузить кандидата',
    );
  }

  Future<void> _onNextStatusPressed(
    CandidateNextStatusPressed event,
    Emitter<CandidatesListState> emit,
  ) async {
    final candidate = state.selectedCandidate;
    if (candidate == null || state.isStatusUpdating) return;

    final nextStatus = candidate.status.next;
    emit(
      _replaceCandidate(candidate.copyWith(status: nextStatus)).copyWith(
        isStatusUpdating: true,
        statusUpdateResult: StatusUpdateResult.none,
        clearErrorMessage: true,
      ),
    );

    final result = await _repository.updateStatus(
      candidateId: candidate.id,
      status: nextStatus,
    );

    switch (result) {
      case Success():
        emit(
          state.copyWith(
            isStatusUpdating: false,
            statusUpdateResult: StatusUpdateResult.success,
            hasPendingSync: _repository.hasPendingSync,
          ),
        );
      case Failure():
        emit(
          _replaceCandidate(candidate).copyWith(
            isStatusUpdating: false,
            statusUpdateResult: StatusUpdateResult.failure,
            errorMessage: 'Не удалось изменить статус',
          ),
        );
    }
  }

  void _onStatusResultConsumed(
    CandidateStatusResultConsumed event,
    Emitter<CandidatesListState> emit,
  ) {
    emit(state.copyWith(statusUpdateResult: StatusUpdateResult.none));
  }

  CandidatesListState _replaceCandidate(Candidate candidate) {
    final candidates = state.allCandidates
        .map((item) => item.id == candidate.id ? candidate : item)
        .toList(growable: false);
    return state.withFilteredCandidates(candidates: candidates);
  }

  Future<void> _loadCandidates(
    Emitter<CandidatesListState> emit, {
    required String failureMessage,
    bool isRefresh = false,
    String? selectedCandidateId,
  }) async {
    emit(
      isRefresh
          ? state.copyWith(isRefreshing: true, clearErrorMessage: true)
          : state.loading().copyWith(selectedCandidateId: selectedCandidateId),
    );

    final result = await _repository.fetchCandidates();
    result.when(
      success: (snapshot) => emit(
        state.withFilteredCandidates(
          candidates: snapshot.candidates,
          isOffline: snapshot.isOffline,
          hasPendingSync: snapshot.hasPendingSync,
          isRefreshing: false,
          selectedCandidateId: selectedCandidateId,
          clearErrorMessage: true,
        ),
      ),
      failure: (error, _) =>
          emit(state.failure(failureMessage, isRefreshing: false)),
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

const _searchDebounce = Duration(milliseconds: 300);
