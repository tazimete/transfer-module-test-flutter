import 'abstract_preference_client.dart';
import 'abstract_preference_manager.dart';
import 'preference_keys.dart';

/// Implementation of [AbstractPreferenceManager].
class PreferenceManager implements AbstractPreferenceManager {
  final AbstractPreferenceClient _preferenceClient;
  final void Function()? _onUnauthenticatedCallback;

  PreferenceManager({
    required AbstractPreferenceClient preferenceClient,
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
