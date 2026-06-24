import 'dart:async';

import 'package:candidate_dashboard/core/utils/result.dart';
import 'package:dio/dio.dart';

extension DioRequestX on Dio {
  Future<Result<List<T>>> makeRequestList<T>({
    required Future<Response<dynamic>> Function() request,
    required T Function(Map<String, dynamic> json) fromJson,
    FutureOr<void> Function(Response<dynamic> response, List<T> model)?
    onSuccess,
  }) async {
    try {
      final response = await request();
      final model = (response.data as List<dynamic>? ?? const [])
          .map((item) => fromJson(item as Map<String, dynamic>))
          .toList(growable: false);
      await onSuccess?.call(response, model);
      return Success(model);
    } catch (error, stackTrace) {
      return Failure(error, stackTrace);
    }
  }

  Future<Result<void>> makeRequestVoid({
    required Future<Response<dynamic>> Function() request,
    FutureOr<void> Function(Response<dynamic> response)? onSuccess,
  }) async {
    try {
      final response = await request();
      await onSuccess?.call(response);
      return const Success(null);
    } catch (error, stackTrace) {
      return Failure(error, stackTrace);
    }
  }
}

extension FutureResultX<T> on Future<Result<T>> {
  Future<T> getOrThrow() async => (await this).getOrThrow();
}
