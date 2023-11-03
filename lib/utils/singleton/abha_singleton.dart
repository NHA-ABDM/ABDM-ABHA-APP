import 'package:abha/export_packages.dart';
import 'package:abha/firebase/notification/push_notification_service.dart';
import 'package:abha/utils/decor/border_decoration.dart';

AbhaSingleton abhaSingleton = AbhaSingleton.instance;

class AbhaSingleton {
  AbhaSingleton._privateConstructor();

  static final AbhaSingleton _instance = AbhaSingleton._privateConstructor();

  static AbhaSingleton get instance => _instance;

  final SharedPref _sharedPref = SharedPref();
  final AppData _appData = AppData();
  final AppConfig _appConfig = AppConfig();
  final ApiProvider _apiProvider = ApiProvider();
  final BorderDecoration _borderDecoration = BorderDecoration();
  final LocalNotificationService _localNotificationService =
      LocalNotificationService();

  SharedPref get getSharedPref => _sharedPref;

  AppData get getAppData => _appData;

  AppConfig get getAppConfig => _appConfig;

  ApiProvider get getApiProvider => _apiProvider;

  BorderDecoration get getBorderDecoration => _borderDecoration;

  LocalNotificationService get getLocalNotificationService =>
      _localNotificationService;

  late AnimationController animationController;
  late Animation animation;

}
