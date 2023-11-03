import 'dart:io';
import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';
import 'package:abha/utils/global/global_key.dart';

class CustomDrawerMobileView extends StatelessWidget {
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();
  CustomDrawerMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return _drawer(context);
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.colorWhite1,
      child: Column(
        children: [
          _drawerHeader(context),
          _drawerItemsList(context),
        ],
      ),
    ).sizedBox(width: context.width);
  }

  Widget _drawerHeader(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorAppBlue,
      child: SafeArea(
        bottom: false,
        child: _drawerHeaderView(context),
      ),
    );
  }

  /// Here Widget is to show header on Navigation Drawer view.
  /// @params  [context] BuildContext
  Widget _drawerHeaderView(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorAppBlue,
      child: Row(
        children: [
          CustomSvgImageView(
            ImageLocalAssets.menuIconSvg,
            width: Dimen.d_25,
            height: Dimen.d_25,
          ),
          Expanded(
            child: Text(
              LocalizationHandler.of().menu,
              style: CustomTextStyle.bodySmall(context)
                  ?.apply(color: AppColors.colorWhite, fontWeightDelta: 2),
            ).marginOnly(left: Dimen.d_20, right: Dimen.d_20),
          ),
          InkWell(
            onTap: () {
              _toggleDrawer();
            },
            child: Icon(
              IconAssets.close,
              size: Dimen.d_25,
              color: AppColors.colorWhite,
            ),
          )
        ],
      ).paddingAll(Dimen.d_20),
    );
  }

  Widget _drawerItemsList(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _drawerView(
              icon: ImageLocalAssets.healthLockerIcon,
              title: LocalizationHandler.of().drawer_healthlocker,
              onClick: () {
                _toggleDrawer();
                context
                    .navigatePush(RoutePath.routeHealthLocker, arguments: {});
              },
            ),
            _drawerView(
              icon: ImageLocalAssets.tokenTimerClockIconSvg,
              iconColor: AppColors.colorAppBlue,
              title: LocalizationHandler.of().tokenHistory,
              onClick: () {
                _toggleDrawer();
                context.navigatePush(RoutePath.routeDashboardTokenHistory);
              },
            ),

            _drawerView(
              icon: ImageLocalAssets.languageIcon,
              title: LocalizationHandler.of().drawer_languagechange,
              onClick: () {
                _toggleDrawer();
                context.navigatePush(RoutePath.routeLocalization);
              },
            ),
            _drawerView(
              icon: ImageLocalAssets.share,
              iconColor: AppColors.colorAppBlue,
              title: LocalizationHandler.of().shareAppLink,
              onClick: () {
                _toggleDrawer();
                _onShare();
              },
            ),
            _drawerView(
              icon: ImageLocalAssets.faqIcon,
              title: LocalizationHandler.of().drawer_faq,
              onClick: () {
                _toggleDrawer();
                _launchURLService.openInAppWebView(
                  context,
                  title: LocalizationHandler.of().drawer_faq,
                  url: AbdmUrlConstant.faqUrl,
                );
              },
            ),
            _drawerView(
              icon: ImageLocalAssets.privacyPolicyIconSvg,
              title: LocalizationHandler.of().drawer_privacy_policy,
              onClick: () {
                _toggleDrawer();
                _launchURLService.openInAppWebView(
                  context,
                  title: LocalizationHandler.of()
                      .drawer_privacy_policy
                      .toTitleCase(),
                  url: AbdmUrlConstant.getPrivacyNoticeUrl(),
                );
              },
            ),
            _drawerView(
              icon: ImageLocalAssets.privacyNoticeIcon,
              title: LocalizationHandler.of().drawer_terms_and_condition,
              onClick: () {
                _toggleDrawer();
                _launchURLService.openInAppWebView(
                  context,
                  title: LocalizationHandler.of()
                      .drawer_terms_and_condition
                      .toTitleCase(),
                  url: AbdmUrlConstant.getTermsConditionsUrl(),
                );
              },
            ),

            _drawerView(
              icon: ImageLocalAssets.settingsIcon,
              title: LocalizationHandler.of().drawer_settings,
              onClick: () {
                _toggleDrawer();
                context.navigatePush(RoutePath.routeAccount);
              },
            ),
            _drawerView(
              icon: ImageLocalAssets.aboutUsIconSvg,
              title: LocalizationHandler.of().aboutUs,
              onClick: () {
                _toggleDrawer();
                context.navigatePush(RoutePath.routeAboutUs);
              },
            ),
            // if(!kIsWeb)
            _drawerView(
              icon: ImageLocalAssets.menuContactUsIconSvg,
              title: LocalizationHandler.of().contactUs,
              onClick: () {
                _toggleDrawer();
                context.navigatePush(RoutePath.routeContactUs);
              },
            ),
            _drawerView(
              icon: ImageLocalAssets.logoutIcon,
              title: LocalizationHandler.of().drawer_logout,
              onClick: () {
                Get.find<DashboardController>().showLogoutPopup(context);
              },
            )
          ],
        )
            .paddingSymmetric(horizontal: Dimen.d_10, vertical: Dimen.d_10)
            .marginOnly(bottom: Dimen.d_50),
      ),
    );
  }

  Widget _drawerView({
    required String icon,
    required String title,
    required VoidCallback onClick,
    Color? iconColor,
  }) {
    return Column(
      children: WidgetUtility.spreadWidgets(
        [
          ListTile(
            leading: CustomSvgImageView(
              icon,
              width: Dimen.d_30,
            ),
            textColor: AppColors.colorGreyDark2,
            trailing: const Icon(
              IconAssets.navigateNext,
              color: AppColors.colorGreyDark2,
            ),
            title: Text(title),
            onTap: onClick,
          ),
          const Divider(
            thickness: 1.5,
            color: AppColors.colorGreyLight7,
          )
        ],
        interItemSpace: Dimen.d_4,
        flowHorizontal: false,
      ),
    );
  }

  /// Here is the function to close the drawer
  void _toggleDrawer() async {
    if (scaffoldKey.currentState!.isDrawerOpen) {
      scaffoldKey.currentState!.openEndDrawer();
    } else {}
  }

  /// Here is the function to share the url link of the app according to
  /// platform specific device
  void _onShare() {
    ShareService shareService = ShareServiceImpl();
    String link = '';
    if (Platform.isAndroid) {
      link = StringConstants.androidAppLink;
    } else if (Platform.isIOS) {
      link = StringConstants.iosAppLink;
    } else {
      link = StringConstants.webSharedLink;
    }
    shareService.shareLink(link);
  }
}
