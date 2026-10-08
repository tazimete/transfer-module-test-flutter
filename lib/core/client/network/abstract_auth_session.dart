/// Abstract authentication session contract enforcing the Abstract naming convention.
abstract class AbstractAuthSession {
  Future<bool> get isLoggedIn;
  Future<String?> get authToken;
  void onUnauthenticated();
}
