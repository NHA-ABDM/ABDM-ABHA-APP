import 'package:abha/utils/route/route_generator.dart';
import 'package:flutter/foundation.dart';

class AppData {
  String _firebaseToken = '';
  String _languageCode = '';
  String _languageName = '';
  String _languageAudioCode = '';
  String _userName = '';
  String _abhaAddress = '';
  String _abhaNumber = '';
  String _accessToken = '';
  bool _healthRecordFetched = false;
  bool _login = false;

  Map<String, dynamic> _dataPayload = {};
  RouteGenerator _routerGenerator = RouteGenerator();
  final ValueNotifier<bool> _showDrawer = ValueNotifier(true);

  ValueNotifier<bool> get showDrawer => _showDrawer;

  void setFirebaseToken(String token) {
    _firebaseToken = token;
  }

  String getFirebaseToken() {
    return _firebaseToken;
  }

  void setLanguageCode(String language) {
    _languageCode = language;
  }

  String getLanguageCode() {
    return _languageCode;
  }

  void setLanguageName(String languageName) {
    _languageName = languageName;
  }

  String getLanguageName() {
    return _languageName;
  }

  void setLanguageAudioCode(String languageAudio) {
    _languageAudioCode = languageAudio;
  }

  String getLanguageAudioCode() {
    return _languageAudioCode;
  }

  void setLogin(bool login) {
    _login = login;
  }

  bool getLogin() {
    return _login;
  }

  void setUserName(String userName) {
    _userName = userName;
  }

  String getUserName() {
    return _userName;
  }

  void setAbhaAddress(String address) {
    _abhaAddress = address;
  }

  String getAbhaAddress() {
    return _abhaAddress;
  }

  void setAbhaNumber(String number) {
    _abhaNumber = number;
  }

  String getAbhaNumber() {
    return _abhaNumber;
  }

  void setAccessToken(String accessToken) {
    _accessToken = accessToken;
  }

  String getAccessToken() {
    return _accessToken;
  }


  void setHealthRecordFetched(bool value) {
    _healthRecordFetched = value;
  }

  bool getHealthRecordFetched() {
    return _healthRecordFetched;
  }

  void setDataPayload(Map<String, dynamic> dataPayload) {
    _dataPayload = dataPayload;
  }

  Map<String, dynamic> getDataPayload() {
    return _dataPayload;
  }

  void setRouterGenerator() {
    _routerGenerator = RouteGenerator();
  }

  RouteGenerator getRouterGenerator() {
    return _routerGenerator;
  }

}
