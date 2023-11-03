import 'package:abha/app/registration/view/desktop/registration_abha_number_desktop_view.dart';
import 'package:abha/app/registration/view/mobile/registration_abha_number_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class RegistrationAbhaNumberView extends StatefulWidget {
  const RegistrationAbhaNumberView({super.key});

  @override
  RegistrationAbhaNumberViewState createState() =>
      RegistrationAbhaNumberViewState();
}

class RegistrationAbhaNumberViewState
    extends State<RegistrationAbhaNumberView> {
  late RegistrationController _registrationController;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  String _abhaNumberValue = '';

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find<RegistrationController>();
    _registrationController.abhaNumberTextController.text = '';
    _registrationController.registrationMethod = null;
    _registrationController.selectedValidationMethod = null;
    _registrationController.autoValidateModeWeb = AutovalidateMode.disabled;
    if (_registrationController.abhaNumberTextController.text.isNotEmpty) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
  }

  @override
  void dispose() {
    _registrationController.selectedValidationMethod = null;
    _registrationController.registrationMethod = null;
    _registrationController.abhaNumberTextController.clear();
    super.dispose();
  }

  Future<void> onRegistrationContinueInit() async {
    _abhaNumberValue = _registrationController.abhaNumberTextController.text;
    if (!Validator.isAbhaNumberWithDashValid(_abhaNumberValue)) {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidAbhaNumber);
    } else if (Validator.isNullOrEmpty(
      _registrationController.selectedValidationMethod,
    )) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().pleaseSelectValidationType,
      );
    } else {
      await _registrationController
          .functionHandler(
        function: () =>
            _registrationController.getAbhaRequestOtp(_abhaNumberValue),
        isLoaderReq: true,
      )
          .then((value) async {
        if (_registrationController.responseHandler.status == Status.success) {
          if (!kIsWeb) {
            _registrationController.abhaNumberTextController.text = '';
          }
          isButtonEnable.value = false;
          final arguments = {
            IntentConstant.sentToString: _abhaNumberValue,
            IntentConstant.fromScreen: 'registrationAbha',
          };
          if (!mounted) return;
          await context.navigatePush(
            RoutePath.routeRegistrationOtp,
            arguments: arguments,
          );
          setState(() {
            _registrationController.abhaNumberTextController.text = '';
            _registrationController.registrationMethod = null;
            _registrationController.selectedValidationMethod = null;
            _registrationController.autoValidateModeWeb =
                AutovalidateMode.disabled;
          });
        }
      });
    }
  }

  void _checkOnValidationTypeClick(RegistrationMethod value) {
    _registrationController.registrationMethod = value;
    _registrationController.selectedValidationMethod = value;
    _registrationController
        .update([RegistrationUpdateUiBuilderIds.abhaNumberValidator]);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().registrationWithABHANUmber,
      type: RegistrationAbhaNumberView,
      mobileBackgroundColor: AppColors.colorWhite,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: RegistrationAbhaNumberMobileView(
        onRegistrationContinueInit: onRegistrationContinueInit,
        checkOnValidationTypeClick: _checkOnValidationTypeClick,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: RegistrationAbhaNumberDesktopView(
        onRegistrationContinueInit: onRegistrationContinueInit,
        checkOnValidationTypeClick: _checkOnValidationTypeClick,
        isButtonEnable: isButtonEnable,
      ),
    );
  }
}
