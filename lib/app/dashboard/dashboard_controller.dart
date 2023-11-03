import 'dart:io';

import 'package:abha/app/dashboard/dashboard_repo.dart';
import 'package:abha/database/local_db/hive/boxes.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

enum UpdateDashboardUI {
  noHipLinkOrPullRecords,
  hideFabIcon,
  notificationCount,
}

class DashboardController extends BaseController {
  late DashboardRepo _dashboardRepo;
  List? hIpIdDataPullRecord;
  String? hipId;
  String? counterId;
  String? consentRequestID;
  int unreadNotificationCount = -1;
  bool isLinkedFacilityEmpty = false;

  DashboardController(DashboardRepoImpl repo) : super(DashboardController) {
    _dashboardRepo = repo;
  }

  Future<void> checkForPermission() async {
    await PermissionHandler.requestStoragePermission();
    await PermissionHandler.requestCameraPermission();
    await PermissionHandler.requestLocationPermission();
    await PermissionHandler.requestPushNotificationPermission();
  }

  Future<void> isNewAbhaAddress(HiveBoxes box, Map? arguments) async {
    await _initLocalDb(box); // open box before performing any actions
    String newAbhaAddress = arguments?[IntentConstant.abhaAddress] ?? '';
    String preAbhaAddress = await abhaSingleton.getSharedPref
        .get(SharedPref.abhaAddress, defaultValue: newAbhaAddress);
    if (!Validator.isNullOrEmpty(newAbhaAddress) &&
        newAbhaAddress != preAbhaAddress) {
      await _clearLocalDb(box); // delete box if login from different account
    }
  }

  Future<void> _initLocalDb(HiveBoxes box) async {
    await box.openHealthRecordBox();
    await box.openLinkedHipBox();
    await box.openErroredHipBox();
    await box.openHipConsentData();
  }

  Future<void> _clearLocalDb(HiveBoxes box) async {
    await box.clearHealthRecordBox();
    await box.clearLinkedHipBox();
    await box.clearErroredHipBox();
    await box.clearHipConsentData();
  }

  /// @Here function calls the api to get session of the app
  Future<void> getSession() async {
    final ApiProvider apiProvider = abhaSingleton.getApiProvider;
    final Map configData = abhaSingleton.getAppConfig.getConfigData();
    apiProvider.updateBaseUrl(configData[AppConfig.baseSessionUrlGateway]);
    tempResponseData = await _dashboardRepo.onSession(_sessionRequestData());
    apiProvider.updateBaseUrl(configData[AppConfig.baseUrl]);
  }

  Map _sessionRequestData() {
    final Map appConfigData = abhaSingleton.getAppConfig.getConfigData();
    var sessionData = {
      ApiKeys.requestKeys.clientId: appConfigData[AppConfig.clientId],
      ApiKeys.requestKeys.clientSecret: appConfigData[AppConfig.clientSecret],
      ApiKeys.requestKeys.grantType: appConfigData[AppConfig.grantType],
    };
    return sessionData;
  }

  Future<void> getXToken() async {
    tempResponseData = await _dashboardRepo.onXToken();
    abhaSingleton.getApiProvider.addXHeaderToken(tempResponseData);
  }

  Future<void> getXAuthToken(ProfileModel? profileModel) async {
    var authTokenReqBody = {
      ApiKeys.requestKeys.scope: 'HIECM',
      ApiKeys.requestKeys.parameters: _getUserData(profileModel)
    };
    tempResponseData = await _dashboardRepo.onXAuthToken(authTokenReqBody);
    abhaSingleton.getApiProvider.addXAuthHeaderToken(tempResponseData);
  }

  Future<void> setConsentAutoApprovalPolicy() async {
    var datatimeNow = DateTime.now()
        .toLocal()
        .add(const Duration(seconds: 10))
        .toIso8601String();

    var datatimeFuture = DateTime.now()
        .toLocal()
        .add(const Duration(days: 365 * 100))
        .toIso8601String();

    Map<String, dynamic> authTokenReqBody = {
      'isApplicableForAllHIPs': true,
      'hiu': {'id': ''},
      'includedSources': [
        {
          'hiTypes': [
            'DiagnosticReport',
            'Prescription',
            'ImmunizationRecord',
            'DischargeSummary',
            'OPConsultation',
            'HealthDocumentRecord',
            'WellnessRecord',
          ],
          'purpose': {
            'text': 'Self Requested',
            'code': 'PATRQT',
            'refUri': 'www.abdm.gov.in'
          },
          'hip': null,
          'period': {
            'from': '${datatimeNow.formatLocalWithoutZ}Z',
            'to': '${datatimeFuture.formatLocalWithoutZ}Z'
          }
        }
      ],
      'excludedSources': null
    };
    tempResponseData =
        await _dashboardRepo.onSetConsentAutoApprovalPolicy(authTokenReqBody);
  }

