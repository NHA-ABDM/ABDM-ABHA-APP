import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:abha/reusable_widget/table/table_header_view.dart';
import 'package:abha/reusable_widget/table/table_row_view.dart';

class NotificationDesktopView extends StatefulWidget {
  final Function(bool resetData) onFetchNotification;
  final Function(int id, NotificationModel notificationModel)
      onNotificationClick;

  const NotificationDesktopView({
    required this.onFetchNotification,
    required this.onNotificationClick,
    super.key,
  });

  @override
  NotificationDesktopViewState createState() => NotificationDesktopViewState();
}

class NotificationDesktopViewState extends State<NotificationDesktopView> {
  late NotificationController _notificationController;
  late ScrollController _scrollController;

  @override
  void initState() {
    _init();
    _listener();
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteNotification();
    super.dispose();
  }

  void _init() {
    _notificationController = Get.find<NotificationController>();
    _scrollController = ScrollController();
  }

  void _listener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.onFetchNotification(false);
      }
    });
  }

  /// @Here function refresh the list on pulling.
  Future<void> _pullRefresh() async {
    widget.onFetchNotification(true);
  }

  List<NotificationModel> _getNotificationDataList() {
    List<NotificationModel> notificationsList =
        _notificationController.notificationsData;
    return notificationsList;
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: _notificationWidget()
          .paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20),
      showBackOption: false,
    );
  }

  Widget _notificationWidget() {
    return GetBuilder<NotificationController>(
      builder: (_) {
        List<NotificationModel> notificationsList = _getNotificationDataList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocalizationHandler.of().setting_notification.toTitleCase(),
                  style: CustomTextStyle.titleLarge(context)?.apply(
                    color: AppColors.colorAppBlue,
                    fontWeightDelta: 2,
                  ),
                ),
                if ((!Validator.isNullOrEmpty(notificationsList)))
                  InkWell(
                    onTap: () {
                      _pullRefresh();
                    },
                    child: Row(
                      children: [
                        Icon(
                          IconAssets.refresh,
                          color: AppColors.colorAppOrange,
                          size: Dimen.d_18,
                        ),
                        Text(
                          LocalizationHandler.of().refreshRecords,
                          style: CustomTextStyle.bodySmall(context)?.apply(
                            decoration: TextDecoration.underline,
                            color: AppColors.colorAppOrange,
                            fontWeightDelta: 2,
                            fontSizeDelta: -2,
                          ),
                        ),
                      ],
                    ),
                  )
              ],
            ).marginOnly(bottom: Dimen.d_20),
            if (Validator.isNullOrEmpty(notificationsList))
              _emptyListWidget()
            else
              listMobileWidget(notificationsList)
          ],
        );
      },
    );
  }

  Widget _emptyListWidget() {
    return CustomErrorView(
      image: ImageLocalAssets.emptyNotificationSvg,
      onRetryPressed: () {
        widget.onFetchNotification(true);
      },
      status: _notificationController.responseHandler.status ?? Status.none,
    );
  }

  Widget listMobileWidget(List<NotificationModel> notificationsList) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TableHeaderView(
          children: [
            SizedBox(
              width: Dimen.d_10,
            ).marginOnly(right: Dimen.d_16),
            Expanded(
              flex: 2,
              child: Text(
                LocalizationHandler.of().title,
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorWhite),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                LocalizationHandler.of().description,
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorWhite),
              ),
            ),
            Expanded(
              child: Text(
                LocalizationHandler.of().date,
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorWhite),
              ),
            )
          ],
        ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _notificationController.notificationsData.length,
            controller: _scrollController,
            itemBuilder: (context, position) {
              Color backgroundColor = (position % 2 == 0)
                  ? AppColors.colorWhite
                  : AppColors.colorGreyVeryLight;

              NotificationModel notifications = notificationsList[position];
              return _cardItemViewWidget(notifications, backgroundColor);
            },
          ),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _notificationController.isShowLoadMore,
          builder: (context, showLoadMore, _) {
            return showLoadMore
                ? ElevatedButtonBlueBorder.desktop(
                    onPressed: () {
                      widget.onFetchNotification(false);
                    },
                    text: LocalizationHandler.of().loadMore,
                  ).marginOnly(top: Dimen.d_10)
                : const SizedBox.shrink();
          },
        )
      ],
    );
  }

  Widget _cardItemViewWidget(
    NotificationModel notifications,
    Color backgroundColor,
  ) {
    bool isNotificationRead =
        !Validator.isNullOrEmpty(notifications.isNotificationRead) &&
            notifications.isNotificationRead == true;

    return TableRowView(
      onClick: () {
        int notificationId = notifications.id ?? 0;
        widget.onNotificationClick(notificationId, notifications);
      },
      backgroundColor: backgroundColor,
      children: [
        if (isNotificationRead)
          SizedBox(
            width: Dimen.d_10,
          ).marginOnly(right: Dimen.d_16)
        else
          Icon(
            IconAssets.darkCircle,
            size: Dimen.d_10,
            color: AppColors.colorOrangeDark2,
          ).marginOnly(right: Dimen.d_16),
        Expanded(
          flex: 2,
          child: Text(
            notifications.pushNotificationData?.title.toString() ?? '',
            style: CustomTextStyle.bodySmall(
              context,
            )?.apply(
              color: (isNotificationRead)
                  ? AppColors.colorBlack
                  : context.themeData.primaryColor,
              fontWeightDelta: (isNotificationRead) ? -1 : 1,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            notifications.pushNotificationData?.body
                    .toString()
                    .replaceAll('\n', ' ') ??
                '',
            style: CustomTextStyle.bodySmall(
              context,
            )?.apply(
              color: (isNotificationRead)
                  ? AppColors.colorBlack
                  : context.themeData.primaryColor,
              fontWeightDelta: (isNotificationRead) ? -1 : 1,
            ),
          ),
        ),
        Text(
          '${getAddedDateTime(notifications.dateCreated.toString()).formatDDMMMYYYY}  ${getAddedDateTime(notifications.dateCreated.toString()).formatHHMMA}',
          textAlign: TextAlign.end,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack,
            fontWeightDelta: -1,
            fontSizeDelta: -1,
          ),
        )
      ],
    );
  }
}

String getAddedDateTime(String dateTime) {
  DateTime date = DateTime.parse(dateTime).toLocal();
  return date.getAddedDateTime(date.toString());
}
