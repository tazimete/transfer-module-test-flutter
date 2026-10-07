/// Contract for managing authentication state and access tokens across network requests.
abstract class AuthSession {
  /// Returns `true` if the user is currently logged in.
  Future<bool> get isLoggedIn;

  /// Returns the current access token (e.g., JWT / Bearer token).
  Future<String?> get authToken;

  /// Callback triggered when an unauthenticated response (401) is encountered.
  void onUnauthenticated();
}

/// Simple in-memory implementation of [AuthSession], ideal for testing or state management integration.
class InMemoryAuthSession implements AuthSession {
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

  /// Update the login state and token.
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
