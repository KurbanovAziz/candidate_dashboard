import 'package:candidate_dashboard/core/network/dio_request.dart';
import 'package:candidate_dashboard/data/models/candidate.dart';
import 'package:dio/dio.dart';

import 'candidate_api_service.dart';

class CandidateRemoteDataSource implements CandidateApiService {
  const CandidateRemoteDataSource(this._dio);

  final Dio _dio;

  @override
  Future<List<Candidate>> getCandidates() => _dio
      .makeRequestList(
        request: () => _dio.get('/candidates'),
        fromJson: Candidate.fromJson,
      )
      .getOrThrow();

  @override
  Future<void> updateCandidateStatus({
    required String candidateId,
    required CandidateStatus status,
  }) => _dio
      .makeRequestVoid(
        request: () => _dio.patch(
          '/candidates/$candidateId/status',
          data: {'status': status.wireValue},
        ),
      )
      .getOrThrow();
}
