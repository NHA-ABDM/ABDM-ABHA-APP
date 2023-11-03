import 'package:abha/export_packages.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  bool showDialog = false;
  VoidCallback? voidCallback;
  final String navigationActionId = 'id_1';
  Map<String, dynamic> payloadData = {};

  void notificationType(bool showDialog, {VoidCallback? voidCallback}) {
    this.showDialog = showDialog;
    this.voidCallback = voidCallback;
  }

  void initFlutterLocalNotificationsPlugin() {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
      // onDidReceiveBackgroundNotificationResponse:
      //     onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    final String? payload = notificationResponse.payload;
    abhaLog.i('notification payload on click: $payload');
    Map dataPayload = abhaSingleton.getAppData.getDataPayload();
    Map consentParam = jsonDecode(dataPayload['params']);
    String consentId = consentParam['consent_request_id'];
    navKey.currentContext!.navigatePush(
      RoutePath.routeConsent,
      arguments: {
        IntentConstant.data: consentId,
        IntentConstant.navigateFrom: GlobalEnumNavigationType.pushNotification,
      },
    );
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    abhaLog.i('Notification Received');
    abhaLog.i(payload);
    // display a dialog with the notification details, tap ok to go to another page
    navKey.currentContext!.openDialog(
      CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Ok'),
            onPressed: () async {
              Navigator.of(navKey.currentContext!, rootNavigator: true).pop();
              // context.navigatePushNamed(
              //   RoutesName.routeProfileView,
              //   arguments: {payload},
              // );
            },
          )
        ],
      ),
    );
  }

  void displayNotification(RemoteMessage message) async {
    abhaLog.i('Notification Received');
    abhaLog.i(message.toMap().toString());
    payloadData = message.data;
    abhaSingleton.getAppData.setDataPayload(payloadData);
    try {
      NotificationDetails notificationDetails =
          await _notificationDetail(message);
      // final id = Random().nextInt(20000);
      // message.notification!.title.toString(),
      // message.notification!.body.toString(),
      if (showDialog) {
        MessageBar.showSnackBarWithOption(
          payloadData['title'],
          payloadData['body'],
          onPositiveButtonPressed: voidCallback,
          onNegativeButtonPressed: MessageBar.dismissSnackBar(),
          dismissible: false,
        );

        // CustomDialog.showPopupDialog(
        //   payloadData['body'],
        //   title: payloadData['title'],
        //   onPositiveButtonPressed: voidCallback,
        //   onNegativeButtonPressed: CustomDialog.dismissDialog,
        // );
      } else {
        await flutterLocalNotificationsPlugin.show(
          0,
          message.data['title'],
          message.data['body'],
          notificationDetails,
          payload: message.data['_id'],
        );
      }
    } on Exception catch (e) {
      e.toString();
    }
  }

  Future<NotificationDetails> _notificationDetail(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      navigationActionId, // id
      'Consent Notifications', // title
      description:
          'This channel is used for consent notifications.', // description
      importance: Importance.max,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    AndroidNotification? android = message.notification?.android;
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id, channel.name,
        channelDescription: channel.description,
        icon: android?.smallIcon,
        priority: Priority.high,
        // actions: <AndroidNotificationAction>[
        //   const AndroidNotificationAction('id_1', 'Action 1'),
        //   const AndroidNotificationAction('id_2', 'Action 2'),
        //   const AndroidNotificationAction('id_3', 'Action 3'),
        // ],
      ),
    );
    return Future.value(notificationDetails);
  }
}
