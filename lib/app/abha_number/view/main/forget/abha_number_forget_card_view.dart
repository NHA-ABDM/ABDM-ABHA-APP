import 'package:abha/app/abha_number/view/desktop/forget_desktop/abha_number_forget_card_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/forget_mobile/abha_number_forget_card_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberForgetCardView extends StatefulWidget {
  const AbhaNumberForgetCardView({super.key});

  @override
  AbhaNumberForgotOtpPhoneState createState() =>
      AbhaNumberForgotOtpPhoneState();
}

class AbhaNumberForgotOtpPhoneState extends State<AbhaNumberForgetCardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.navigateGo(RoutePath.routeAppIntro);
        return false;
      },
      child: BaseView(
        type: AbhaNumberForgetCardView,
        title: LocalizationHandler.of().titleForgotAbhaNumber,
        mobileBackgroundColor: AppColors.colorWhite,
        bodyMobile: const AbhaNumberForgetCardMobileView(),
        bodyDesktop: const AbhaNumberForgetCardDesktopView(),
      ),
    );
  }
}
