import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'abstract_preference_client.dart';

/// Implementation of [AbstractPreferenceClient] using [SharedPreferences].
class SharedPreferencesClient implements AbstractPreferenceClient {
  final FutureOr<SharedPreferences> _prefsInstance;

  SharedPreferencesClient({FutureOr<SharedPreferences>? prefs})
      : _prefsInstance = prefs ?? SharedPreferences.getInstance();

  Future<SharedPreferences> get _prefs async {
    final instance = _prefsInstance;
    if (instance is SharedPreferences) {
      return instance;
    }
    return await instance;
  }

  @override
  Future<bool> setString(String key, String value) async {
    final instance = await _prefs;
    return await instance.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    final instance = await _prefs;
    return instance.getString(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    final instance = await _prefs;
    return await instance.setBool(key, value);
  }

  @override
  Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final instance = await _prefs;
    return instance.getBool(key) ?? defaultValue;
  }

  @override
  Future<bool> remove(String key) async {
    final instance = await _prefs;
    return await instance.remove(key);
  }

  @override
  Future<bool> clear() async {
    final instance = await _prefs;
    return await instance.clear();
  }

  @override
  Future<bool> containsKey(String key) async {
    final instance = await _prefs;
    return instance.containsKey(key);
  }
}
