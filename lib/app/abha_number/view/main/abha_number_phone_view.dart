import 'package:abha/app/abha_number/view/desktop/abha_number_phone_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/abha_number_phone_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberPhoneView extends StatefulWidget {
  const AbhaNumberPhoneView({super.key});

  @override
  AbhaNumberPhoneViewState createState() => AbhaNumberPhoneViewState();
}

class AbhaNumberPhoneViewState extends State<AbhaNumberPhoneView> {
  final AbhaNumberController _abhaNumberController = Get.find();
  String _mobileNumber = '';
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Future<void> _getFacilityLoginAuth() async{
  //   _mobileNumber = _abhaNumberController.mobileTextController.text;
  //   _abhaNumberController.mobileNumber =_mobileNumber;
  //   if (Validator.isMobileValid(_mobileNumber)) {
  //     await _abhaNumberController.functionHandler(
  //       function: () => _abhaNumberController.getFacilityLogin(),
  //       isLoaderReq: true,
  //     );
  //     if (_abhaNumberController.responseHandler.status == Status.success) {
  //       _verifyFaceAuth();
  //     }
  //   } else {
  //     MessageBar.showToastDialog(LocalizationHandler.of().invalidMobile);
  //   }
  // }

  Future<void> _verifyFaceAuth() async {
    _mobileNumber = _abhaNumberController.mobileTextController.text;
    _abhaNumberController.mobileNumber = _mobileNumber;
    if (Validator.isMobileValid(_mobileNumber)) {
      _abhaNumberController
          .functionHandler(
        function: () => _abhaNumberController.getCardByFaceAuth(),
        isLoaderReq: true,
      )
          .whenComplete(() {
        if (_abhaNumberController.responseHandler.status == Status.success) {
          _getAbhaCard();
        }
      });
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidMobile);
    }
  }

  Future<void> _getAbhaCard() async {
    await _abhaNumberController
        .functionHandler(
      function: () => _abhaNumberController.getAbhaCard(),
      isLoaderReq: true,
      isUpdateUi: true,
    )
        .then((value) {
      _abhaNumberController.mobileTextController.clear();
      isButtonEnable = ValueNotifier(false);
      context.navigatePush(RoutePath.routeAbhaNumberCard);
    });
  }

  // Future<void> _addMobile() async {
  //   _mobileNumber = _abhaNumberController.mobileTextController.text;
  //   if (Validator.isMobileValid(_mobileNumber)) {
  //     await _abhaNumberController.functionHandler(
  //       function: () => _abhaNumberController.addMobile(_mobileNumber),
  //       isLoaderReq: true,
  //     );
  //     if (_abhaNumberController.responseHandler.status == Status.success) {
  //       _createAbhaId();
  //     }
  //   } else {
  //     MessageBar.showToastDialog(LocalizationHandler.of().invalidMobile);
  //   }
  // }
  //
  // /// This function is used to create an Abha ID. It uses the [_abhaNumberController] to call
  // /// the [createAbhaId()] function, and sets the [isLoaderReq] parameter to true.
  // /// If the response status is successful, it will navigate to the [RoutePath.routeAbhaNumberCard] page.
  // Future<void> _createAbhaId() async {
  //   _abhaNumberController
  //       .functionHandler(
  //     function: () => _abhaNumberController.createAbhaId(),
  //     isLoaderReq: true,
  //   )
  //       .then((_) {
  //     if (_abhaNumberController.responseHandler.status == Status.success) {
  //       context.navigatePush(RoutePath.routeAbhaNumberCard);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().createAbhaNumber,
      type: AbhaNumberPhoneView,
      paddingValueMobile: Dimen.d_0,
      webBackgroundColor: AppColors.colorBlueLight8,
      bodyMobile: AbhaNumberPhoneMobileView(
        verifyFaceAuth: _verifyFaceAuth,
      ),
      bodyDesktop: AbhaNumberPhoneDesktopView(
        verifyFaceAuth: _verifyFaceAuth,
      ),
      mobileBackgroundColor: AppColors.colorWhite,
    );
  }
}
