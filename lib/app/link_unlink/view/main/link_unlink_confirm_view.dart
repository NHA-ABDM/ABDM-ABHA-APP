import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/app/link_unlink/view/desktop/link_unlink_confirm_desktop_view.dart';
import 'package:abha/app/link_unlink/view/mobile/link_unlink_confirm_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LinkUnlinkConfirmView extends StatefulWidget {
  const LinkUnlinkConfirmView({super.key});

  @override
  LinkUnlinkConfirmViewState createState() => LinkUnlinkConfirmViewState();
}

class LinkUnlinkConfirmViewState extends State<LinkUnlinkConfirmView> {
  late LinkUnlinkController _linkUnlinkController;
  late ProfileController _profileController;
  String actionType = LocalizationHandler.of().linkUnlinkConfirmPageMsg_1;
  late DashboardController _dashboardController;

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() {
    _linkUnlinkController = Get.find<LinkUnlinkController>();
    _dashboardController = Get.find<DashboardController>();
    _profileController = Get.find<ProfileController>();
    String aType = _linkUnlinkController.actionType ?? '';
    if (aType.toLowerCase().contains(StringConstants.deLink.toLowerCase())) {
      //actionType = LocalizationHandler.of().linkUnlinkConfirmPageMsg_2;
    }
    _fetchProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchProfile() {
    _profileController
        .functionHandler(
      function: () => _profileController.getProfileFetch(),
      isUpdateUi: true,
    )
        .then((_) {
      _onFetchXAuthToken();
    });
  }

  void _onFetchXAuthToken() async {
    _dashboardController
        .functionHandler(
          function: () => _dashboardController.getXAuthToken(_profileController.profileModel),
          isLoaderReq: true,
          isShowError: false,
        )
        .whenComplete(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: _linkUnlinkController.actionType?.toLowerCase() == StringConstants.deLink.toLowerCase() ? LocalizationHandler.of().unlinkAbhaNumber : LocalizationHandler.of().linkAbhaNumber,
      type: LinkUnlinkConfirmView,
      bodyMobile: LinkUnlinkConfirmMobileView(
        linkUnlinkController: _linkUnlinkController,
      ),
      bodyDesktop: LinkUnlinkConfirmDesktopView(
        linkUnlinkController: _linkUnlinkController,
      ),
    );
  }
}