  Map _getUserData(ProfileModel? profileModel) {
    var userData = {
      ApiKeys.requestKeys.abhaAddress: profileModel?.abhaAddress,
      ApiKeys.requestKeys.name: abhaSingleton.getAppData.getUserName(),
      ApiKeys.requestKeys.gender: profileModel?.gender,
      ApiKeys.requestKeys.yearOfBirth: profileModel?.dateOfBirth?.year,
    };
    return userData;
  }

  Future<void> sendDeviceToken() async {
    var deviceTokenReqBody = {
      ApiKeys.requestKeys.healthId: abhaSingleton.getAppData.getAbhaAddress(),
      ApiKeys.requestKeys.appToken: abhaSingleton.getAppData.getFirebaseToken(),
      ApiKeys.requestKeys.osType: Platform.isIOS
          ? 'ios'
          : Platform.isAndroid
              ? 'android'
              : kIsWeb
                  ? 'web'
                  : 'unknown',
    };
    await _dashboardRepo.onSendDeviceToken(deviceTokenReqBody);
  }

  void setLinkedFacilityPullRecord(List? hIpIdData) {
    // If no hip Link data available send boolean true to Dashboard
    onLinkFacilityEmpty(false);
    hIpIdDataPullRecord = hIpIdData;
    update();
  }

  /// Sets the [_isLinkedFacilityEmpty] flag and updates the dashboard UI.
  /// This function is called when the facility link is empty. It takes a boolean
  /// argument [isFacilityEmpty] to set the [_isLinkedFacilityEmpty] flag. The
  /// function then calls [_dashboardController.functionHandler()] to update the
  /// dashboard UI.
  ///
  /// If [isFacilityEmpty] is `true`, the following UI elements are updated:
  ///
  /// * `UpdateDashboardUI.noHipLinkDataAvailable`: Shows a message indicating
  /// that there is no data available for the linked facility.
  /// * `UpdateDashboardUI.hideFabIcon`: Hides the floating action button on the UI.
  void onLinkFacilityEmpty(bool isFacilityEmpty) {
    isLinkedFacilityEmpty = isFacilityEmpty;
    update(
      [UpdateDashboardUI.noHipLinkOrPullRecords, UpdateDashboardUI.hideFabIcon],
    );
  }

  void handleNotificationCount(NotificationController notificationController) {
    var data = notificationController.notificationsData;
    List<NotificationModel> notificationsData = data.toSet().toList();
    if (notificationsData.isNotEmpty) {
      unreadNotificationCount = notificationsData.elementAt(0).unreadCount ?? 0;
    } else {
      unreadNotificationCount = 0;
    }
    update([UpdateDashboardUI.notificationCount]);
  }

  bool initDeepUniLinks(String initialLink) {
    bool isValidQrCodeData = false;
    final QrCodeScannerController qrCodeController =
        Get.put(QrCodeScannerController(QrCodeScannerRepoImpl()));
    isValidQrCodeData = qrCodeController.getQrCodeDataHandler(initialLink);
    if (isValidQrCodeData) {
      hipId = qrCodeController.hipId;
      counterId = qrCodeController.counterId;
      consentRequestID = qrCodeController.consentRequestID;
    }
    DeleteControllers().deleteQrCodeScanner();
    return isValidQrCodeData;
  }

  Future<bool> showExitPopup(BuildContext context) async {
    return await context.openDialog(
          CustomAlertDialog(
            title: LocalizationHandler.of().exitApp,
            msg: LocalizationHandler.of().exitAppDetail,
            positiveButtonTitle: LocalizationHandler.of().yes,
            negativeButtonTitle: LocalizationHandler.of().no,
            onPositiveButtonPressed: () => Navigator.of(context).pop(true),
            onNegativeButtonPressed: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;
  }

  /// Here is the Function to open the dialog to ask the user to logout
  /// param [context]  BuildContext
  void showLogoutPopup(BuildContext context) {
    CustomDialog.showPopupDialog(
      LocalizationHandler.of().wantToLogout,
      positiveButtonTitle: LocalizationHandler.of().yes,
      negativeButtonTitle: LocalizationHandler.of().no,
      onPositiveButtonPressed: () {
        CustomDialog.dismissDialog();
        functionHandler(
          function: () => callLogout(),
          isLoaderReq: true,
        ).whenComplete(() {
          if (responseHandler.status == Status.success) {
            abhaSingleton.getSharedPref.clearPref().whenComplete(() {
              context.navigateGo(RoutePath.routeAppIntro);
            });
          }
        });
      },
      onNegativeButtonPressed: CustomDialog.dismissDialog,
    );
  }

  Future<void> callLogout() async {
    await _dashboardRepo.onLogout();
    if (!abhaSingleton.getAppData.getHealthRecordFetched()) {
      abhaSingleton.getApiProvider.cancelRequest();
    }
    abhaSingleton.getSharedPref.set(SharedPref.tokenDetails, '');
  }

  Future<void> getRefreshXToken() async {
    tempResponseData = await _dashboardRepo.onRefreshXToken();
    abhaSingleton.getApiProvider.addXHeaderToken(tempResponseData);
  }
}
