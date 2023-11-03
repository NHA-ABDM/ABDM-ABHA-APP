import 'package:abha/app/login/view/desktop/login_desktop_phone_size_view.dart';
import 'package:abha/app/login/view/desktop/login_desktop_view.dart';
import 'package:abha/export_packages.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: LoginView,
      mobileBackgroundColor: AppColors.colorBlueLight8,
      bodyMobile: const LoginDesktopPhoneSizeView(),
      bodyDesktop: const LoginDesktopView(),
      paddingValueMobile: Dimen.d_0,
    );
  }
}
