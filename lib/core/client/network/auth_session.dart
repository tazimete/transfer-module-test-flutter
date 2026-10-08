import 'abstract_auth_session.dart';

/// Legacy auth session interface extending [AbstractAuthSession] for backward compatibility.
abstract class AuthSession implements AbstractAuthSession {
  @override
  Future<bool> get isLoggedIn;

  @override
  Future<String?> get authToken;

  @override
  void onUnauthenticated();
}

/// In-memory implementation of [AbstractAuthSession] suitable for testing.
class InMemoryAuthSession implements AbstractAuthSession {
  bool _isLoggedIn;
  String? _token;
  final void Function()? _onUnauthenticatedCallback;

  InMemoryAuthSession({
    bool isLoggedIn = false,
    String? authToken,
    void Function()? onUnauthenticated,
  })  : _isLoggedIn = isLoggedIn,
        _token = authToken,
        _onUnauthenticatedCallback = onUnauthenticated;

  @override
  Future<bool> get isLoggedIn async => _isLoggedIn;

  @override
  Future<String?> get authToken async => _token;

  void setSession({required bool loggedIn, String? token}) {
    _isLoggedIn = loggedIn;
    _token = token;
  }

  @override
  void onUnauthenticated() {
    _isLoggedIn = false;
    _token = null;
    _onUnauthenticatedCallback?.call();
  }
}
