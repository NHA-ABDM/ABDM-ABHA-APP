import 'package:abha/app/registration/view/desktop/registration_phone_desktop_view.dart';
import 'package:abha/app/registration/view/mobile/registration_phone_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class RegistrationPhoneView extends StatefulWidget {
  const RegistrationPhoneView({super.key});

  @override
  RegistrationPhoneViewState createState() => RegistrationPhoneViewState();
}

class RegistrationPhoneViewState extends State<RegistrationPhoneView> {
  late RegistrationController _registrationController;
  String mobileNumber = '';
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find();
    _registrationController.mobileTexController.clear();
    _registrationController.mobileTexController.inputFormatters = [
      FilteringTextInputFormatter.allow(RegExp('[0-9]'))
    ];
    if (_registrationController.mobileTexController.text.length == 10) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  @override
  void dispose() {
    _registrationController.mobileTexController.clear();
    super.dispose();
  }

  Future<void> onRegistrationContinueInit() async {
    mobileNumber = _registrationController.mobileTexController.text;
    if (Validator.isMobileValid(mobileNumber)) {
      await _registrationController.functionHandler(
        function: () =>
            _registrationController.getMobileEmailAuthInit(mobileNumber),
        isLoaderReq: true,
      );
      if (_registrationController.responseHandler.status == Status.success) {
        /// navigates to OTP Screen along with data in arguments.
        if (!kIsWeb) {
          _registrationController.mobileTexController.clear();
        }
        isButtonEnable = ValueNotifier(false);
        final arguments = {
          IntentConstant.sentToString: mobileNumber,
          IntentConstant.fromScreen: 'registrationMobile',
        };
        if (!mounted) return;
        await context.navigatePush(
          RoutePath.routeRegistrationOtp,
          arguments: arguments,
        );
        setState(() {
          _registrationController.mobileTexController.text = '';
          _registrationController.autoValidateModeWeb =
              AutovalidateMode.disabled;
        });
      }
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidMobile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().registrationWithMobileNumber,
      type: RegistrationPhoneView,
      mobileBackgroundColor: AppColors.colorWhite,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: RegistrationPhoneMobileView(
        onRegistrationContinueInit: onRegistrationContinueInit,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: RegistrationPhoneDesktopView(
        onRegistrationContinueInit: onRegistrationContinueInit,
        isButtonEnable: isButtonEnable,
      ),
      height: 0.20,
    );
  }
}
