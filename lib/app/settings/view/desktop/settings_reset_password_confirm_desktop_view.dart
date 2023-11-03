import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class SettingsResetPasswordConfirmDesktopView extends StatefulWidget {
  const SettingsResetPasswordConfirmDesktopView({super.key});

  @override
  SettingsResetPasswordConfirmDesktopViewState createState() =>
      SettingsResetPasswordConfirmDesktopViewState();
}

class SettingsResetPasswordConfirmDesktopViewState
    extends State<SettingsResetPasswordConfirmDesktopView> {
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
      mainAxisAlignment:
          kIsWeb ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        CustomSvgImageView(
          ImageLocalAssets.successfulTickIconSvg,
          width: Dimen.d_50,
          height: Dimen.d_50,
        ),
        Text(
          LocalizationHandler.of().congratulations,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorGreenDark2,
            fontWeightDelta: 2,
          ),
        ).marginOnly(top: Dimen.d_18),
        Text(
          '${LocalizationHandler.of().password_changed_successfully} ',
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6,
            fontWeightDelta: 2,
          ),
        ).paddingOnly(top: Dimen.d_10),
        TextButtonOrange.desktop(
          text: LocalizationHandler.of().done,
          onPressed: () {
            /// Navigate to the Home Screen i:e Dashboard screen
            context.navigateBack();
          },
        )
            .sizedBox(width: context.width * 0.2)
            .centerWidget
            .marginOnly(top: Dimen.d_20, bottom: Dimen.d_20),
      ],
    ).marginSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20);
  }
}
