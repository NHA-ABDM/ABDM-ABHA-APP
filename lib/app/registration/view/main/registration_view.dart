import 'package:abha/app/registration/view/desktop/registration_desktop_phone_size_view.dart';
import 'package:abha/app/registration/view/desktop/registration_desktop_view.dart';
import 'package:abha/export_packages.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: RegistrationView,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorBlueLight8,
      bodyMobile: const RegistrationDesktopPhoneSizeView(),
      bodyDesktop: const RegistrationDesktopView(),
      height: 0.20,
    );
  }
}
