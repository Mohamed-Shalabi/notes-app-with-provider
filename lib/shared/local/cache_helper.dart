import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  //
  CacheHelper._();

  static late final SharedPreferences _instance;

  static Future init() async {
    _instance = await SharedPreferences.getInstance();
  }

  static dynamic getData({required String key}) {
    return _instance.get(key);
  }

  static Future<bool?>? saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) {
      return _instance.setString(key, value);
    } else if (value is int) {
      return _instance.setInt(key, value);
    } else if (value is double) {
      return _instance.setDouble(key, value);
    } else {
      return _instance.setBool(key, value);
    }
  }
}
