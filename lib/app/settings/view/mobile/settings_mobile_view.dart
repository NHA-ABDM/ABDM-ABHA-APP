import 'package:abha/export_packages.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';
import 'package:flutter/foundation.dart';

class SettingsMobileView extends StatefulWidget {
  const SettingsMobileView({super.key});

  @override
  SettingsMobileViewState createState() => SettingsMobileViewState();
}

class SettingsMobileViewState extends State<SettingsMobileView> {
  /// instance variable of SettingsController
  late SettingsController _settingsController;

  @override
  void initState() {
    _settingsController = Get.find<SettingsController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _settingsWidget();
  }

  /// @Here is the _settingsWidget() widget returns the [ListView] widget contains the
  /// [ListTile] widget as a children widget. ListView widget consist of property [padding],
  /// [child] have [ListTile.divideTile] widget contains the grey color into [color] property.
  /// Further more [tiles] have multiple [ListTile] widget.
  Widget _settingsWidget() {
    return ListView(
      shrinkWrap: true,
      children: ListTile.divideTiles(
        color: AppColors.colorGrey,
        tiles: [
          ListTile(
            title: Text(
              LocalizationHandler.of().setting_reset_password,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 1,
                fontSizeDelta: 1,
              ),
            ).marginOnly(left: Dimen.d_10),
            onTap: () {
              /// Navigate to Reset Password Screen
              context.navigatePush(
                RoutePath.routeSettingsResetPassword,
              );
            },
          ).paddingOnly(top: Dimen.d_10, bottom: Dimen.d_10),
          ListTile(
            title: Text(
              LocalizationHandler.of().setting_submit_feeback,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 1,
                fontSizeDelta: 1,
              ),
            ).marginOnly(left: Dimen.d_10),
            onTap: () {
              context.navigatePush(
                RoutePath.routeSubmitFeedback,
              );
            },
          ).paddingOnly(top: Dimen.d_10, bottom: Dimen.d_10),

          ListTile(
            title: Text(
              LocalizationHandler.of().grievancePortal,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 1,
                fontSizeDelta: 1,
              ),
            ).marginOnly(left: Dimen.d_10),
            onTap: () {
              LaunchURLServiceImpl().openInAppWebView(
                context,
                title: LocalizationHandler.of().grievancePortal.toTitleCase(),
                url: AbdmUrlConstant.getGrievancePortal(),
              );
            },
          ).paddingOnly(top: Dimen.d_10, bottom: Dimen.d_10),

          /// TO-IMPLEMENT: uncomment afterword
          // ListTile(
          //   title: RichText(
          //     text: TextSpan(
          //       style: CustomTextStyle.bodyText2(context)
          //           ?.apply(fontSizeDelta: 1, fontWeightDelta: 1),
          //       children: <TextSpan>[
          //         TextSpan(
          //           text:
          //               '${LocalizationHandler.of().setting_deactivate_delete} \n',
          //           style: CustomTextStyle.bodyText2(context)?.apply(
          //             color: AppColors.colorAppBlue,
          //             fontSizeDelta: 1,
          //             fontWeightDelta: 1,
          //           ),
          //         ),
          //         TextSpan(
          //           text: '(${LocalizationHandler.of().comingSoon})',
          //           style: CustomTextStyle.bodyText2(context)?.apply(
          //             color: AppColors.colorRed,
          //             fontSizeDelta: 1,
          //             fontWeightDelta: 1,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ).marginOnly(left: Dimen.d_10),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // )
          //     .paddingOnly(top: Dimen.d_10,bottom: Dimen.d_10),
          // ListTile(
          //   title: RichText(
          //     text: TextSpan(
          //       style: CustomTextStyle.bodyText2(context)?.apply(),
          //       children: <TextSpan>[
          //         TextSpan(
          //           text:
          //               '${LocalizationHandler.of().setting_reactivate_abha} \n',
          //           style: CustomTextStyle.bodyText2(context)?.apply(
          //             color: AppColors.colorAppBlue,
          //             fontSizeDelta: 1,
          //             fontWeightDelta: 1,
          //           ),
          //         ),
          //         TextSpan(
          //           text: '(${LocalizationHandler.of().comingSoon})',
          //           style: CustomTextStyle.bodyText2(context)?.apply(
          //             color: AppColors.colorRed,
          //             fontSizeDelta: 1,
          //             fontWeightDelta: 1,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ).marginOnly(left: Dimen.d_10),
          //   onTap: () {
          //     // Update the state of the app.
          //     // ...
          //   },
          // )
          //     .paddingOnly(top: Dimen.d_10,bottom: Dimen.d_10),

          ListTile(
            title: Text(
              LocalizationHandler.of().setting_notification,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 1,
                fontSizeDelta: 1,
              ),
            ).marginOnly(left: Dimen.d_10),
            onTap: () {
              /// Navigate to Notification Screen
              context.navigatePush(
                RoutePath.routeNotification,
              );
            },
          ).paddingOnly(top: Dimen.d_10, bottom: Dimen.d_10),
          ListTile(
            title: Text(
              LocalizationHandler.of().setting_create_abha_number,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 1,
                fontSizeDelta: 1,
              ),
            ).marginOnly(left: Dimen.d_10),
            onTap: () {
              kIsWeb
                  ? CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context)
                  : context.navigatePush(RoutePath.routeAbhaNumber);
              // ------create using webview-----------------------------------------
            },
          ).paddingOnly(top: Dimen.d_10, bottom: Dimen.d_10),
        ],
      ).toList(),
    );
  }
}
