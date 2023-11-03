import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class CustomDeviceInfo {
  static Future<int> getSDKVersion() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.version.sdkInt;
    } else {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      return int.parse(iosInfo.systemVersion);
    }
  }

  static Future<String> getAppVersion() async {
    PackageInfo? packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<WebBrowserInfo> getWebPlatFormDetail() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    return deviceInfoPlugin.webBrowserInfo;
  }
}
