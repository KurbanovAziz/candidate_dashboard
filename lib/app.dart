import 'package:candidate_dashboard/core/di/service_locator.dart';
import 'package:candidate_dashboard/core/router/app_router.dart';
import 'package:candidate_dashboard/core/theme/app_theme.dart';
import 'package:candidate_dashboard/core/theme/theme_controller.dart';
import 'package:candidate_dashboard/features/candidates_list/bloc/candidates_list_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CandidateDashboardApp extends StatelessWidget {
  CandidateDashboardApp({super.key})
    : _router = createAppRouter(),
      _themeController = getIt<ThemeController>();

  final GoRouter _router;
  final ThemeController _themeController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CandidatesListBloc>(),
      child: ListenableBuilder(
        listenable: _themeController,
        builder: (context, child) {
          return MaterialApp.router(
            title: 'Candidate Dashboard',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: _themeController.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
