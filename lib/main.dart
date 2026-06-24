import 'package:candidate_dashboard/app.dart';
import 'package:candidate_dashboard/core/di/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const CandidateBlocObserver();
  await configureDependencies();
  runApp(CandidateDashboardApp());
}

class CandidateBlocObserver extends BlocObserver {
  const CandidateBlocObserver();

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    debugPrint('${bloc.runtimeType}: $error');
    super.onError(bloc, error, stackTrace);
  }
}
