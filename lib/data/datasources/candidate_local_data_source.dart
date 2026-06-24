import 'dart:async';
import 'dart:convert';

import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:hive/hive.dart';

class CandidateLocalDataSource {
  CandidateLocalDataSource({
    required Box<String> cacheBox,
    required Box<String> statusBox,
    required Box<String> syncQueueBox,
  }) : _cacheBox = cacheBox,
       _statusBox = statusBox,
       _syncQueueBox = syncQueueBox;

  static const candidatesCacheKey = 'candidates';

  final Box<String> _cacheBox;
  final Box<String> _statusBox;
  final Box<String> _syncQueueBox;
  final StreamController<List<Candidate>> _controller =
      StreamController<List<Candidate>>.broadcast();

  Future<List<Candidate>> readCandidates() async {
    final raw = _cacheBox.get(candidatesCacheKey);
    if (raw == null) return const [];
    final list = (jsonDecode(raw) as List<dynamic>)
        .cast<Map<String, dynamic>>()
        .map(Candidate.fromJson)
        .toList(growable: false);
    return _mergeStatuses(list);
  }

  Future<void> saveCandidates(List<Candidate> candidates) async {
    final merged = _mergeStatuses(candidates);
    await _cacheBox.put(
      candidatesCacheKey,
      jsonEncode(merged.map((item) => item.toJson()).toList(growable: false)),
    );
    _controller.add(merged);
  }

  Future<void> saveStatus(String candidateId, CandidateStatus status) async {
    await _statusBox.put(candidateId, status.wireValue);
    final candidates = await readCandidates();
    _controller.add(candidates);
  }

  Future<void> enqueueStatusSync(
    String candidateId,
    CandidateStatus status,
  ) async {
    await _syncQueueBox.put(candidateId, status.wireValue);
    await _notifyCandidatesChanged();
  }

  Future<void> removeStatusSync(String candidateId) async {
    await _syncQueueBox.delete(candidateId);
    await _notifyCandidatesChanged();
  }

  Map<String, CandidateStatus> pendingStatusSync() {
    return Map.fromEntries(
      _syncQueueBox.toMap().entries.map(
        (entry) => MapEntry(
          entry.key as String,
          CandidateStatus.values.firstWhere(
            (status) => status.wireValue == entry.value,
          ),
        ),
      ),
    );
  }

  Stream<List<Candidate>> watchCandidates() async* {
    yield await readCandidates();
    yield* _controller.stream;
  }

  List<Candidate> _mergeStatuses(List<Candidate> candidates) {
    return candidates
        .map(
          (candidate) => candidate.copyWith(
            status: CandidateStatus.values.firstWhere(
              (status) => status.wireValue == _statusBox.get(candidate.id),
              orElse: () => candidate.status,
            ),
          ),
        )
        .toList(growable: false);
  }

  Future<void> _notifyCandidatesChanged() async {
    _controller.add(await readCandidates());
  }
}
