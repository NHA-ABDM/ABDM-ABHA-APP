import 'package:abha/app/abha_card/view/desktop/abha_card_desktop_view.dart';
import 'package:abha/app/abha_card/view/mobile/abha_card_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AbhaCardView extends StatefulWidget {
  final ProfileModel? profileModel;

  const AbhaCardView({super.key, this.profileModel});

  @override
  AbhaCardViewState createState() => AbhaCardViewState();
}

class AbhaCardViewState extends State<AbhaCardView> {
  late AbhaCardController _abhaCardController;
  InAppWebViewController? inAppWebViewController;

  @override
  void initState() {
    super.initState();
    _abhaCardController = Get.put(AbhaCardController(AbhaCardRepoImpl()));
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _onFetchAbhaCard();
    // });
  }

  @override
  void dispose() {
    // DeleteControllers().deleteAbhaCard();
    super.dispose();
  }

  /// fetch ABHA card by calling [callAbhaCard] metod in controller
  // Future<void> _onFetchAbhaCard() async {
  //   await _abhaCardController.functionHandler(
  //     function: () => _abhaCardController.getAbhaCard(),
  //     isLoaderReq: true,
  //     isUpdateUi: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().abhacard,
      type: AbhaCardView,
      bodyMobile: const AbhaCardMobileView(),
      bodyDesktop: const AbhaCardDesktopView(),
    );
  }
}
