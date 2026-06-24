import 'package:candidate_dashboard/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CandidateDashboardApp extends StatelessWidget {
  const CandidateDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Candidate Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const Scaffold(
        body: Center(child: Text('Candidate Dashboard')),
      ),
    );
  }
}
