import 'dart:io';

import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/reset/restart_widget.dart';
import 'package:abha/utils/common/device_info.dart';
import 'package:flutter/foundation.dart';

class SplashController extends BaseController {
  late SplashRepo _splashRepo;
  late AppRemoteConfig _appRemoteConfig;
  final Map configData = abhaSingleton.getAppConfig.getConfigData();
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  SplashController(SplashRepoImpl repo) : super(SplashController) {
    _splashRepo = repo;
    kIsWeb ? null : deleteCacheDir();
  }

  Future<void> deleteCacheDir() async {
    try {
      if (!Platform.isIOS) {
        var tempDir = await getTemporaryDirectory(); // cache dir
        if (tempDir.existsSync()) {
          tempDir.deleteSync(recursive: true);
        }
      }
    } catch (e) {
      abhaLog.e(e.toString());
    }
  }

  /// @Here function to check app Safety
  /// return [isSafeDevice] bool.
  Future<bool> checkAppSafety() async {
    bool isSafeDevice = kDebugMode ? true : await SafeDevice.isRealDevice;
    return isSafeDevice;
  }

  int getExtendedVersionNumber(String version) {
    /// Note that if you want to support bigger version cells than 99,
    /// just increase the returned versionCells multipliers
    List versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
  }

  /// @Here function provides the version number from remote config and compares with the current
  /// app version.
  ///
  /// RemoteConfig version and Current App version is converted to integer value
  /// (for example 2.2.7 to 227). If current app version is less than new shows popup to upgrade the
  /// app.
  void checkRemoteConfig(BuildContext context) async {
    _appRemoteConfig = AppRemoteConfig();
    bool isForcedUpgrade =
        _appRemoteConfig.getBool(configData[AppConfig.forceUpgrade]);
    String versionNumber =
        _appRemoteConfig.getString(configData[AppConfig.versionNumber]);
    CustomDeviceInfo.getAppVersion().then((currentAppVersion) {
      int versionNumberNum = getExtendedVersionNumber(versionNumber);
      int currentAppVersionNum = getExtendedVersionNumber(currentAppVersion);
      if (currentAppVersionNum < versionNumberNum) {
        showUpdatePopup(context, isForcedUpgrade);
      } else {
        navHandler(context);
      }
    });
  }

  void showUpdatePopup(BuildContext context, bool isForcedUpgrade) {
    /// Pop up for force upgrade to change app version.
    if (isForcedUpgrade) {
      CustomDialog.showPopupDialog(
        backDismissible: false,
        title: LocalizationHandler.of().latestUpdate,
        LocalizationHandler.of().pleaseUpdateYourApp,
        positiveButtonTitle: LocalizationHandler.of().update,
        onPositiveButtonPressed: () {
          appUpdate(context);
        },
      );
    } else {
      /// Ask user to either to change the app version or may be later.
      CustomDialog.showPopupDialog(
        title: LocalizationHandler.of().latestUpdate,
        LocalizationHandler.of().wantToUpdateAppVersion,
        onPositiveButtonPressed: () {
          appUpdate(context);
        },
        onNegativeButtonPressed: () {
          CustomDialog.dismissDialog();
          navHandler(context);
        },
        positiveButtonTitle: LocalizationHandler.of().update,
        negativeButtonTitle: LocalizationHandler.of().later,
      );
    }
  }

  Future<void> navHandler(BuildContext context) async {
    bool isLogin = abhaSingleton.getAppData.getLogin();
    bool isLanguageSelected = await abhaSingleton.getSharedPref
        .get(SharedPref.isLanguageSelected, defaultValue: false);
    bool isPermissionConsent = await abhaSingleton.getSharedPref
        .get(SharedPref.isPermissionConsent, defaultValue: false);
    Timer(const Duration(seconds: 3), () {
      if (isLogin) {
        context.navigateGo(RoutePath.routeDashboard);
      } else if (!isLanguageSelected) {
        context.navigateGo(RoutePath.routeLocalization);
      } else if (!isPermissionConsent) {
        context.navigateGo(RoutePath.routePermissionConsent);
      } else {
        context.navigateGo(RoutePath.routeAppIntro);
      }
    });
  }

  /// @Here function to redirect to the url to update app according to different
  /// flavours.
  void appUpdate(BuildContext context) {
    String version =
        abhaSingleton.getAppConfig.getConfigData()[AppConfig.flavorName];
    late String url;
    if (version == StringConstants.sbx) {
      url = StringConstants.sandboxAppUrl;
    } else if (version == StringConstants.prod && Platform.isAndroid) {
      url = StringConstants.androidAppLink;
    } else if (version == StringConstants.prod && Platform.isIOS) {
      url = StringConstants.iosAppLink;
    } else {
      url = '';
    }
    _launchURLService.launchInBrowserLink(Uri.parse(url)).whenComplete(() {
      RestartWidget.restartApp(context);
    });
  }
}
