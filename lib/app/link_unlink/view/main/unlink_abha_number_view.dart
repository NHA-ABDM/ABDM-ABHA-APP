import 'package:abha/app/link_unlink/view/desktop/unlink_abha_number_desktop_view.dart';
import 'package:abha/app/link_unlink/view/mobile/unlink_abha_number_mobile_view.dart';
import 'package:abha/export_packages.dart';

class UnLinkAbhaNumberView extends StatefulWidget {
  const UnLinkAbhaNumberView({super.key});

  @override
  UnLinkAbhaNumberViewState createState() => UnLinkAbhaNumberViewState();
}

class UnLinkAbhaNumberViewState extends State<UnLinkAbhaNumberView> {
  late LinkUnlinkController _linkUnlinkController;
  final borderDecoration = abhaSingleton.getBorderDecoration;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(true);

  @override
  void initState() {
    _linkUnlinkController = Get.put(LinkUnlinkController(LinkUnlinkRepoImpl()));
    _linkUnlinkController.actionType = StringConstants.deLink;
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteLinkUnlink();
    super.dispose();
  }

  /// @Here is the function updates the UI,
  /// according to selection of authentication modes for otp.
  ///
  /// Param [value] is assign to another variable [_selectedValidationMethod]
  void _checkOnValidationTypeClick(value) {
    _linkUnlinkController.selectedValidationMethod = value;
    isButtonEnable.value = true;
    _linkUnlinkController.update([LinkUnlinkUpdateUiBuilderIds.radioToggle]);
  }

  /// @Here function used to search the auth modes of Abha number by calling the api.
  void _onAbhaNumberSearch() async {
    if (_linkUnlinkController.selectedValidationMethod.toLowerCase() ==
        StringConstants.no.toLowerCase()) {
      context.navigateBack();
    } else {
      // _linkUnlinkController
      //     .functionHandler(
      //   function: () => _linkUnlinkController.getAbhaNumberAuthSearch(
      //     abhaSingleton.getAppData.getAbhaNumber(),
      //     StringConstants.deLink,
      //   ),
      //   isLoaderReq: true,
      // )
      //     .whenComplete(() {
      //   if (_linkUnlinkController.responseHandler.status == Status.success) {
      //     context
      //         .navigatePush(
      //           RoutePath.routeUnlinkAbhaNumberValidator,
      //         )
      //         .whenComplete(() => context.navigateBack());
      //   }
      // });
      context
          .navigatePush(RoutePath.routeUnlinkAbhaNumberValidator)
          .whenComplete(() => context.navigateBack());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().unlinkAbhaNumber,
      type: UnLinkAbhaNumberView,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: UnLinkAbhaNumberMobileView(
        checkOnValidationTypeClick: _checkOnValidationTypeClick,
        onAbhaNumberSearch: _onAbhaNumberSearch,
        linkUnlinkController: _linkUnlinkController,
      ),
      bodyDesktop: UnLinkAbhaNumberDesktopView(
        checkOnValidationTypeClick: _checkOnValidationTypeClick,
        onAbhaNumberSearch: _onAbhaNumberSearch,
        linkUnlinkController: _linkUnlinkController,
        isButtonEnable: isButtonEnable,
      ),
    );
  }
}
