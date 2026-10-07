/// Abstract preference storage interface enforcing the Dependency Inversion Principle (DIP).
/// Decouples the application code from concrete persistence libraries (e.g. SharedPreferences).
abstract class IPreferenceClient {
  /// Stores a String value under [key].
  Future<bool> setString(String key, String value);

  /// Reads a String value associated with [key].
  Future<String?> getString(String key);

  /// Stores a boolean value under [key].
  Future<bool> setBool(String key, bool value);

  /// Reads a boolean value associated with [key]. Defaults to [defaultValue] if absent.
  Future<bool> getBool(String key, {bool defaultValue = false});

  /// Removes the key-value pair associated with [key].
  Future<bool> remove(String key);

  /// Clears all key-value entries from storage.
  Future<bool> clear();

  /// Returns `true` if storage contains [key].
  Future<bool> containsKey(String key);
}
