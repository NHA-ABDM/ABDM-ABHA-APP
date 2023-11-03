import 'package:abha/export_packages.dart';

class AppRemoteConfig {
  FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  final Map _configData = abhaSingleton.getAppConfig.getConfigData();

  Future<void> initRemoteConfig() async {
    try {
      await _setConfigSettings();
      await _setDefaultValue();
      await _fetchAndActivate();
      abhaLog.i(
        'versionNumber:-${remoteConfig.getString(_configData[AppConfig.versionNumber])}',
      );
      abhaLog.i(
        'forcedUpgrade:-${remoteConfig.getBool(_configData[AppConfig.forceUpgrade])}',
      );
    } on PlatformException catch (exception) {
      abhaLog.i(exception);
    } catch (exception) {
      abhaLog.i(
        'Unable to fetch remote config. Cached or default values will be used',
      );
      abhaLog.i(exception);
    }
  }

  Future<void> _setConfigSettings() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
  }

  Future<void> _setDefaultValue() async {
    await remoteConfig.setDefaults({
      _configData[AppConfig.versionNumber]: '2.2.7',
      _configData[AppConfig.forceUpgrade]: false,
    });
  }

  Future<void> _fetchAndActivate() async {
    await remoteConfig.fetchAndActivate();
  }

  int getInt(String key) {
    return remoteConfig.getInt(key);
  }

  String getString(String key) {
    return remoteConfig.getString(key);
  }

  bool getBool(String key) {
    return remoteConfig.getBool(key);
  }

  double getDouble(String key) {
    return remoteConfig.getDouble(key);
  }
}
