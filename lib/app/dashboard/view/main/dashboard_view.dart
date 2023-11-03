import 'package:abha/app/consents/view/main/consents_view.dart';
import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/app/dashboard/dashboard_repo.dart';
import 'package:abha/app/dashboard/view/main/dashboard_no_facility_linked_view.dart';
import 'package:abha/app/dashboard/view/main/dashboard_profile_view.dart';
import 'package:abha/app/health_locker/widget/health_locker_list_widget.dart';
import 'package:abha/app/token/token_controller.dart';
import 'package:abha/app/token/token_repo.dart';
import 'package:abha/app/token/view/token_view.dart';
import 'package:abha/database/local_db/hive/boxes.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/app_bar/mobile/custom_appbar_mobile_view.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_mobile_view.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:flutter/foundation.dart';

class DashboardView extends StatefulWidget {
  final Map? arguments;

  const DashboardView({super.key, this.arguments});

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  late DashboardController _dashboardController;
  late ProfileController _profileController;
  late LinkedFacilityController _linkFacilityController;
  late TokenController _tokenController;
  int _currentIndex = 0;
  List<Widget> _currentWidget = [
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink(),
    const SizedBox.shrink()
  ];
  List<Widget> _currentDesktopWidget = [const SizedBox.shrink()];
  bool _isDarkTabBar = true;
  String _titleName = '';
  final _box = HiveBoxes();
  final SharedPref _sharedPref = abhaSingleton.getSharedPref;

  @override
  void initState() {
    _init();
    _onStart();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    DeleteControllers().deleteDashboard(_box);
  }

  void _init() {
    _dashboardController = Get.put(DashboardController(DashboardRepoImpl()));
    _profileController = Get.put(ProfileController(ProfileRepoImpl()));
    _linkFacilityController =
        Get.put(LinkedFacilityController(LinkedFacilityRepoImpl()));
    _tokenController =
        Get.put<TokenController>(TokenController(TokenRepoImpl()));
  }

