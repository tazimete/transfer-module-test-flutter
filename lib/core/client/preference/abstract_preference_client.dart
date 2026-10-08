/// Abstract preference client contract.
abstract class AbstractPreferenceClient {
  Future<bool> setString(String key, String value);
  Future<String?> getString(String key);
  Future<bool> setBool(String key, bool value);
  Future<bool> getBool(String key, {bool defaultValue = false});
  Future<bool> remove(String key);
  Future<bool> clear();
  Future<bool> containsKey(String key);
}
