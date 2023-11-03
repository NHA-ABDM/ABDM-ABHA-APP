import 'package:abha/app/login/view/desktop/login_email_desktop_view.dart';
import 'package:abha/app/login/view/mobile/login_email_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LoginEmailView extends StatefulWidget {
  const LoginEmailView({super.key});

  @override
  LoginEmailViewState createState() => LoginEmailViewState();
}

class LoginEmailViewState extends State<LoginEmailView> {
  late LoginController _loginController;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    _loginController.emailTextController.clear();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.emailTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().loginEmailId.toTitleCase(),
      type: LoginEmailView,
      mobileBackgroundColor: AppColors.colorWhite,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: LoginEmailMobileView(
        onEmailLoginInit: onEmailLoginInit,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: LoginEmailDesktopView(
        onEmailLoginInit: onEmailLoginInit,
        isButtonEnable: isButtonEnable,
      ),
    );
  }

  /// This method is used to initiate the email login process.
  ///
  /// It checks if the email entered is valid and then calls the [getMobileEmailAuthInit] method of [_loginController] to initiate the process.
  /// If successful, it navigates to the [RoutePath.routeLoginOtp] route with [emailText] as an argument.
  /// Otherwise, it shows a toast message with [LocalizationHandler.of().invalidEmail].
  ///
  /// @param _emailTEC The TextEditingController for the email field.
  /// @param context The BuildContext of the current widget.
  Future<void> onEmailLoginInit() async {
    final emailText = _loginController.emailTextController.text;
    if (Validator.isEmailValid(emailText)) {
      _loginController
          .functionHandler(
        function: () => _loginController.getGenerateOtp(emailText),
        isLoaderReq: true,
      )
          .then((value) {
        if (_loginController.responseHandler.status == Status.success) {
          /// TO-IMPLEMENT: make it proper at backend
          if (_loginController.tempResponseData
                  .containsKey(ApiKeys.responseKeys.authResult) &&
              _loginController.tempResponseData[ApiKeys.responseKeys.authResult]
                  .toString()
                  .contains('failed')) {
            String message =
                _loginController.tempResponseData[ApiKeys.responseKeys.message];
            if (message.toLowerCase().contains('email address not found')) {
              message = LocalizationHandler.of().emailNotFound;
            } else {
              message = LocalizationHandler.of().somethingWrong;
            }
            MessageBar.showToastDialog(message);
          } else {
            var arguments = {IntentConstant.mobileEmail: emailText,
              IntentConstant.fromScreen: IntentConstant.fromLoginWithEmailScreen};
            _loginController.emailTextController.clear();
            isButtonEnable.value = false;
            _loginController.webAutoValidateMode = AutovalidateMode.disabled;
            context.navigatePush(
              RoutePath.routeLoginOtp,
              arguments: arguments,
            );
          }
        }
      });
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidEmail);
    }
  }
}
