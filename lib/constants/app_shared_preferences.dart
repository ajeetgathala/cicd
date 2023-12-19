import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSharedPreferences {
  static String id = 'ID';
  static String isLoggedIn = 'IS_LOGGED_IN';
  static String token = 'TOKEN';
  static String fcmToken = 'FCM_TOKEN';

  static String userType = 'USER_TYPE';

  static String selectedSchool = 'SELECTED_SCHOOL';
  static String selectedDistrict = 'SELECTED_DISTRICT';

  static String fcmTokenDate = 'FCM_TOKEN_DATE';

  static Future<void> putString(String key, String value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<String?> getString(String key) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key);
  }

  static Future<void> putInt(key, int value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value.toString());
  }

  static Future<void> putBool(key, bool value) async {
    int v = value ? 1 : 0;
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: v.toString());
  }

  static Future<void> putDouble(key, double value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value.toString());
  }

  static Future<int?> getInt(key) async {
    const storage = FlutterSecureStorage();
    return int.parse(await storage.read(key: key) ?? '0');
  }

  static Future<bool?> getBool(key) async {
    bool value = false;
    const storage = FlutterSecureStorage();
    value = await storage.read(key: key) == "1";
    return value;
  }

  static Future<double?> getDouble(key) async {
    const storage = FlutterSecureStorage();
    return double.parse(await storage.read(key: key) ?? '0');
  }

  static Future<void> clearPreferences() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
