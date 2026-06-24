import 'package:candidate_dashboard/core/network/candidate_backend_interceptor.dart';
import 'package:candidate_dashboard/core/network/dio_client.dart';
import 'package:candidate_dashboard/core/theme/theme_controller.dart';
import 'package:candidate_dashboard/data/datasources/candidate_api_service.dart';
import 'package:candidate_dashboard/data/datasources/candidate_local_data_source.dart';
import 'package:candidate_dashboard/data/datasources/candidate_remote_data_source.dart';
import 'package:candidate_dashboard/data/repositories/candidate_repository.dart';
import 'package:candidate_dashboard/data/repositories/candidate_repository_impl.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  await Hive.initFlutter();
  final cacheBox = await Hive.openBox<String>('candidate_cache');
  final statusBox = await Hive.openBox<String>('candidate_statuses');
  final syncQueueBox = await Hive.openBox<String>(
    'candidate_status_sync_queue',
  );
  final settingsBox = await Hive.openBox<String>('candidate_settings');

  getIt
    ..registerLazySingleton<AssetBundle>(() => rootBundle)
    ..registerLazySingleton<CandidateBackendInterceptor>(
      () => CandidateBackendInterceptor(assetBundle: getIt<AssetBundle>()),
    )
    ..registerLazySingleton<Dio>(
      () => DioClient.build(interceptor: getIt<CandidateBackendInterceptor>()),
    )
    ..registerLazySingleton<CandidateApiService>(
      () => CandidateRemoteDataSource(getIt<Dio>()),
    )
    ..registerLazySingleton<CandidateLocalDataSource>(
      () => CandidateLocalDataSource(
        cacheBox: cacheBox,
        statusBox: statusBox,
        syncQueueBox: syncQueueBox,
      ),
    )
    ..registerLazySingleton<CandidateRepository>(
      () => CandidateRepositoryImpl(
        apiService: getIt<CandidateApiService>(),
        localDataSource: getIt<CandidateLocalDataSource>(),
      ),
    )
    ..registerFactory(() => CandidatesListBloc(getIt<CandidateRepository>()))
    ..registerLazySingleton(() => ThemeController(settingsBox));
}
