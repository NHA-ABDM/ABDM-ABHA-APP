import 'package:abha/app/app_intro/app_intro_controller.dart';
import 'package:abha/app/app_intro/app_intro_repo.dart';
import 'package:abha/app/app_intro/view/desktop/app_intro_desktop_view.dart';
import 'package:abha/app/app_intro/view/mobile/app_intro_mobile_view.dart';
import 'package:abha/app/app_intro/view/mobile/app_intro_web_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AppIntroView extends StatefulWidget {
  const AppIntroView({super.key});

  @override
  State<AppIntroView> createState() => _AppIntroViewState();
}

class _AppIntroViewState extends State<AppIntroView>
    with WidgetsBindingObserver {
  late AppIntroController appIntroController;

  @override
  void initState() {
    _init();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    DeleteControllers().deleteAppIntro();
    super.dispose();
  }

  void _init() {
    appIntroController = Get.put(AppIntroController(AppIntroRepoImpl()));
    Get.put(LoginController(LoginRepoImpl()));
    Get.put(RegistrationController(RegistrationRepoImpl()));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}

  @override
  Widget build(BuildContext context) {
    return BaseView(
      isAppBar: false,
      paddingValueMobile: Dimen.d_0,
      type: AppIntroView,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile:
          kIsWeb ? const AppIntroWebMobileView() : const AppIntroMobileView(),
      bodyDesktop: const AppIntroDesktopView(),
    );
  }
}
