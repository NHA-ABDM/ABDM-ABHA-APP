import 'package:abha/app/settings/view/desktop/settings_reset_password_confirm_desktop_view.dart';
import 'package:abha/app/settings/view/desktop/settings_reset_password_desktop_view.dart';
import 'package:abha/app/settings/view/mobile/settings_reset_password_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class SettingsResetPasswordView extends StatefulWidget {
  const SettingsResetPasswordView({super.key});

  @override
  SettingsResetPasswordViewState createState() =>
      SettingsResetPasswordViewState();
}

class SettingsResetPasswordViewState extends State<SettingsResetPasswordView> {
  late SettingsController _settingsController;

  @override
  void initState() {
    Get.put(SettingsController(SettingsRepoImpl()));
    _settingsController = Get.find<SettingsController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// @Here is the method onAbhaFormSubmission() Used to call the, Api Calling method
  /// callUpdatePassword() define into the Controller. This method is passed to the property
  /// [function] and set boolean true to property [isLoaderReq]
  /// param is use [passwordText] of type String
  Future<void> onAbhaFormSubmission(String passwordText) async {
    _settingsController
        .functionHandler(
      function: () => _settingsController.callUpdatePassword(passwordText),
      isLoaderReq: true,
    )
        .then((value) {
      /// if response status is success
      if (_settingsController.responseHandler.status == Status.success) {
        /// Navigate to Result Password Reset Screen
        if (kIsWeb) {
          context
              .openDialog(
                const CustomSimpleDialog(
                  size: 10,
                  child: SettingsResetPasswordConfirmDesktopView(),
                ),
              )
              .then((value) => context.navigateBack());
        } else {
          context.navigatePushReplacement(
            RoutePath.routeSettingsResetPasswordResult,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().setting_reset_password.toTitleCase(),
      type: SettingsResetPasswordView,
      bodyMobile: SettingsResetPasswordMobileView(
        onAbhaFormSubmission: onAbhaFormSubmission,
      ),
      bodyDesktop: SettingsResetPasswordDesktopView(
        onAbhaFormSubmission: onAbhaFormSubmission,
      ),
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
    );
  }
}
