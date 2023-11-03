import 'dart:io';
import 'package:abha/geolocation/geolocation_handler.dart';
import 'package:abha/utils/common/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static Future<bool> requestCameraPermission() async {
    await Permission.camera.request();
    return await Permission.camera.isGranted;
  }

  static Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      int deviceVersion = await CustomDeviceInfo.getSDKVersion();
      if (deviceVersion < 33) {
        await Permission.storage.request();
        return await Permission.storage.isGranted;
      }
      return true;
    } else {
      await Permission.storage.request();
      return await Permission.storage.isGranted;
    }
  }

  static Future<bool> requestLocationPermission() async {
    return await GeoLocationHandler.requestLocationPermission();
  }

  static Future<bool> requestPushNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      return false;
    } else {
      return false;
    }
  }
}
