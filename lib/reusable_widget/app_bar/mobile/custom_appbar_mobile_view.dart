import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_loading_view.dart';

class CustomAppBarMobileView {
  late BuildContext context;
  late dynamic widget;
  late bool isDarkTabBar = true;
  late Color iconColor;

  CustomAppBarMobileView(
    this.context,
    this.widget,
    this.isDarkTabBar,
  ) {
    iconColor = isDarkTabBar
        ? Theme.of(context).primaryColorLight
        : Theme.of(context).primaryColorDark;
  }

  Widget _actionBarView(
    String iconName,
    Color iconColor,
    VoidCallback onClick,
    double? width,
    double? height,
  ) {
    return InkWell(
      onTap: onClick,
      child: CustomSvgImageView(
        iconName,
        width: width,
        height: height,
        color: iconColor,
      ).marginOnly(bottom: Dimen.d_1),
    );
  }

  Widget qrCodeScannerWidget(VoidCallback onClickQrScannerView) {
    return _actionBarView(
      ImageLocalAssets.qrCodeScannerIconSvg,
      iconColor,
      onClickQrScannerView,
      Dimen.d_30,
      Dimen.d_30,
    ).marginOnly(right: Dimen.d_20);
  }

  Widget notificationWidget(VoidCallback onClickNotificationView) {
    return Stack(
      children: [
        _actionBarView(
          ImageLocalAssets.actionBarNotificationIconSvg,
          iconColor,
          onClickNotificationView,
          Dimen.d_30,
          Dimen.d_30,
        ).marginOnly(right: Dimen.d_20, top: Dimen.d_13),
        Positioned(
          top: Dimen.d_5,
          left: Dimen.d_15,
          child: GetBuilder<DashboardController>(
            id: UpdateDashboardUI.notificationCount,
            builder: (dashboardController) {
              int unreadNotification = dashboardController.unreadNotificationCount;
              return unreadNotification < 0
                  ? CustomLoadingView(
                      color: AppColors.colorWhite,
                      strokeWidth: 2.0,
                      width: Dimen.d_10,
                      height: Dimen.d_10,
                    )
                  : unreadNotification == 0
                      ? const SizedBox.shrink()
                      : Container(
                          decoration: abhaSingleton.getBorderDecoration
                              .getRectangularBorder(
                            color: AppColors.colorOrangeDark2,
                            borderColor: AppColors.colorWhite,
                            size: 6,
                          ),
                          child: Text(
                            unreadNotification.toString(),
                            style: CustomTextStyle.labelMedium(context)?.apply(
                              color: AppColors.colorWhite,
                              fontSizeDelta: -1,
                            ),
                          ).paddingAll(Dimen.d_2),
                        );
            },
          ),
        ),
      ],
    );
  }

  Widget profileWidget(VoidCallback onProfileClick) {
    return _actionBarView(
      ImageLocalAssets.userProfileIconSvg,
      iconColor,
      onProfileClick,
      Dimen.d_30,
      Dimen.d_30,
    ).marginOnly(right: Dimen.d_20);
  }
}
