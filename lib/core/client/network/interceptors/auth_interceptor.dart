import 'package:dio/dio.dart';
import '../abstract_auth_session.dart';

/// Interceptor that inspects the `isLoggedIn` flag via [AbstractAuthSession]
/// and automatically attaches Authorization headers to requests.
class AuthInterceptor extends Interceptor {
  final AbstractAuthSession authSession;
  final bool requireAuthByDefault;

  AuthInterceptor({
    required this.authSession,
    this.requireAuthByDefault = true,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool requiresAuth = options.extra['requiresAuth'] as bool? ?? requireAuthByDefault;

    if (requiresAuth) {
      final bool loggedIn = await authSession.isLoggedIn;
      options.extra['isLoggedIn'] = loggedIn;

      if (loggedIn) {
        final String? token = await authSession.authToken;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      authSession.onUnauthenticated();
    }
    return handler.next(err);
  }
}
