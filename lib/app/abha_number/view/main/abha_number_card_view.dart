import 'package:abha/app/abha_number/view/desktop/abha_number_card_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/abha_number_card_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberCardView extends StatefulWidget {
  const AbhaNumberCardView({super.key});

  @override
  AbhaNumberCardViewState createState() => AbhaNumberCardViewState();
}

class AbhaNumberCardViewState extends State<AbhaNumberCardView> {
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
    return WillPopScope(
      onWillPop: () async {
        if (abhaSingleton.getAppData.getLogin()) {
          context.navigateGo(RoutePath.routeDashboard);
        } else {
          context.navigateGo(RoutePath.routeAppIntro);
        }
        return false;
      },
      child: BaseView(
        title: LocalizationHandler.of().createAbhaNumber,
        type: AbhaNumberCardView,
        bodyMobile: const AbhaNumberCardMobileView(),
        bodyDesktop: const AbhaNumberCardDesktopView(),
        paddingValueMobile: Dimen.d_0,
        mobileBackgroundColor: AppColors.colorWhite,
      ),
    );
  }
}
