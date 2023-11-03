import 'package:abha/app/registration/view/desktop/registration_email_desktop_view.dart';
import 'package:abha/app/registration/view/mobile/registration_email_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class RegistrationEmailView extends StatefulWidget {
  const RegistrationEmailView({super.key});

  @override
  RegistrationEmailViewState createState() => RegistrationEmailViewState();
}

class RegistrationEmailViewState extends State<RegistrationEmailView> {
  late RegistrationController _registrationController;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    _registrationController = Get.find();
    _registrationController.emailTextController.clear();
    if (_registrationController.emailTextController.text.isNotEmpty) {
      isButtonEnable.value = true;
    } else {
      isButtonEnable.value = false;
    }
    super.initState();
  }

  @override
  void dispose() {
    _registrationController.emailTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      paddingValueMobile: Dimen.d_0,
      title: LocalizationHandler.of().registrationWithEmail.toTitleCase(),
      type: RegistrationEmailView,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: RegistrationEmailMobileView(
        onRegistrationContinueInit: onRegistrationContinueInit,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: RegistrationEmailDesktopView(
        onRegistrationContinueInit: onRegistrationContinueInit,
        isButtonEnable: isButtonEnable,
      ),
      height: 0.20,
    );
  }

  Future<void> onRegistrationContinueInit() async {
    final emailText = _registrationController.emailTextController.text;
    if (Validator.isEmailValid(emailText)) {
      await _registrationController.functionHandler(
        function: () =>
            _registrationController.getMobileEmailAuthInit(emailText),
        isLoaderReq: true,
      );
      if (_registrationController.responseHandler.status == Status.success) {
        if (!kIsWeb) {
          _registrationController.emailTextController.clear();
        }
        isButtonEnable = ValueNotifier(false);
        final arguments = {
          IntentConstant.sentToString: emailText,
          IntentConstant.fromScreen: 'registrationEmail',
        };
        if (!mounted) return;
        await context.navigatePush(
          RoutePath.routeRegistrationOtp,
          arguments: arguments,
        );

        setState(() {
          _registrationController.emailTextController.text = '';
          _registrationController.autoValidateModeWeb =
              AutovalidateMode.disabled;
        });
      }
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidEmail);
    }
  }
}
