import 'dart:io';

import 'package:abha/app/abha_app.dart';
import 'package:abha/database/shared_preference/shared_pref.dart';
import 'package:abha/utils/singleton/abha_singleton.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationHandler {
  var firebaseWebServerKey = '';
  Future<void> initFirebaseNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    abhaSingleton.getLocalNotificationService
        .initFlutterLocalNotificationsPlugin();
    String token = '';
    if (kIsWeb) {
      token = await _isWeb(messaging);
    } else if (Platform.isAndroid) {
      token = await _isAndroid(messaging);
    } else if (Platform.isIOS) {
      token = await _isIos(messaging);
    }
    abhaSingleton.getAppData.setFirebaseToken(token);
  }

  Future<String> _isWeb(FirebaseMessaging messaging) async {
    // for iOS, macOS & web
    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      abhaLog.i('User granted permission');
    } else {
      abhaLog.i('User declined or has not accepted permission');
    }
    String token =
        await messaging.getToken(vapidKey: firebaseWebServerKey) ?? '';
    abhaLog.i('first web token: $token');
    messaging.onTokenRefresh.listen((String tokenValue) {
      token = tokenValue;
      abhaLog.i('New web device token: $token');
      abhaSingleton.getSharedPref.set(
        SharedPref.isDeviceTokenUpdated,
        1,
      );
    });
    return token;
  }

  Future<String> _isAndroid(FirebaseMessaging messaging) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'navigationActionId', // id
      'Consent Notifications', // title
      description:
          'This channel is used for consent notifications.', // description
      importance: Importance.max,
    );
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    String token = await messaging.getToken() ?? '';
    abhaLog.i('first android token: $token');
    messaging.onTokenRefresh.listen((String tokenValue) {
      token = tokenValue;
      abhaLog.i('New android mobile token: $token');
      abhaSingleton.getSharedPref.set(
        SharedPref.isDeviceTokenUpdated,
        1,
      );
    });
    return token;
  }

  Future<String> _isIos(FirebaseMessaging messaging) async {
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      abhaLog.i('User granted permission');
    } else {
      abhaLog.i('User declined or has not accepted permission');
    }
    String token = await messaging.getToken() ?? '';
    abhaLog.i('first ios token: $token');
    messaging.onTokenRefresh.listen((String tokenValue) {
      token = tokenValue;
      abhaLog.i('New ios mobile token: $token');
      abhaSingleton.getSharedPref.set(
        SharedPref.isDeviceTokenUpdated,
        1,
      );
    });
    return token;
  }
}
