import 'package:abha/export_packages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const String isLanguageSelected = '';
  static const String isPermissionConsent = '';
  static const String currentLanguageCode = '';
  static const String currentLanguageName = '';
  static const String currentLanguageAudioCode = '';
  static const String isLogin = '';
  static const String isDeviceTokenUpdated = '';
  static const String userName = '';
  static const String apiRHeaderToken = '';
  static const String abhaAddress = '';
  static const String tokenDetails = '';
  static const String userLists = '';

  Future<void> setLogin() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(isLogin, true);
    abhaSingleton.getAppData.setLogin(true);
  }

  Future<void> set(String key, dynamic value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPreferences.setBool(key, value);
    } else if (value is String) {
      sharedPreferences.setString(key, value);
    } else if (value is double) {
      sharedPreferences.setDouble(key, value);
    } else if (value is int) {
      sharedPreferences.setInt(key, value);
    }
  }

  //Method for get from any key
  Future<dynamic> get(String key, {dynamic defaultValue}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key) ?? defaultValue;
  }

  // should only call if user is login
  Future<void> clearPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(isLogin);
    sharedPreferences.remove(apiRHeaderToken);
    abhaSingleton.getAppData.setLogin(false);
    abhaSingleton.getApiProvider.clearHeaders();
    await DeleteControllers().deleteAll(); // removes all controller from memory
  }
}
