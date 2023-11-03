import 'package:abha/app/abha_number/view/desktop/forget_desktop/abha_number_forget_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/forget_mobile/abha_number_forget_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberForgetView extends StatefulWidget {
  const AbhaNumberForgetView({
    super.key,
  });

  @override
  AbhaNumberForgetViewState createState() => AbhaNumberForgetViewState();
}

class AbhaNumberForgetViewState extends State<AbhaNumberForgetView> {
  late AbhaNumberController _abhaNumberController;
  @override
  void initState() {
    _abhaNumberController = Get.put(AbhaNumberController(AbhaNumberRepoImpl()));
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteAbhaNumber();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: AbhaNumberForgetView,
      title: LocalizationHandler.of().titleForgotAbhaNumber,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: AbhaNumberForgetMobileView(
        abhaNumberController: _abhaNumberController,
      ),
      bodyDesktop: AbhaNumberForgetDesktopView(
        abhaNumberController: _abhaNumberController,
      ),
    );
  }
}