  void _onStart() async {
    kIsWeb ? null : _dashboardController.checkForPermission();
    await _dashboardController.isNewAbhaAddress(_box, widget.arguments);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Validator.isNullOrEmpty(abhaSingleton.getAppData.getAccessToken())
          ? _onFetchSession()
          : _onFetchMyProfile();
    });
  }

  void _onFetchSession() {
    _dashboardController
        .functionHandler(
      function: () => _dashboardController.getSession(),
      isLoaderReq: true,
      isShowError: false,
    )
        .whenComplete(() {
      if (_dashboardController.responseHandler.status == Status.success) {
        if (_dashboardController.responseHandler.data is String) {
          _setErrorWidget(_onFetchSession);
          return;
        }
        String accessToken =
            _dashboardController.responseHandler.data['accessToken'];
        abhaSingleton.getAppData.setAccessToken(accessToken);
        String xToken = abhaSingleton.getApiProvider.xToken;
        Validator.isNullOrEmpty(xToken)
            ? _onFetchXToken()
            : _onFetchMyProfile();
      } else {
        _setErrorWidget(_onFetchSession);
      }
    });
  }

  void _onFetchXToken() {
    _dashboardController
        .functionHandler(
      function: () => _dashboardController.getXToken(),
      isLoaderReq: true,
      isShowError: false,
    )
        .whenComplete(() {
      if (_dashboardController.responseHandler.status == Status.success) {
        _onFetchMyProfile();
        Future.delayed(const Duration(minutes: 10), () => _onRefreshXToken());
      } else {
        _setErrorWidget(_onFetchXToken);
      }
    });
  }

  void _onRefreshXToken() {
    if (abhaSingleton.getAppData.getLogin()) {
      _dashboardController
          .functionHandler(
        function: () => _dashboardController.getRefreshXToken(),
        isShowError: false,
      )
          .whenComplete(() {
        if (_dashboardController.responseHandler.status == Status.success) {
          _onFetchXAuthToken(isRefreshCall: true);
          Future.delayed(const Duration(minutes: 10), () => _onRefreshXToken());
        } else {
          Future.delayed(const Duration(minutes: 1), () => _onRefreshXToken());
        }
      });
    }
  }

  void _onFetchMyProfile() async {
    _profileController
        .functionHandler(
      function: () => _profileController.getProfileFetch(fromDashboard: true),
      isLoaderReq: true,
      isShowError: false,
    )
        .whenComplete(() {
      if (_profileController.responseHandler.status == Status.success) {
        if (Validator.isNullOrEmpty(abhaSingleton.getApiProvider.xAuthToken)) {
          _onFetchXAuthToken();
        } else {
          _setSuccessWidget();
        }
      } else {
        _setErrorWidget(_onFetchMyProfile);
      }
    });
  }

  void _onFetchXAuthToken({bool isRefreshCall = false}) async {
    if (abhaSingleton.getAppData.getLogin()) {
      _dashboardController
          .functionHandler(
        function: () =>
            _dashboardController.getXAuthToken(_profileController.profileModel),
        isLoaderReq: isRefreshCall ? false : true,
        isShowError: false,
      )
          .whenComplete(() {
        if (_dashboardController.responseHandler.status == Status.success) {
          if (!isRefreshCall) {
            _setConsentAutoApprovalPolicy();
            _setSuccessWidget();
          }
        } else {
          if (!isRefreshCall) {
            _setErrorWidget(_onFetchXAuthToken);
          } else {
            Future.delayed(
              const Duration(minutes: 1),
              () => _onFetchXAuthToken(isRefreshCall: isRefreshCall),
            );
          }
        }
      });
    }
  }

  void _setConsentAutoApprovalPolicy() async {
    _dashboardController.functionHandler(
      function: () => _dashboardController.setConsentAutoApprovalPolicy(),
      isShowError: false,
    );
  }

  void _setSuccessWidget() {
    kIsWeb ? null : _onFetchNotification(true);
    kIsWeb ? null : _onUpdateDeviceToken();
    _currentDesktopWidget = [
      _homeDesktopWidget(),
    ];
    _currentWidget = [
      _homeMobileWidget(),
      _linkFacilityWidget(),
      _qrScannerWidget(),
      _consentWidget()
    ];
    _dashboardController.update();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      kIsWeb ? null : _deepLinkHandler();
    });
  }

  void _setErrorWidget(Function callBack) {
    CustomDialog.showPopupDialog(
      // isProfileApiFailed
      //     ? LocalizationHandler.of().fetchUserProfile
      //     : LocalizationHandler.of().fetchAccessToken,
      LocalizationHandler.of().fetchAccessToken,
      backDismissible: false,
      positiveButtonTitle: LocalizationHandler.of().retry,
      onPositiveButtonPressed: () {
        CustomDialog.dismissDialog();
        callBack();
        // isProfileApiFailed ? _onFetchMyProfile() : _onFetchXAuthToken();
      },
      negativeButtonTitle: LocalizationHandler.of().drawer_logout,
      onNegativeButtonPressed: () {
        abhaSingleton.getSharedPref.clearPref().whenComplete(() {
          context.navigateGo(RoutePath.routeAppIntro);
        });
      },
    );
  }

  void _onFetchNotification(bool clearData) async {
    NotificationController controller =
        Get.put(NotificationController(NotificationRepoImpl()));
    controller.getNotificationFetch(clearData).whenComplete(() {
      _dashboardController.handleNotificationCount(controller);
      DeleteControllers().deleteNotification(forceDelete: true);
    });
  }

  void _onUpdateDeviceToken() async {
    _sharedPref
        .get(SharedPref.isDeviceTokenUpdated, defaultValue: 0)
        .then((isDeviceTokenUpdated) {
      if (isDeviceTokenUpdated < 2) {
        _dashboardController.sendDeviceToken().whenComplete(() {
          if (_dashboardController.responseHandler.status == Status.success) {
            _sharedPref.set(SharedPref.isDeviceTokenUpdated, 2);
          }
        });
      }
    });
  }

  void _deepLinkHandler() async {
    final String initialLink = await getInitialLink() ?? '';
    if (!Validator.isNullOrEmpty(initialLink)) {
      bool isValidQrCodeData =
          _dashboardController.initDeepUniLinks(initialLink);
      if (isValidQrCodeData) {
        _deepLinkNavHandler();
      } else {
        MessageBar.showToastDialog(LocalizationHandler.of().invalidQrCode);
      }
    }
  }

  void _deepLinkNavHandler() {
    if (!Validator.isNullOrEmpty(_dashboardController.consentRequestID)) {
      _openConsentView();
    } else {
      _openShareProfileView();
    }
  }

  void _openConsentView() {
    var arguments = {
      IntentConstant.data: _dashboardController.consentRequestID,
      IntentConstant.navigateFrom: GlobalEnumNavigationType.dashboard,
    };
    context.navigatePush(
      RoutePath.routeConsent,
      arguments: arguments,
    );
  }

  void _openShareProfileView({String? hipId, String? counterId}) {
    var arguments = {
      IntentConstant.hipId: hipId ?? _dashboardController.hipId,
      IntentConstant.counterId: counterId ?? _dashboardController.counterId,
    };
    context
        .navigatePush(RoutePath.routeShareProfile, arguments: arguments)
        .then((isDataShared) {
      bool isUserDetailsShared = isDataShared ?? false;
      if (isUserDetailsShared) {
        _setTabConfig(0);
      }
    });
  }

  void _showQrScannerPopup() {
    CustomScanOptionDialog()
        .scanOptionPopUp(context, this)
        .then((isDataShared) {
      DeleteControllers().deleteQrCodeScanner();
      bool dataShared =
          _tokenController.isUserDetailsShared = isDataShared ?? false;
      if (dataShared) {
        _setTabConfig(2); // to refresh
        Future.delayed(const Duration(milliseconds: 50), () {
          _setTabConfig(0);
        });
      }
    });
  }

  void _onClickNotificationIcon() {
    bool reloadConsent = false;
    if (_currentIndex == 3) {
      reloadConsent = true;
      _setTabConfig(0); // to reload the consent
    }
    context.navigatePush(RoutePath.routeNotification).whenComplete(() {
      if (reloadConsent) {
        _setTabConfig(3);
      } else {
        _dashboardController.update([
          UpdateDashboardUI.notificationCount,
        ]);
      }
    });
  }

  void _onClickProfileIcon() {
    context
        .navigatePush(
      RoutePath.routeProfileView,
    )
        .then((isDataShared) {
      bool dataShared =
          _tokenController.isUserDetailsShared = isDataShared ?? false;
      if (dataShared) {
        _setTabConfig(0);
      }
    });
  }

  void _onDiscoveryLinking() {
    if (_currentIndex == 1) {
      _setTabConfig(0); // to refresh
    }
    context.navigatePush(RoutePath.routeDiscoveryLinking).then((value) {
      bool isHipLinked = value ?? false;
      if (isHipLinked) {
        _linkFacilityController.responseHandler.data = null;
      }
      _setTabConfig(1);
    });
  }

  void _setTabConfig(int newIndex) {
    _currentIndex = newIndex;
    _isDarkTabBar = _currentIndex == 0 ? true : false;
    _titleName = _currentIndex == 1
        ? LocalizationHandler.of().linkedFacility
        : _currentIndex == 3
            ? LocalizationHandler.of().consents
            : '';
    _dashboardController.update();
  }

  void _healthLockerBottomSheet() {
    HealthLockerController healthLockerController =
        Get.put(HealthLockerController(HealthLockerRepoImpl()));
    healthLockerController
        .functionHandler(
      function: () => healthLockerController.getAllLockers(),
      isLoaderReq: true,
    )
        .whenComplete(() {
      if (healthLockerController.responseHandler.status == Status.success) {
        CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
          mContext: context,
          child: HealthLockerListWidget(
            healthLockerController: healthLockerController,
            isFromDashboard: true,
          ),
        ).whenComplete(() => DeleteControllers().deleteHealthLocker());
      }
    });
  }

  Future<bool> _onBackClick() async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openEndDrawer();
    } else if (_currentIndex == 0) {
      return await _dashboardController.showExitPopup(context);
    } else {
      _setTabConfig(0);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackClick(),
      child: GetBuilder<DashboardController>(
        builder: (dashboardController) {
          if (!Validator.isNullOrEmpty(
            dashboardController.hIpIdDataPullRecord,
          )) {
            _setTabConfig(0);
          }
          return BaseView(
            isKeyReq: true,
            isCenterTitle: false,
            title: _titleName,
            isDarkTabBar: _isDarkTabBar,
            type: DashboardView,
            bodyMobile: _currentWidget[_currentIndex],
            bodyDesktop: CustomDrawerDesktopView(
              widget: _currentDesktopWidget[0],
              showBackOption: false,
            ),
            paddingValueMobile: Dimen.d_0,
            elevation: _isDarkTabBar ? 0 : Dimen.d_4,
            bottomNavigationBar: kIsWeb ? null : _bottomNavigationBarWidget(),
            actions: _actionBarView(context),
            drawer: CustomDrawerMobileView(),
            floatingActionButton:
                kIsWeb || _currentIndex > 1 ? null : _floatingActionWidget(),
          );
        },
      ),
    );
  }

  List<Widget> _actionBarView(BuildContext context) {
    CustomAppBarMobileView customActionBarView = CustomAppBarMobileView(
      context,
      this,
      _isDarkTabBar,
    );
    List<Widget> appBarWidgetList = [
      if (kIsWeb)
        const SizedBox.shrink()
      else
        customActionBarView.qrCodeScannerWidget(_showQrScannerPopup),
      customActionBarView.notificationWidget(_onClickNotificationIcon),
      customActionBarView.profileWidget(_onClickProfileIcon)
    ];
    return appBarWidgetList;
  }

  Widget _dashboardTokenWidget() {
    return const TokenView();
  }

  Widget _dashboardProfileWidget({bool isWeb = false}) {
    return DashboardProfileView(isWeb: isWeb);
  }

  Widget _healthRecordWidget({bool isWeb = false}) {
    return (_dashboardController.isLinkedFacilityEmpty)
        ? DashboardNoFacilityLinkedView(
            onLinkFacilityClick: () {
              _onDiscoveryLinking();
            },
          )
        : HealthRecordView(isWeb: isWeb).paddingAll(Dimen.d_3);
  }

  Widget _homeMobileWidget() {
    return Column(
      children: [
        _dashboardTokenWidget(),
        _dashboardProfileWidget(),
        GetBuilder<DashboardController>(
          id: UpdateDashboardUI.noHipLinkOrPullRecords,
          builder: (_) {
            return kIsWeb
                ? _healthRecordWidget()
                : _healthRecordWidget().flexible();
          },
        ),
      ],
    );
  }

  Widget _homeDesktopWidget() {
    return GetBuilder<DashboardController>(
      id: UpdateDashboardUI.noHipLinkOrPullRecords,
      builder: (_) {
        return _healthRecordWidget(isWeb: true);
      },
    );
  }

  Widget _linkFacilityWidget() {
    return const LinkedFacilityView();
  }

  Widget _consentWidget() {
    return const ConsentsView();
  }

  Widget _qrScannerWidget() {
    return Text(
      LocalizationHandler.of().comingSoon,
      style: CustomTextStyle.bodySmall(context)
          ?.apply(color: AppColors.colorAppBlue, fontWeightDelta: 2),
    ).sizedBox().centerWidget;
  }

  Widget _floatingActionWidget() {
    return _currentIndex == 0
        ? GetBuilder<DashboardController>(
            id: UpdateDashboardUI.hideFabIcon,
            builder: (_) {
              return _floatingActionButtonWidget(
                isCustom: _dashboardController.isLinkedFacilityEmpty,
              );
            },
          )
        : _currentIndex == 1
            ? _floatingActionButtonWidget(isCustom: true)
            : const SizedBox.shrink();
  }

  Widget _floatingActionButtonWidget({bool isCustom = false}) {
    return isCustom
        ? TextButtonOrange.mobile(
            text: LocalizationHandler.of().linkNewFacility,
            leading: ImageLocalAssets.linkedFacilityChainIconSvg,
            onPressed: () {
              _onDiscoveryLinking();
            },
          )
        : FloatingActionButton(
            backgroundColor: AppColors.colorAppBlue,
            onPressed: () {
              _healthLockerBottomSheet();
            },
            child: Icon(
              IconAssets.uploadOutlinedIcon,
              color: AppColors.colorWhite,
              size: Dimen.d_35,
            ),
          );
  }

  Widget _bottomNavigationBarWidget() {
    return BottomNavigationBar(
      onTap: (newIndex) {
        if (newIndex == 2) {
          _showQrScannerPopup();
        } else {
          _setTabConfig(newIndex);
        }
      },
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        _bottomNavigationBarItem(
          ImageLocalAssets.myRecordsTabSelected,
          ImageLocalAssets.myRecordsTab,
          LocalizationHandler.of().my_records,
        ),
        _bottomNavigationBarItem(
          ImageLocalAssets.linkedFacilityTabSelected,
          ImageLocalAssets.linkedFacilityTab,
          LocalizationHandler.of().linkedFacility,
        ),
        _bottomNavigationBarItem(
          ImageLocalAssets.qrCodeScannerIconSvg,
          ImageLocalAssets.qrCodeTabIconSvg,
          LocalizationHandler.of().shareAndScan,
        ),
        _bottomNavigationBarItem(
          ImageLocalAssets.consentsTabSelected,
          ImageLocalAssets.consentsTab,
          LocalizationHandler.of().consents,
        ),
        // _bottomNavigationBarItem(
        //   ImageLocalAssets.nearbyTabSelected,
        //   ImageLocalAssets.nearbyTab,
        //   LocalizationHandler.of().nearby,
        // ),
      ],
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem(
    String activeIconPath,
    String iconPath,
    String textTitle,
  ) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        iconPath,
        width: Dimen.d_30,
        height: Dimen.d_30,
      ).paddingOnly(bottom: Dimen.d_8, top: Dimen.d_8),
      activeIcon: SvgPicture.asset(
        activeIconPath,
        width: Dimen.d_30,
        height: Dimen.d_30,
      ).paddingOnly(bottom: Dimen.d_8, top: Dimen.d_8),
      label: textTitle,
    );
  }
}
