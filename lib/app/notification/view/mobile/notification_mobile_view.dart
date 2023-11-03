import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_error_view.dart';
import 'package:abha/reusable_widget/common/view_details_card.dart';
import 'package:flutter/foundation.dart';

class NotificationMobileView extends StatefulWidget {
  final Function(bool resetData) onFetchNotification;
  final Function(int id, NotificationModel notificationModel)
      onNotificationClick;

  const NotificationMobileView({
    required this.onFetchNotification,
    required this.onNotificationClick,
    super.key,
  });

  @override
  NotificationMobileViewState createState() => NotificationMobileViewState();
}

class NotificationMobileViewState extends State<NotificationMobileView> {
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
    widget.onFetchNotification(false);
  }

  List<NotificationModel> _getNotificationDataList() {
    List<NotificationModel> notificationsList =
        _notificationController.notificationsData;
    return notificationsList;
  }

  @override
  Widget build(BuildContext context) {
    return _notificationMobileWidget();
  }

  Widget _notificationMobileWidget() {
    return GetBuilder<NotificationController>(
      builder: (_) {
        List<NotificationModel> notificationsList = _getNotificationDataList();
        return (Validator.isNullOrEmpty(notificationsList))
            ? _emptyListWidget()
            : listMobileWidget(notificationsList);
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
    return RefreshIndicator(
      onRefresh: _pullRefresh,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: _notificationController.notificationsData.length,
              controller: _scrollController,
              itemBuilder: (context, position) {
                NotificationModel notifications = notificationsList[position];
                return _cardItemViewWidget(notifications, false);
              },
            ),
          ),
          if (kIsWeb)
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
          else
            ValueListenableBuilder<bool>(
              valueListenable: _notificationController.isRequestInProgress,
              builder: (context, isRequestInProgress, _) {
                return isRequestInProgress
                    ? Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ).paddingSymmetric(
                        vertical: Dimen.d_10,
                        horizontal: Dimen.d_10,
                      )
                    : const SizedBox.shrink();
              },
            )
        ],
      ),
    );
  }

  Widget _cardItemViewWidget(
    NotificationModel notifications,
    bool isDesktopView,
  ) {
    return ViewDetailsCard(
      isDeskTopView: isDesktopView,
      onClick: () {
        int notificationId = notifications.id ?? 0;
        widget.onNotificationClick(notificationId, notifications);
      },
      backgroundColor:
          (!Validator.isNullOrEmpty(notifications.isNotificationRead) &&
                  notifications.isNotificationRead == true)
              ? AppColors.colorGreyLight9
              : AppColors.colorWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _getTitlePurposeWidget(notifications)),
          _getTimeMonthWidget(notifications).marginOnly(left: Dimen.d_18),
        ],
      ).marginSymmetric(horizontal: Dimen.d_16, vertical: Dimen.d_16),
    );
  }

  Widget _getTitlePurposeWidget(NotificationModel notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              notifications.pushNotificationData?.title.toString() ?? '',
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorGreyDark2,
                fontWeightDelta: 2,
              ),
            ).marginOnly(top: Dimen.d_5),
            if (!Validator.isNullOrEmpty(notifications.isNotificationRead) &&
                notifications.isNotificationRead == true)
              const SizedBox.shrink()
            else
              Icon(
                IconAssets.darkCircle,
                size: Dimen.d_10,
                color: AppColors.colorOrangeDark2,
              ).marginOnly(left: Dimen.d_10, top: Dimen.d_5)
          ],
        ),
        Text(
          notifications.pushNotificationData?.body.toString() ?? '',
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorGreyDark2,
            fontSizeDelta: -2,
          ),
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          maxLines: 4,
        ).sizedBox(width: context.width * 0.6).marginOnly(top: Dimen.d_10),
      ],
    );
  }

  Widget _getTimeMonthWidget(NotificationModel notifications) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          getAddedDateTime(notifications.dateCreated.toString()).formatHHMMA,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorGreyDark7,
            fontSizeDelta: -3,
          ),
        ).marginOnly(top: Dimen.d_10),
        Text(
          getAddedDateTime(notifications.dateCreated.toString())
              .formatDDMMMYYYY,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorGreyDark7,
            fontSizeDelta: -3,
          ),
        ).marginOnly(top: Dimen.d_10),
      ],
    );
  }
}

String getAddedDateTime(String dateTime) {
  DateTime date = DateTime.parse(dateTime).toLocal();
  return date.getAddedDateTime(date.toString());
}
