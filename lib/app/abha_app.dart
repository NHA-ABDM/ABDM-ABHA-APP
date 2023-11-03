import 'package:abha/database/local_db/hive/adapters.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/firebase/crashlytics/crashlytics_handler.dart';
import 'package:abha/firebase/dynamiclinking/dynamic_linking_handler.dart';
import 'package:abha/firebase/notification/push_notification_handler.dart';
import 'package:abha/reusable_widget/reset/restart_widget.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:abha/utils/theme/app_theme_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';

final abhaLog = customLogger(AbhaApp);

Future<void> initializeApp(Map configData) async {
  // setPathUrlStrategy();
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  _initHive();
  await _initAppConfig(configData);
  await _initLocalization();
  await _initFirebase();
  _initAbhaApp();
}

Future<void> _initHive() async {
  HiveAdapters().initHiveAdapters();
}

Future<void> _initAppConfig(Map configData) async {
  abhaSingleton.getAppConfig.setConfigData(configData);
  await abhaSingleton.getApiProvider.initApiDetails();
}

Future<void> _initLocalization() async {
  String languageCode = await abhaSingleton.getSharedPref.get(
    SharedPref.currentLanguageCode,
    defaultValue: LocalizationConstant.englishCode,
  );
  abhaSingleton.getAppData.setLanguageCode(languageCode);

  String languageName = await abhaSingleton.getSharedPref.get(
    SharedPref.currentLanguageName,
    defaultValue: LocalizationConstant.english,
  );
  abhaSingleton.getAppData.setLanguageName(languageName);

  String languageAudioCode = await abhaSingleton.getSharedPref.get(
    SharedPref.currentLanguageAudioCode,
    defaultValue: LocalizationConstant.englishAudioCode,
  );
  abhaSingleton.getAppData.setLanguageAudioCode(languageAudioCode);

  bool isLogin = await abhaSingleton.getSharedPref
      .get(SharedPref.isLogin, defaultValue: false);
  abhaSingleton.getAppData.setLogin(isLogin);
}

Future<void> _initFirebase() async {
  if (!kIsWeb) {
    await Firebase.initializeApp();
    await AppRemoteConfig().initRemoteConfig();
    CrashlyticsHandler().initCrashlytics();
    DynamicLinkHandler().initDynamicLinking();
    _initPushNotification();
  }
}

void _initPushNotification() {
  PushNotificationHandler().initFirebaseNotification();
  abhaSingleton.getLocalNotificationService
      .initFlutterLocalNotificationsPlugin();
  _onForeGroundNotification();
  FirebaseMessaging.onBackgroundMessage(_onBackgroundNotification);
  _onTerminatedNotification();
  _onNotificationClick();
}

// ---------it will call when app is in foreGround-------------------------------
Future<void> _onForeGroundNotification() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    abhaSingleton.getLocalNotificationService.displayNotification(message);
  });
}

// ----------it will call when app is in background-------------------------------
Future<void> _onBackgroundNotification(RemoteMessage message) async {
  abhaSingleton.getLocalNotificationService.notificationType(false);
  abhaSingleton.getLocalNotificationService.displayNotification(message);
}

// ----------it will call when app is terminated-------------------------------
Future<void> _onTerminatedNotification() async {
  await Firebase.initializeApp();
  abhaSingleton.getLocalNotificationService
      .initFlutterLocalNotificationsPlugin();
  RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    abhaSingleton.getLocalNotificationService
        .displayNotification(initialMessage);
  }
}

// ----------it is used to handle on click of notification-------------------------------
void _onNotificationClick() {
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // abhaSingleton.getLocalNotificationService.displayNotification(message);
  });
}

void _initAbhaApp() {
  runApp(
    const RestartWidget(
      child: AbhaApp(),
    ),
  );
}

class AbhaApp extends StatelessWidget {
  const AbhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp.router(
      builder: (BuildContext context, Widget? child) {
        return ResponsiveWrapper.builder(
          BouncingScrollWrapper.builder(context, child!),
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(450, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
            const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
            const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
            const ResponsiveBreakpoint.autoScale(2460, name: '4K'),
          ],
        );
      },
      locale: Locale(abhaSingleton.getAppData.getLanguageCode()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: AppLocalizations.of(context)?.appTitle ?? '',
      color: context.themeData.primaryColor,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      scaffoldMessengerKey: scaffoldMsgKey,
      routerConfig: abhaSingleton.getAppData.getRouterGenerator().router,
    );
  }
}
