import 'package:candidate_dashboard/core/utils/result.dart';
import 'package:candidate_dashboard/data/datasources/candidate_api_service.dart';
import 'package:candidate_dashboard/data/datasources/candidate_local_data_source.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:candidate_dashboard/data/repositories/candidate_repository.dart';
import 'package:dio/dio.dart';

class CandidateRepositoryImpl implements CandidateRepository {
  const CandidateRepositoryImpl({
    required CandidateApiService apiService,
    required CandidateLocalDataSource localDataSource,
  }) : _apiService = apiService,
       _localDataSource = localDataSource;

  final CandidateApiService _apiService;
  final CandidateLocalDataSource _localDataSource;

  @override
  Future<Result<CandidatesSnapshot>> fetchCandidates() async {
    try {
      await _syncPendingStatuses();
      await _localDataSource.saveCandidates(await _apiService.getCandidates());
      return Success(await _snapshot(isOffline: false));
    } catch (error, stackTrace) {
      final cached = await _localDataSource.readCandidates();
      if (cached.isNotEmpty) {
        return Success(_snapshotFrom(cached, isOffline: true));
      }
      return Failure(error, stackTrace);
    }
  }

  @override
  Future<Result<void>> updateStatus({
    required String candidateId,
    required CandidateStatus status,
  }) async {
    final previous = await _currentStatus(candidateId);
    await _localDataSource.saveStatus(candidateId, status);

    try {
      await _apiService.updateCandidateStatus(
        candidateId: candidateId,
        status: status,
      );
      await _localDataSource.removeStatusSync(candidateId);
      return const Success(null);
    } catch (error, stackTrace) {
      if (_isConnectionError(error)) {
        await _localDataSource.enqueueStatusSync(candidateId, status);
        return const Success(null);
      }

      await _localDataSource.saveStatus(candidateId, previous);
      return Failure(error, stackTrace);
    }
  }

  @override
  Stream<List<Candidate>> watchCandidates() =>
      _localDataSource.watchCandidates();

  @override
  bool get hasPendingSync => _localDataSource.pendingStatusSync().isNotEmpty;

  Future<void> _syncPendingStatuses() async {
    for (final entry in _localDataSource.pendingStatusSync().entries) {
      try {
        await _apiService.updateCandidateStatus(
          candidateId: entry.key,
          status: entry.value,
        );
      } catch (_) {
        break;
      }
      await _localDataSource.saveStatus(entry.key, entry.value);
      await _localDataSource.removeStatusSync(entry.key);
    }
  }

  Future<CandidatesSnapshot> _snapshot({required bool isOffline}) async {
    return _snapshotFrom(
      await _localDataSource.readCandidates(),
      isOffline: isOffline,
    );
  }

  CandidatesSnapshot _snapshotFrom(
    List<Candidate> candidates, {
    required bool isOffline,
  }) {
    return CandidatesSnapshot(
      candidates: candidates,
      isOffline: isOffline,
      hasPendingSync: hasPendingSync,
    );
  }

  Future<CandidateStatus> _currentStatus(String candidateId) async {
    for (final candidate in await _localDataSource.readCandidates()) {
      if (candidate.id == candidateId) return candidate.status;
    }
    return CandidateStatus.fresh;
  }

  bool _isConnectionError(Object error) {
    return error is DioException &&
        error.type == DioExceptionType.connectionError;
  }
}
