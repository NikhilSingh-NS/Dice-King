import 'shared_preference_helper.dart';

//declare all unique shared preferences keys here...
const String LOGGED_IN_USER_ID = 'LOGGED_IN_USER_ID';

abstract class SharedPreferenceInterface {
  factory SharedPreferenceInterface() {
    return SharedPreferencesHelper();
  }

  Future<dynamic> getValueOf(String key);

  Future<String> getString(String key);

  Future<bool> getBool(String key);

  Future<double> getDouble(String key);

  Future<int> getInt(String key);

  Future<List<String>> getStringList(String key);

  Future<Set<String>> getAllKeys();

  Future<bool> containsKeys(String key);

  Future<bool> setString(String key, String value);

  Future<bool> setBool(String key, bool value);

  Future<bool> setInt(String key, int value);

  Future<bool> setDouble(String key, double value);

  Future<bool> setStringList(String key, List<String> value);

  Future<bool> remove(String key);

  Future<bool> clear();

  Future<bool> set(String key, dynamic value);

  Future<Map<String, dynamic>> getAllPreferences();
}
