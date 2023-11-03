import 'package:abha/app/settings/view/desktop/settings_reset_password_confirm_desktop_view.dart';
import 'package:abha/app/settings/view/mobile/settings_reset_password_confirm_mobile_view.dart';
import 'package:abha/export_packages.dart';

class SettingsResetPasswordConfirmView extends StatelessWidget {
  const SettingsResetPasswordConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().setting_reset_password.toTitleCase(),
      isCenterTitle: false,
      type: SettingsResetPasswordConfirmView,
      bodyMobile: const SettingsResetPasswordConfirmMobileView(),
      bodyDesktop: const SettingsResetPasswordConfirmDesktopView(),
    );
  }
}
