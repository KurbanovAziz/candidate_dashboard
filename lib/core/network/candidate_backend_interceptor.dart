import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

class CandidateBackendInterceptor extends Interceptor {
  CandidateBackendInterceptor({
    required AssetBundle assetBundle,
    Random? random,
    this.useLargeDataset = false,
  }) : _assetBundle = assetBundle,
       _random = random ?? Random();

  final AssetBundle _assetBundle;
  final Random _random;
  final bool useLargeDataset;

  static const _candidatesPath = '/candidates';
  static const _smallDatasetPath = 'assets/data/candidates.json';
  static const _largeDatasetPath = 'assets/data/candidates-large.json';
  static const _minDelayMs = 300;
  static const _maxExtraDelayMs = 500;
  static const _statusPatchFailureChance = 10;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await Future<void>.delayed(
      Duration(
        milliseconds: _minDelayMs + _random.nextInt(_maxExtraDelayMs + 1),
      ),
    );

    if (options.path == _candidatesPath && options.method == 'GET') {
      final assetPath = useLargeDataset ? _largeDatasetPath : _smallDatasetPath;
      final jsonText = await _assetBundle.loadString(assetPath);
      handler.resolve(
        Response(
          requestOptions: options,
          statusCode: 200,
          data: jsonDecode(jsonText),
        ),
      );
      return;
    }

    if (_isStatusPatch(options)) {
      if (_random.nextInt(100) < _statusPatchFailureChance) {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: options,
              statusCode: 503,
              data: {'message': 'Candidate service temporary failure'},
            ),
          ),
        );
        return;
      }

      handler.resolve(
        Response(requestOptions: options, statusCode: 200, data: options.data),
      );
      return;
    }

    super.onRequest(options, handler);
  }

  bool _isStatusPatch(RequestOptions options) {
    return options.method == 'PATCH' &&
        options.path.startsWith('$_candidatesPath/') &&
        options.path.endsWith('/status');
  }
}
