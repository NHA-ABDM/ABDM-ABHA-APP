import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/back/custom_desktop_back_view.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_phone_size_view.dart';
import 'package:abha/reusable_widget/expanded/custom_expanded_card_view.dart';

class CustomDrawerDesktopView extends StatelessWidget {
  final Widget widget;
  final bool showBackOption;

  const CustomDrawerDesktopView({
    required this.widget,
    super.key,
    this.showBackOption = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.colorWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: abhaSingleton.getAppData.showDrawer,
            builder: (context, isDrawerExpanded, _) {
              return Expanded(
                flex: isDrawerExpanded ? 20 : 5,
                child: _drawerItemsListWidget(context, isDrawerExpanded),
              );
            },
          ),
          Expanded(
            flex: 80,
            child: Container(
              constraints: BoxConstraints(minHeight: context.height),
              color: AppColors.colorBlueLight8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (showBackOption)
                    const CustomDesktopBackView().marginOnly(
                      left: Dimen.d_20,
                      top: Dimen.d_20,
                    ),
                  widget
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItemsListWidget(BuildContext context, bool showLongDrawer) {
    return Column(
      children: [
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            size: 0,
            borderColor: AppColors.colorGreyLight7,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: showLongDrawer
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.spaceEvenly,
            children: [
              if (showLongDrawer)
                Expanded(
                  child: Text(
                    LocalizationHandler.of().mainMenu,
                    style: CustomTextStyle.bodyMedium(context)?.apply(
                      color: AppColors.colorAppBlue,
                    ),
                  ),
                ),
              InkWell(
                onTap: () {
                  abhaSingleton.getAppData.showDrawer.value =
                      showLongDrawer ? false : true;
                },
                child: Icon(
                  showLongDrawer
                      ? IconAssets.menuOpenOutlined
                      : IconAssets.navigateNext,
                  color: AppColors.colorAppBlue,
                ),
              ),
            ],
          ).marginSymmetric(horizontal: Dimen.d_18, vertical: Dimen.d_18),
        ),
        _drawerItemWidget(context),
      ],
    );
  }

  Widget _drawerItemWidget(BuildContext context) {
    return Column(
      children: [
        _drawerExpandedWidget(
          context,
          menu: CustomDrawerMenuModel(
            title: LocalizationHandler.of().my_records.toSentanceCase(),
            icon: ImageLocalAssets.myRecordsTabSelected,
            route: RoutePath.routeDashboard,
            onClick: () {
              context.navigatePush(RoutePath.routeDashboard);
            },
          ),
        ),
        _drawerExpandedWidget(
          context,
          menu: CustomDrawerMenuModel(
            title: LocalizationHandler.of().linkedFacility.toSentanceCase(),
            icon: ImageLocalAssets.linkedFacilityTab,
            route: RoutePath.routeLinkFacility,
            onClick: () {
              context.navigatePush(RoutePath.routeLinkFacility);
            },
          ),
        ),
        _drawerExpandedWidget(
          context,
          menu: CustomDrawerMenuModel(
            title: LocalizationHandler.of().consents,
            icon: ImageLocalAssets.consentsTab,
            route: RoutePath.routeConsent,
            onClick: () {
              context.navigatePush(
                RoutePath.routeConsent,
                arguments: {
                  IntentConstant.navigateFrom:
                      GlobalEnumNavigationType.navDefault
                },
              );
            },
          ),
        ),
        _drawerExpandedWidget(
          context,
          menu: CustomDrawerMenuModel(
            title: LocalizationHandler.of().drawer_healthlocker,
            icon: ImageLocalAssets.healthLockerIcon,
            route: RoutePath.routeHealthLocker,
            onClick: () {
              context.navigatePush(RoutePath.routeHealthLocker);
            },
          ),
        ),
        _drawerExpandedWidget(
          context,
          menu: CustomDrawerMenuModel(
            title: LocalizationHandler.of().setting_notification,
            icon: ImageLocalAssets.notifications,
            route: RoutePath.routeNotification,
            onClick: () {
              context.navigatePush(RoutePath.routeNotification);
            },
          ),
        ),
        _drawerExpandedWidget(
          context,
          menu: CustomDrawerMenuModel(
            title: LocalizationHandler.of().drawerMyAccount.toSentanceCase(),
            icon: ImageLocalAssets.profile,
            route: RoutePath.routeAccount,
            onClick: () {},
            submenu: [
              CustomDrawerMenuModel(
                title: LocalizationHandler.of().my_profile,
                icon: ImageLocalAssets.profile,
                route: RoutePath.routeProfileView,
                onClick: () {
                  context.navigatePush(RoutePath.routeProfileView);
                },
              ),
              CustomDrawerMenuModel(
                title: LocalizationHandler.of().editProfile.toSentanceCase(),
                icon: ImageLocalAssets.edit,
                route: RoutePath.routeProfileUpdateAddress,
                onClick: () {
                  context.navigatePush(RoutePath.routeProfileUpdateAddress);
                },
              ),
              CustomDrawerMenuModel(
                title: LocalizationHandler.of().setting_reset_password,
                icon: ImageLocalAssets.resetPassword,
                route: RoutePath.routeSettingsResetPassword,
                onClick: () {
                  context.navigatePush(RoutePath.routeSettingsResetPassword);
                },
              ),
              CustomDrawerMenuModel(
                title: LocalizationHandler.of().setting_submit_feeback,
                icon: ImageLocalAssets.feedback,
                route: RoutePath.routeSubmitFeedback,
                onClick: () {
                  context.navigatePush(RoutePath.routeSubmitFeedback);
                },
              ),
            ],
          ),
        ),
        _drawerExpandedWidget(
          context,
          menu: CustomDrawerMenuModel(
            title: LocalizationHandler.of().titleAbhaNumber,
            icon: ImageLocalAssets.profileAbhaNumberIconSvg,
            route: RoutePath.routeAbha,
            onClick: () {},
            submenu: [
              CustomDrawerMenuModel(
                title: LocalizationHandler.of().setting_create_abha_number,
                icon: ImageLocalAssets.drawerCreateAbhaNumber,
                onClick: () {
                  CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
                },
              ),
              if (abhaSingleton.getAppData.getLogin() &&
                  !Validator.isNullOrEmpty(Get.find<ProfileController>()) &&
                  !Get.find<ProfileController>().getKycDetail())
                CustomDrawerMenuModel(
                  title: LocalizationHandler.of().labelLinkAbhaNumber,
                  icon: ImageLocalAssets.drawerLinkAbhaSvg,
                  route: RoutePath.routeLinkAbhaNumber,
                  onClick: () {
                    context.navigatePush(RoutePath.routeLinkAbhaNumber);
                  },
                ),
            ],
          ),
        )
      ],
    );
  }

  Widget _drawerExpandedWidget(
    BuildContext context, {
    required CustomDrawerMenuModel menu,
  }) {
    if (menu.submenu.isNotEmpty) {
      List<String> currentRouteName = abhaSingleton.getAppData
          .getRouterGenerator()
          .router
          .location
          .split('/');
      bool isCurrentRoute =
          currentRouteName[1].contains('${menu.route?.split('/')[1]}')
              ? true
              : false;
      return CustomExpandedCardView(
        isCurrentRoute: isCurrentRoute,
        header: Row(
          children: WidgetUtility.spreadWidgets(
            [
              Expanded(
                child: abhaSingleton.getAppData.showDrawer.value
                    ? Text(
                        menu.title,
                        style: CustomTextStyle.titleMedium(context)?.apply(
                          fontWeightDelta: 1,
                          color: AppColors.colorBlackLight,
                        ),
                      ).marginOnly(left: Dimen.d_12)
                    : CustomSvgImageView(menu.icon!),
              )
            ],
            interItemSpace: Dimen.d_12,
          ),
        ),
        child: Column(
          children: menu.submenu.map((e) {
            String currentRoute =
                abhaSingleton.getAppData.getRouterGenerator().router.location;
            bool route = currentRoute != e.route ? false : true;
            return InkWell(
              onTap: e.onClick,
              child: Container(
                height: Dimen.d_60,
                decoration:
                    abhaSingleton.getBorderDecoration.getHorizontalLine(),
                child: Row(
                  children: WidgetUtility.spreadWidgets(
                    [
                      Container(
                        height: Dimen.d_60,
                        width: Dimen.d_8,
                        color: (route)
                            ? AppColors.colorAppOrange
                            : AppColors.colorPurple4,
                      ),
                      Expanded(
                        child: abhaSingleton.getAppData.showDrawer.value
                            ? Text(
                                e.title,
                                style:
                                    CustomTextStyle.titleMedium(context)?.apply(
                                  fontWeightDelta: 1,
                                  color: (route)
                                      ? AppColors.colorAppOrange
                                      : AppColors.colorBlackLight,
                                ),
                              ).marginOnly(left: Dimen.d_40)
                            : CustomSvgImageView(e.icon!),
                      )
                    ],
                    interItemSpace: Dimen.d_12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else {
      String currentRouteName =
          abhaSingleton.getAppData.getRouterGenerator().router.location;
      bool isCurrentRoute = currentRouteName != menu.route ? false : true;
      return InkWell(
        onTap: menu.onClick,
        child: Container(
          height: Dimen.d_60,
          decoration: abhaSingleton.getBorderDecoration.getHorizontalLine(),
          child: Row(
            children: WidgetUtility.spreadWidgets(
              [
                Container(
                  height: Dimen.d_60,
                  width: Dimen.d_8,
                  color: (isCurrentRoute)
                      ? AppColors.colorAppOrange
                      : AppColors.colorPurple4,
                ),
                Expanded(
                  child: abhaSingleton.getAppData.showDrawer.value
                      ? Text(
                          menu.title,
                          style: CustomTextStyle.titleMedium(context)?.apply(
                            fontWeightDelta: 1,
                            color: (isCurrentRoute)
                                ? AppColors.colorAppOrange
                                : AppColors.colorBlackLight,
                          ),
                        ).marginOnly(left: Dimen.d_12)
                      : CustomSvgImageView(menu.icon!),
                )
              ],
              interItemSpace: Dimen.d_12,
            ),
          ),
        ),
      );
    }
  }
}
