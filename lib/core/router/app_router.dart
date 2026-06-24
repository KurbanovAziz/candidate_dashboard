import 'package:candidate_dashboard/core/router/app_route_path.dart';
import 'package:candidate_dashboard/features/candidate_detail/candidate_detail_page.dart';
import 'package:candidate_dashboard/features/candidates_list/candidates_list_page.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutePath.candidates,
    routes: [
      GoRoute(
        path: AppRoutePath.candidates,
        builder: (context, state) => const CandidatesListPage(),
      ),
      GoRoute(
        path: AppRoutePath.candidateDetailPattern,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return CandidateDetailPage(candidateId: id);
        },
      ),
    ],
  );
}
