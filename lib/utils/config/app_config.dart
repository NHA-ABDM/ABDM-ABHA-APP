import 'dart:collection';

class AppConfig {
  static const String appName = '';
  static const String flavorName = '';
  static const String xCmId = '';
  static const String clientId = '';
  static const String clientSecret = '';
  static const String grantType = '';
  static const String baseSessionUrlGateway = '';
  static const String requesterId = '';
  static const String baseUrl = '';
  static const String baseUrlWebSocket = '';
  static const String abhaAddressSuffix = '';
  static const String qrCodeHost = '';
  static const String abhaIdUrl = '';
  static const String abdmBaseUrl = '';
  static const String abhaUrl = '';
  static const String forceUpgrade = '';
  static const String versionNumber = '';
  static const String firebaseApiKey = '';
  static const String projectId = '';
  static const String storageBucket = '';
  static const String messagingSenderId = '';
  static const String appId = '';
  static const String apikey = '';
  static const String middlePhrUrl = '';
  static const String middlePhiuUrl = '';

  Map _appConfigData = HashMap();

  void setConfigData(Map data) {
    _appConfigData = data;
  }

  Map getConfigData() {
    return _appConfigData;
  }
}
