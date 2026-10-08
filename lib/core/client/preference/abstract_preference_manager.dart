import '../network/abstract_auth_session.dart';

/// Abstract preference manager contract extending AbstractAuthSession.
abstract class AbstractPreferenceManager implements AbstractAuthSession {
  Future<void> saveAuthSession({required String token, bool isLoggedIn = true});
  Future<void> setLoggedIn(bool value);
  Future<void> setAuthToken(String? token);
  Future<void> clearAuthSession();
}
