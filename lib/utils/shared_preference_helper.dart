import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preference_interface.dart';

class SharedPreferencesHelper implements SharedPreferenceInterface {
  
  SharedPreferences _sharedPreferences;

  Future<SharedPreferences> get sharedPreferences async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    await _sharedPreferences.reload();
    return _sharedPreferences;
  }

  @override
  Future<dynamic> getValueOf(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.get(key);
  }

  @override
  Future<String> getString(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getString(key);
  }

  @override
  Future<bool> getBool(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getBool(key);
  }

  @override
  Future<double> getDouble(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getDouble(key);
  }

  @override
  Future<int> getInt(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getInt(key);
  }

  @override
  Future<List<String>> getStringList(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getStringList(key);
  }

  @override
  Future<Set<String>> getAllKeys() async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.getKeys();
  }

  @override
  Future<bool> containsKeys(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.containsKey(key);
  }

  @override
  Future<bool> setString(String key, String value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setString(key, value);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setBool(key, value);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setInt(key, value);
  }

  @override
  Future<bool> setDouble(String key, double value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setDouble(key, value);
  }

  @override
  Future<bool> setStringList(String key, List<String> value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.setStringList(key, value);
  }

  @override
  Future<bool> remove(String key) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.remove(key);
  }

  @override
  Future<bool> set(String key, dynamic value) async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    bool result = false;
    if (value is int) {
      result = await sharedPreferenceInstance.setInt(key, value);
    }
    else if (value is bool) {
      result = await sharedPreferenceInstance.setBool(key, value);
    }
    else if (value is double) {
      result = await sharedPreferenceInstance.setDouble(key, value);
    }
    else if (value is String) {
      result = await sharedPreferenceInstance.setString(key, value);
    }
    else if (value is List<String>) {
      result = await sharedPreferenceInstance.setStringList(key, value);
    }
    return result;
  }

  @override
  Future<bool> clear() async {
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    return sharedPreferenceInstance.clear();
  }

  @override
  Future<Map<String, dynamic>> getAllPreferences() async{
    final Set<String> allKeys = await getAllKeys();
    final Map<String, dynamic> result = <String, dynamic>{};
    final SharedPreferences sharedPreferenceInstance = await sharedPreferences;
    allKeys.forEach((String key){
      result[key] = sharedPreferenceInstance.get(key);
    });
    return result;
  }
}
