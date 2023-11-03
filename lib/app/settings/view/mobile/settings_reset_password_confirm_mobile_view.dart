import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class SettingsResetPasswordConfirmMobileView extends StatefulWidget {
  const SettingsResetPasswordConfirmMobileView({super.key});

  @override
  SettingsResetPasswordConfirmMobileViewState createState() =>
      SettingsResetPasswordConfirmMobileViewState();
}

class SettingsResetPasswordConfirmMobileViewState
    extends State<SettingsResetPasswordConfirmMobileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _settingsResetPasswordResultWidget();
  }

  /// @Here is the _settingsResetPasswordResultWidget() used to show the message that
  /// the password has been successfully changed and navigate to the home screen on click of
  /// button. This method returns the [Column] widget having children [Text] and [TextButtonOrange].
  Widget _settingsResetPasswordResultWidget() {
    return Column(
      children: [
        CustomSvgImageView(
          ImageLocalAssets.successfulTickIconSvg,
          width: Dimen.d_90,
          height: Dimen.d_90,
        ).marginOnly(top: Dimen.d_20),
        Text(
          LocalizationHandler.of().congratulations,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorGreenDark2,
            fontWeightDelta: 2,
            fontSizeDelta: 2,
          ),
        ).marginOnly(top: Dimen.d_18),
        Text(
          '${LocalizationHandler.of().password_changed_successfully} ',
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6, fontSizeDelta: 2,
            // fontWeightDelta: 2,
          ),
        ).paddingOnly(top: Dimen.d_10),
        if (kIsWeb)
          SizedBox(
            height: Dimen.d_20,
          )
        else
          const Expanded(child: SizedBox()),
        TextButtonOrange.mobile(
          text: LocalizationHandler.of().go_to_settings,
          onPressed: () {
            /// Navigate to the Home Screen i:e Dashboard screen
            context.navigateBack();
          },
        ).centerWidget.marginOnly(top: Dimen.d_50, bottom: Dimen.d_25),
      ],
    );
  }
}
