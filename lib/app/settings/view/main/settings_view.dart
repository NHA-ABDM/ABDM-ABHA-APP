import 'package:abha/app/settings/view/desktop/settings_desktop_view.dart';
import 'package:abha/app/settings/view/mobile/settings_mobile_view.dart';
import 'package:abha/export_packages.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    Get.put(SettingsController(SettingsRepoImpl()));
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteSettings();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().setting,
      type: SettingsView,
      bodyMobile: const SettingsMobileView(),
      bodyDesktop: const SettingsDesktopView(),
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      height: 0.50,
    );
  }
}
