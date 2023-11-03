import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/expanded/custom_expanded_card_view.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';

class CustomDrawerMenuModel {
  final String title;
  final VoidCallback onClick;
  final String? route;
  final String? icon;
  final List<CustomDrawerMenuModel> submenu;

  CustomDrawerMenuModel({
    required this.title,
    required this.onClick,
    this.icon,
    this.route,
    this.submenu = const [],
  });
}

class CustomDrawerDesktopPhoneSizeView extends StatelessWidget {
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  CustomDrawerDesktopPhoneSizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return _drawer(context);
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _drawerHeaderView(context),
          _drawerItemsList(context),
        ],
      ),
    );
  }

  Widget _drawerHeaderView(BuildContext context) {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        size: 0,
        borderColor: AppColors.colorGreyLight7,
      ),
      child: Row(
        children: [
          // CustomSvgImageView(
          //   ImageLocalAssets.menuIconSvg,
          //   width: Dimen.d_25,
          //   height: Dimen.d_25,
          // ),
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
              context.navigateBack();
            },
            child: Icon(
              IconAssets.close,
              size: Dimen.d_25,
              color: AppColors.colorAppBlue,
            ),
          )
        ],
      ).paddingAll(Dimen.d_20),
    );
  }

  Widget _drawerItemsList(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (!abhaSingleton.getAppData.getLogin())
              Column(
                children: [
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of().home,
                      route: RoutePath.routeAppIntro,
                      onClick: () {
                        _toggleDrawer(context);
                      },
                    ),
                  ),
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of().aboutUs,
                      onClick: () {},
                      submenu: [
                        CustomDrawerMenuModel(
                          title: LocalizationHandler.of().abdm,
                          onClick: () {
                            _toggleDrawer(context);
                            _launchURLService.launchInBrowserLink(
                              Uri.parse(AbdmUrlConstant.getAboutABDMUrl()),
                            );
                          },
                        ),
                        CustomDrawerMenuModel(
                          title: LocalizationHandler.of().nha,
                          onClick: () {
                            _toggleDrawer(context);
                            _launchURLService.launchInBrowserLink(
                              Uri.parse(AbdmUrlConstant.getAboutNHAUrl()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of().resourceCenter,
                      onClick: () {},
                      submenu: [
                        CustomDrawerMenuModel(
                          title: LocalizationHandler.of()
                              .healthDataManagementPolicy,
                          onClick: () {
                            _toggleDrawer(context);
                            _launchURLService.launchInBrowserLink(
                              Uri.parse(
                                AbdmUrlConstant.getHealthDataManagementUrl(),
                              ),
                            );
                          },
                        ),
                        CustomDrawerMenuModel(
                          title: LocalizationHandler.of().newsAndMedia,
                          onClick: () {
                            _toggleDrawer(context);
                            _launchURLService.launchInBrowserLink(
                              Uri.parse(AbdmUrlConstant.getNewsAndMediaUrl()),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of().support,
                      onClick: () {},
                      submenu: [
                        CustomDrawerMenuModel(
                          title: LocalizationHandler.of()
                              .grievancePortal
                              .toTitleCase(),
                          onClick: () {
                            _toggleDrawer(context);
                            _launchURLService.launchInBrowserLink(
                              Uri.parse(AbdmUrlConstant.getGrievancePortal()),
                            );
                          },
                        ),
                        CustomDrawerMenuModel(
                          title:
                              LocalizationHandler.of().contactUs.toTitleCase(),
                          onClick: () {
                            _toggleDrawer(context);
                            context.navigatePush(RoutePath.routeSupport);
                            // abhaSingleton.launchURLService.launchInBrowserLink(Uri.parse(AbdmUrlConstant.getNewsAndMediaUrl()));
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (abhaSingleton.getAppData.getLogin())
              Column(
                children: [
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title:
                          LocalizationHandler.of().my_records.toSentanceCase(),
                      route: RoutePath.routeDashboard,
                      onClick: () {
                        _toggleDrawer(context);
                        context.navigatePush(RoutePath.routeDashboard);
                      },
                    ),
                  ),
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of()
                          .linkedFacility
                          .toSentanceCase(),
                      route: RoutePath.routeLinkFacility,
                      onClick: () {
                        _toggleDrawer(context);
                        context.navigatePush(RoutePath.routeLinkFacility);
                      },
                    ),
                  ),
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of().consents,
                      route: RoutePath.routeConsent,
                      onClick: () {
                        _toggleDrawer(context);
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
                      route: RoutePath.routeHealthLocker,
                      onClick: () {
                        _toggleDrawer(context);
                        context.navigatePush(RoutePath.routeHealthLocker);
                      },
                    ),
                  ),
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of().setting_notification,
                      route: RoutePath.routeNotification,
                      onClick: () {
                        _toggleDrawer(context);
                        context.navigatePush(RoutePath.routeNotification);
                      },
                    ),
                  ),
                  _drawerExpandedWidget(
                    context,
                    menu: CustomDrawerMenuModel(
                      title: LocalizationHandler.of()
                          .drawerMyAccount
                          .toSentanceCase(),
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
                          title: LocalizationHandler.of()
                              .editProfile
                              .toSentanceCase(),
                          icon: ImageLocalAssets.edit,
                          route: RoutePath.routeProfileUpdateAddress,
                          onClick: () {
                            context.navigatePush(
                              RoutePath.routeProfileUpdateAddress,
                            );
                          },
                        ),
                        CustomDrawerMenuModel(
                          title:
                              LocalizationHandler.of().setting_reset_password,
                          icon: ImageLocalAssets.resetPassword,
                          route: RoutePath.routeSettingsResetPassword,
                          onClick: () {
                            context.navigatePush(
                              RoutePath.routeSettingsResetPassword,
                            );
                          },
                        ),
                        CustomDrawerMenuModel(
                          title:
                              LocalizationHandler.of().setting_submit_feeback,
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
                          title: LocalizationHandler.of()
                              .setting_create_abha_number,
                          icon: ImageLocalAssets.drawerCreateAbhaNumber,
                          onClick: () {
                            CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
                          },
                        ),
                        if (abhaSingleton.getAppData.getLogin() &&
                            !Validator.isNullOrEmpty(
                              Get.find<ProfileController>(),
                            ) &&
                            !Get.find<ProfileController>().getKycDetail())
                          CustomDrawerMenuModel(
                            title: LocalizationHandler.of().labelLinkAbhaNumber,
                            icon: ImageLocalAssets.drawerLinkAbhaSvg,
                            route: RoutePath.routeLinkAbhaNumber,
                            onClick: () {
                              context
                                  .navigatePush(RoutePath.routeLinkAbhaNumber);
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ).marginOnly(bottom: Dimen.d_50),
      ),
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

  void _toggleDrawer(BuildContext context) {
    context.navigateBack();
  }
}
