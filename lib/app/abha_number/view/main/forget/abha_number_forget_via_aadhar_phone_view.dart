import 'package:abha/app/abha_number/view/desktop/forget_desktop/abha_number_forget_via_aadhar_phone_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/forget_mobile/abha_number_forget_via_aadhar_phone_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberForgetViaAadharPhoneView extends StatefulWidget {
  final Map arguments;
  const AbhaNumberForgetViaAadharPhoneView({
    required this.arguments,
    super.key,
  });

  @override
  AbhaNumberForgetViaAadharPhoneViewState createState() =>
      AbhaNumberForgetViaAadharPhoneViewState();
}

class AbhaNumberForgetViaAadharPhoneViewState
    extends State<AbhaNumberForgetViaAadharPhoneView> {
  late AbhaNumberController _abhaNumberController;
  String _aadhaarNumber = '';
  String _authType = '';

  @override
  void initState() {
    _abhaNumberController = Get.find<AbhaNumberController>();
    initData();
    super.initState();
  }

  @override
  void dispose() {
    _abhaNumberController.aadhaarNumberTextController.clear();
    _abhaNumberController.mobileNumberTextController.clear();
    _abhaNumberController.aadhaarDecelerationCheckBox = false;
    _abhaNumberController.isButtonEnable = ValueNotifier(false);
    super.dispose();
  }

  void initData() {
    _authType = widget.arguments[IntentConstant.sourceType].toString();
    abhaLog.e(_authType);
  }

  void _isAadhaarValid() {
    _aadhaarNumber = _abhaNumberController.aadhaarNumberTextController.text
        .replaceAll('-', '');
    if (!Validator.isAadhaarValid(_aadhaarNumber)) {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidAadhaarNumber);
    } else if (!_abhaNumberController.aadhaarDecelerationCheckBox) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().userInformationAgreementError,
      );
    } else {
      _abhaNumberController.aadhaarNumber = _aadhaarNumber;
      _generateAadhaarOtp();
    }
  }

  void _generateAadhaarOtp() {
    _abhaNumberController
        .functionHandler(
      function: () => _abhaNumberController.generateOtpViaAadhaar(),
      isLoaderReq: true,
    )
        .then((_) {
      if (_abhaNumberController.responseHandler.status == Status.success) {
        _abhaNumberController.aadhaarNumberTextController.clear();
        _abhaNumberController.isButtonEnable = ValueNotifier(false);
        _abhaNumberController.aadhaarDecelerationCheckBox = false;
        var argument = {IntentConstant.sourceType: _authType};
        context.navigatePush(
          RoutePath.routeAbhaNumberForgetOtp,
          arguments: argument,
        );
      }
    });
  }

  void _isTermsConditionCheckForMobile() {
    if (!_abhaNumberController.aadhaarDecelerationCheckBox) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().userInformationAgreementError,
      );
    } else {
      _generateMobileOtp();
    }
  }

  void _generateMobileOtp() {
    _abhaNumberController
        .functionHandler(
      function: () => _abhaNumberController.generateOtpViaMobile(),
      isLoaderReq: true,
    )
        .then((_) {
      if (_abhaNumberController.responseHandler.status == Status.success) {
        _abhaNumberController.mobileNumberTextController.clear();
        _abhaNumberController.isButtonEnable = ValueNotifier(false);
        _abhaNumberController.aadhaarDecelerationCheckBox = false;
        var argument = {IntentConstant.sourceType: _authType};
        context.navigatePush(
          RoutePath.routeAbhaNumberForgetOtp,
          arguments: argument,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: AbhaNumberForgetViaAadharPhoneView,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      title: LocalizationHandler.of().titleForgotAbhaNumber,
      bodyMobile: AbhaNumberForgetAadhaarPhoneMobileView(
        isAadhaarValid: _isAadhaarValid,
        isTermsConditionCheckForMobile: _isTermsConditionCheckForMobile,
        authType: _authType,
        abhaNumberController: _abhaNumberController,
      ),
      bodyDesktop: AbhaNumberForgetAadhaarPhoneDesktopView(
        isAadhaarValid: _isAadhaarValid,
        isTermsConditionCheckForMobile: _isTermsConditionCheckForMobile,
        authType: _authType,
        abhaNumberController: _abhaNumberController,
      ),
    );
  }
}
