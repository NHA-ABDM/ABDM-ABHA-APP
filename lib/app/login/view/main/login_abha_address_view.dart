import 'package:abha/app/login/view/desktop/login_abha_address_desktop_view.dart';
import 'package:abha/app/login/view/mobile/login_abha_address_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LoginAbhaAddressView extends StatefulWidget {
  const LoginAbhaAddressView({super.key});

  @override
  LoginAbhaAddressViewState createState() => LoginAbhaAddressViewState();
}

class LoginAbhaAddressViewState extends State<LoginAbhaAddressView> {
  late LoginController _loginController;
  Map configData = abhaSingleton.getAppConfig.getConfigData();
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);
  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    _loginController.selectedABHAValidationMethod =
        ABHAValidationMethod.password;
    _loginController.selectedValidationMethod = null;
    _loginController.abhaAddressTEC.text = '';
    _loginController.abhaPasswordTEC.text = '';
    if (!Validator.isNullOrEmpty(_loginController.abhaAddressTEC.text)) {
      isButtonEnable.value = true;
    }
    super.initState();
  }

  @override
  void dispose() {
    _loginController.abhaAddressTEC.clear();
    _loginController.abhaPasswordTEC.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      mobileBackgroundColor: AppColors.colorWhite,
      title: LocalizationHandler.of().loginAbhaAddress,
      type: LoginAbhaAddressView,
      bodyMobile: LoginAbhaAddressMobileView(
        onAbhaAddressLogin: onAbhaAddressLogin,
        onAbhaAddressEmailMobileOtpLogin: onAbhaAddressEmailMobileOtpLogin,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: LoginAbhaAddressDesktopView(
        onAbhaAddressLogin: onAbhaAddressLogin,
        onAbhaAddressEmailMobileOtpLogin: onAbhaAddressEmailMobileOtpLogin,
        isButtonEnable: isButtonEnable,
      ),
      paddingValueMobile: Dimen.d_0,
    );
  }

  /// This method is used to login with Abha Address.
  /// It takes two parameters [abhaAddress] and [abhaPass] which are the abha address and password respectively.
  /// It checks if the [abhaAddress] and [abhaPass] are valid or not, if not then it shows an error message.
  /// If valid, then it calls the function `getAbhaAddressAuthInit` from _loginController and sets `isLogin` to true in shared preferences.
  /// After that, it navigates to the dashboard page with arguments containing the abha address.
  Future<void> onAbhaAddressLogin() async {
    final String abhaAddress =
        _loginController.abhaAddressTEC.text.toLowerCase();
    final String abhaPass = _loginController.abhaPasswordTEC.text;
    if (Validator.isNullOrEmpty(abhaAddress) ||
        Validator.isNullOrEmpty(abhaPass) ||
        !Validator.isPassValid(abhaPass)) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().invalidAbhaAddressPass,
      );
    } else {
      String abhaAddressValue =
          '${abhaAddress.trim()}${configData[AppConfig.abhaAddressSuffix]}';
      _loginController
          .functionHandler(
        function: () => _loginController.getAbhaAddressAuthInit(
          abhaAddressValue,
          abhaPass,
        ),
        isLoaderReq: true,
      )
          .whenComplete(() async {
        if (_loginController.responseHandler.status == Status.success) {
          /// TO-IMPLEMENT: make it proper at backend
          if (_loginController.tempResponseData
                  .containsKey(ApiKeys.responseKeys.authResult) &&
              _loginController.tempResponseData[ApiKeys.responseKeys.authResult]
                  .toString()
                  .contains('failed')) {
            String message =
                _loginController.tempResponseData[ApiKeys.responseKeys.message];
            if (message.toLowerCase().contains('password did not match')) {
              message = LocalizationHandler.of().abhaAddressPasswordNotMatch;
            } else {
              message = LocalizationHandler.of().somethingWrong;
            }
            MessageBar.showToastDialog(message);
          } else {
            abhaSingleton.getSharedPref.setLogin().whenComplete(() {
              var arguments = {IntentConstant.abhaAddress: abhaAddressValue};
              context.navigateGo(
                RoutePath.routeDashboard,
                arguments: arguments,
              );
            });
          }
        }
      });
    }
  }

  /// This method is used to perform Abha Address Email Mobile OTP Login.
  ///
  /// It checks if the Abha Address and Validation Method are valid or not, and then calls the getGenerateOtp method of LoginController to get the OTP.
  /// If the response is successful, it navigates to [RouteName.routeLoginOtp] route with Abha Address as an argument.
  Future<void> onAbhaAddressEmailMobileOtpLogin() async {
    final String abhaAddress =
        _loginController.abhaAddressTEC.text.toLowerCase();
    if (Validator.isNullOrEmpty(abhaAddress) ||
        Validator.isNullOrEmpty(_loginController.selectedValidationMethod)) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().invalidAbhaAddressPass,
      );
    } else {
      String abhaAddressValue =
          '${abhaAddress.trim()}${configData[AppConfig.abhaAddressSuffix]}';
      _loginController
          .functionHandler(
        function: () => _loginController.getGenerateOtp(abhaAddressValue),
        isLoaderReq: true,
      )
          .then((value) async {
        if (_loginController.responseHandler.status == Status.success) {
          var arguments = {IntentConstant.abhaAddress: abhaAddressValue,
            IntentConstant.fromScreen: IntentConstant.fromLoginWithAbhaAddressScreen};
          _loginController.webAutoValidateMode = AutovalidateMode.disabled;
          await context.navigatePush(
            RoutePath.routeLoginOtp,
            arguments: arguments,
          );

          setState(() {
            _loginController.selectedABHAValidationMethod =
                ABHAValidationMethod.password;
            // _loginController.selectedValidationMethod = null;
            _loginController.abhaAddressTEC.text = '';
            _loginController.abhaPasswordTEC.text = '';
            isButtonEnable.value = false;
          });
        }
      });
    }
  }
}
