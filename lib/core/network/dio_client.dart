import 'package:candidate_dashboard/core/network/candidate_backend_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  const DioClient._();

  static Dio build({required CandidateBackendInterceptor interceptor}) {
    return Dio(BaseOptions(baseUrl: 'https://candidate-dashboard.local'))
      ..interceptors.add(interceptor);
  }
}
