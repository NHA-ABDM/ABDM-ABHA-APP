import 'dart:collection';

import 'package:abha/app/abha_app.dart';
import 'package:abha/utils/config/app_config.dart';

void main() async {
  Map mainApp = HashMap();
  mainApp[AppConfig.appName] = 'ABHA';
  mainApp[AppConfig.flavorName] = '';
  mainApp[AppConfig.clientId] = '';
  mainApp[AppConfig.clientSecret] = '';
  mainApp[AppConfig.grantType] = '';
  mainApp[AppConfig.requesterId] = '';
  mainApp[AppConfig.xCmId] = '';
  mainApp[AppConfig.baseUrlWebSocket] = '';
  mainApp[AppConfig.baseUrl] = '';
  mainApp[AppConfig.middlePhrUrl] = '';
  mainApp[AppConfig.middlePhiuUrl] = '';
  mainApp[AppConfig.baseSessionUrlGateway] = '';
  mainApp[AppConfig.abhaAddressSuffix] = '';
  mainApp[AppConfig.qrCodeHost] = '';
  mainApp[AppConfig.abhaIdUrl] = '';
  mainApp[AppConfig.abdmBaseUrl] = '';
  mainApp[AppConfig.abhaUrl] = '';
  mainApp[AppConfig.forceUpgrade] = '';
  mainApp[AppConfig.versionNumber] = '';
  mainApp[AppConfig.firebaseApiKey] = '';
  mainApp[AppConfig.projectId] = '';
  mainApp[AppConfig.storageBucket] = '';
  mainApp[AppConfig.messagingSenderId] = '';
  mainApp[AppConfig.appId] = '';
  mainApp[AppConfig.apikey] = '';

  initializeApp(mainApp);
}
