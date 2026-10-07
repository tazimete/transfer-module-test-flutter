import '../network/auth_session.dart';
import 'preference_client.dart';
import 'preference_keys.dart';

/// Abstract domain preference manager contract extending [AuthSession].
/// Provides thread-safe, asynchronous session state and preference operations.
abstract class IPreferenceManager implements AuthSession {
  /// Atomically saves authentication token and login status.
  Future<void> saveAuthSession({
    required String token,
    bool isLoggedIn = true,
  });

  /// Explicitly updates the user logged-in boolean flag.
  Future<void> setLoggedIn(bool value);

  /// Explicitly updates or removes the authentication token.
  Future<void> setAuthToken(String? token);

  /// Clears stored authentication session details.
  Future<void> clearAuthSession();
}

/// Production implementation of [IPreferenceManager].
/// Enforces Dependency Inversion by relying on abstract [IPreferenceClient].
class PreferenceManager implements IPreferenceManager {
  final IPreferenceClient _preferenceClient;
  final void Function()? _onUnauthenticatedCallback;

  PreferenceManager({
    required IPreferenceClient preferenceClient,
    void Function()? onUnauthenticatedCallback,
  })  : _preferenceClient = preferenceClient,
        _onUnauthenticatedCallback = onUnauthenticatedCallback;

  @override
  Future<bool> get isLoggedIn async {
    return await _preferenceClient.getBool(
      PreferenceKeys.isLoggedInKey,
      defaultValue: false,
    );
  }

  @override
  Future<String?> get authToken async {
    return await _preferenceClient.getString(PreferenceKeys.authTokenKey);
  }

  @override
  Future<void> setLoggedIn(bool value) async {
    await _preferenceClient.setBool(PreferenceKeys.isLoggedInKey, value);
  }

  @override
  Future<void> setAuthToken(String? token) async {
    if (token != null && token.isNotEmpty) {
      await _preferenceClient.setString(PreferenceKeys.authTokenKey, token);
    } else {
      await _preferenceClient.remove(PreferenceKeys.authTokenKey);
    }
  }

  @override
  Future<void> saveAuthSession({
    required String token,
    bool isLoggedIn = true,
  }) async {
    await Future.wait([
      _preferenceClient.setString(PreferenceKeys.authTokenKey, token),
      _preferenceClient.setBool(PreferenceKeys.isLoggedInKey, isLoggedIn),
    ]);
  }

  @override
  Future<void> clearAuthSession() async {
    await Future.wait([
      _preferenceClient.remove(PreferenceKeys.authTokenKey),
      _preferenceClient.setBool(PreferenceKeys.isLoggedInKey, false),
    ]);
  }

  @override
  void onUnauthenticated() {
    clearAuthSession();
    _onUnauthenticatedCallback?.call();
  }
}
