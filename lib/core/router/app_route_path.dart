class AppRoutePath {
  const AppRoutePath._();

  static const candidates = '/';
  static const candidateDetailPattern = '/candidate/:id';

  static String candidateDetail(String id) =>
      '/candidate/${Uri.encodeComponent(id)}';
}
