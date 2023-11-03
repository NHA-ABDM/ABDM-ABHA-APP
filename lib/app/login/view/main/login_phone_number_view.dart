import 'package:abha/app/login/view/desktop/login_phone_number_desktop_view.dart';
import 'package:abha/app/login/view/mobile/login_phone_number_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LoginPhoneNumberView extends StatefulWidget {
  const LoginPhoneNumberView({super.key});

  @override
  LoginPhoneNumberViewState createState() => LoginPhoneNumberViewState();
}

class LoginPhoneNumberViewState extends State<LoginPhoneNumberView> {
  late LoginController _loginController;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    _loginController.mobileTextController.clear();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.mobileTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().loginWithMobileNumber.toTitleCase(),
      isTopSafeArea: true,
      isBottomSafeArea: true,
      type: LoginPhoneNumberView,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: LoginPhoneNumberMobileView(
        onMobileLoginInit: _onMobileLoginInit,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: LoginPhoneNumberDesktopView(
        onMobileLoginInit: _onMobileLoginInit,
        isButtonEnable: isButtonEnable,
      ),
    );
  }

  /// @Here call api to authenticate with mobile number.
  /// param [mobileText] gets the value of mobile textfield and passes to api call.
  Future<void> _onMobileLoginInit() async {
    String mobileNumber = _loginController.mobileTextController.text;
    if (Validator.isMobileValid(mobileNumber)) {
      _loginController
          .functionHandler(
        function: () => _loginController.getGenerateOtp(mobileNumber),
        isLoaderReq: true,
      )
          .then((value) {
        if (_loginController.responseHandler.status == Status.success) {
          var arguments = {IntentConstant.mobileEmail: mobileNumber,
            IntentConstant.fromScreen: IntentConstant.fromLoginWithMobileScreen};
          _loginController.mobileTextController.clear();
          isButtonEnable.value = false;
          _loginController.webAutoValidateMode = AutovalidateMode.disabled;
          context.navigatePush(
            RoutePath.routeLoginOtp,
            arguments: arguments,
          );
        }
      });
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidMobile);
    }
  }
}
