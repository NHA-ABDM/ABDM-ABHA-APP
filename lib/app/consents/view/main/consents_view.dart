import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/consents/view/desktop/consents_desktop_view.dart';
import 'package:abha/app/consents/view/mobile/consents_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class ConsentsView extends StatefulWidget {
  final Map? arguments;

  const ConsentsView({super.key, this.arguments});

  @override
  State<ConsentsView> createState() => _ConsentsViewState();
}

class _ConsentsViewState extends State<ConsentsView>
    with TickerProviderStateMixin {
  late ConsentController _consentController;
  late String _consentRequestId;
  late String _authorizationRequestId;
  late String _subscriptionRequestId;
  late GlobalEnumNavigationType _navigateFrom;
  final bool _refresh = false;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    abhaSingleton.getLocalNotificationService.notificationType(false);
    DeleteControllers().deleteConsent();
    super.dispose();
  }

  void _init() {
    _consentController = Get.put(ConsentController(ConsentRepoImpl()));
    _navigateFrom = widget.arguments?[IntentConstant.navigateFrom] ??
        GlobalEnumNavigationType.navDefault;
    abhaSingleton.getLocalNotificationService
        .notificationType(true, voidCallback: _showPushNotificationDialog);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fromOutsideConsentScope();
    });
  }

  void _showPushNotificationDialog() {
    Map dataPayload = abhaSingleton.getAppData.getDataPayload();
    Map consentParam = jsonDecode(dataPayload['params']);
    String consentRequestId = consentParam['consent_request_id'];
    MessageBar.dismissSnackBar();
    var arguments = {IntentConstant.data: consentRequestId};
    _navPushHandler(arguments);
  }

  void _fromOutsideConsentScope() {
    if (_navigateFrom == GlobalEnumNavigationType.pushNotification ||
        _navigateFrom == GlobalEnumNavigationType.dashboard) {
      _consentRequestId = widget.arguments?[IntentConstant.data] ?? '';
      var arguments = {IntentConstant.data: _consentRequestId};
      _navPushHandler(arguments);
    } else if (_navigateFrom == GlobalEnumNavigationType.notification) {
      _fetchData();
    } else {}
  }

  void _fetchData() {
    NotificationModel tempNotification =
        widget.arguments?[IntentConstant.data] ?? NotificationModel();
    String targetData = tempNotification.pushNotificationData?.target ?? '';
    if (targetData.contains('ConsentDetailsActivity')) {
      _consentRequestId =
          tempNotification.pushNotificationData?.params?.consentRequestId ?? '';
      _callConsentRequest();
    } else if (targetData.contains('LinkLockerDetailsActivity')) {
      _authorizationRequestId = tempNotification
              .pushNotificationData?.params?.authorizationRequestId ??
          '';
      _subscriptionRequestId = tempNotification
              .pushNotificationData?.params?.subscriptionRequestId ??
          '';
      var arguments = {
        IntentConstant.requestId: _authorizationRequestId,
        IntentConstant.subscriptionID: _subscriptionRequestId
      };
      _navPushHandler(
        arguments,
        routePath:
            RoutePath.routeConsent + RoutePath.routeConsentArtefactsDetail,
      );
    } else {
      context.navigateBack();
    }
  }

  void _callConsentRequest() async {
    _consentController
        .functionHandler(
      function: () =>
          _consentController.fetchConsentRequestById(_consentRequestId),
      isLoaderReq: true,
    )
        .whenComplete(() {
      if (_consentController.consentRequest?.status == ConsentStatus.granted) {
        if (kIsWeb) {
          String routeName = RouteName.consentMine;
          _navPushNamedHandler(_consentRequestId, routeName);
        } else {
          String routePath = RoutePath.routeConsentsMine;
          var arguments = {IntentConstant.data: _consentRequestId};
          _navPushHandler(arguments, routePath: routePath);
        }
      } else {
        var arguments = {IntentConstant.data: _consentRequestId};
        _navPushHandler(arguments);
      }
    });
  }

  void _navPushHandler(
    Map arguments, {
    String routePath = RoutePath.routeConsentDetails,
  }) {
    context
        .navigatePush(
      routePath,
      arguments: arguments,
    )
        .whenComplete(() {
      // --------if wants to go back directly------------
      context.navigateBack();
      // --------if wants to stay here------------
      // setState(() {
      //   _refresh = true;
      // });
    });
  }

  void _navPushNamedHandler(String consentRequestId, String routeName) {
    /// Added push replacement as we supposed to remove this view from backstack so that when user clicks on back on web user should be redirected to notifications view
    context.navigatePushReplacementNamed(
      routeName,
      params: {
        RouteParam.consentIdParamKey: consentRequestId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isNavDefault = _navigateFrom == GlobalEnumNavigationType.navDefault;
    return BaseView(
      isAppBar: isNavDefault ? false : true,
      title: LocalizationHandler.of().consents,
      type: ConsentsView,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: isNavDefault
          ? const ConsentsMobileView()
          : _refresh
              ? const ConsentsMobileView()
              : const SizedBox.shrink(),
      bodyDesktop: isNavDefault
          ? const ConsentsDesktopView()
          : _refresh
              ? const ConsentsDesktopView()
              : const SizedBox.shrink(),
    );
  }
}
