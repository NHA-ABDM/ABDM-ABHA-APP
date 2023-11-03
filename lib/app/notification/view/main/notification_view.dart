import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/app/notification/view/desktop/notification_desktop_view.dart';
import 'package:abha/app/notification/view/mobile/notification_mobile_view.dart';
import 'package:abha/export_packages.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  NotificationViewState createState() => NotificationViewState();
}

class NotificationViewState extends State<NotificationView> {
  late NotificationController _notificationController;
  late DashboardController _dashboardController;
  late ScrollController _scrollController;

  @override
  void initState() {
    _init();
    _listener();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onFetchNotification(true);
    });
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteNotification();
    super.dispose();
  }

  void _init() {
    _notificationController =
        Get.put(NotificationController(NotificationRepoImpl()));
    _scrollController = ScrollController();
    _dashboardController = Get.find<DashboardController>();
  }

  void _listener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _onFetchNotification(false);
      }
    });
  }

  /// @Here function to fetch Notifications in list.
  Future<void> _onFetchNotification(bool isUpdateUiOnLoading) async {
    _notificationController.functionHandler(
      function: () async {
        await _notificationController.getNotificationFetch(isUpdateUiOnLoading);
        _dashboardController.handleNotificationCount(_notificationController);
      },
      isLoaderReq: isUpdateUiOnLoading,
      isUpdateUi: true,
      isUpdateUiOnLoading: isUpdateUiOnLoading,
      isUpdateUiOnError: true,
    );
  }

  Future<void> _callNotificationRead(int id) async {
    _notificationController.functionHandler(
      function: () => _notificationController.readNotification(id),
    );
  }

  // mark the notification is read by assigning the boolean value
  Future<void> _changeStatusOfNotification(int id) async {
    _notificationController.notificationsData
        .firstWhere((element) => element.id == id)
        .isNotificationRead = true;
    int unreadCount = _notificationController.notificationsData.elementAt(0).unreadCount ?? 0;
    _notificationController.notificationsData.elementAt(0).unreadCount = unreadCount -1;
    _notificationController.update();
    _dashboardController.handleNotificationCount(_notificationController);
  }

  /// @Here function navigate to screens on click of Notification list item on the basis of target string got from NotificationModel object.
  void _navOnNotificationClick(NotificationModel tempNotification) {
    context.navigatePush(
      RoutePath.routeConsent,
      arguments: {
        IntentConstant.data: tempNotification,
        IntentConstant.navigateFrom: GlobalEnumNavigationType.notification,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().setting_notification,
      type: NotificationView,
      bodyDesktop: NotificationDesktopView(
        onFetchNotification: _onFetchNotification,
        onNotificationClick: onNotificationClick,
      ),
      bodyMobile: NotificationMobileView(
        onFetchNotification: _onFetchNotification,
        onNotificationClick: onNotificationClick,
      ),
    );
  }

  void onNotificationClick(
    int notificationId,
    NotificationModel notifications,
  ) {
    _callNotificationRead(notificationId);
    _changeStatusOfNotification(notificationId);
    _navOnNotificationClick(notifications);
  }
}
