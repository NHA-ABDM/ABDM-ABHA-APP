import 'package:abha/app/login/view/desktop/login_confirm_desktop_view.dart';
import 'package:abha/app/login/view/mobile/login_confirm_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LoginConfirmView extends StatefulWidget {
  final Map arguments;

  const LoginConfirmView({
    required this.arguments,
    super.key,
  });

  @override
  LoginConfirmViewState createState() => LoginConfirmViewState();
}

class LoginConfirmViewState extends State<LoginConfirmView> {
  late LoginController _loginController;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    _loginController = Get.put(LoginController(LoginRepoImpl()));
    _loginController = Get.find<LoginController>();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.abhaAddressSelectedValue = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().confirm,
      type: LoginConfirmView,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: LoginConfirmMobileView(
        arguments: widget.arguments,
        onMobileEmailLoginConfirm: _onMobileEmailLoginConfirm,
      ),
      bodyDesktop: LoginConfirmDesktopView(
        arguments: widget.arguments,
        onMobileEmailLoginConfirm: _onMobileEmailLoginConfirm,
        isButtonEnable: isButtonEnable,
      ),
      paddingValueMobile: Dimen.d_0,
    );
  }

  /// This method is used to confirm the mobile email login.
  /// It checks if the Abha address is selected or not,
  /// if not then it shows a toast message.
  /// If selected, it calls the below function
  /// and sets the [SharedPref.isLogin] to true and navigates to [RoutePath.routeDashboard].
  ///
  /// @param _abhaAddressSelectedValue The value of Abha address selected by user.
  /// @returns Future<void>
  Future<void> _onMobileEmailLoginConfirm() async {
    if (Validator.isNullOrEmpty(_loginController.abhaAddressSelectedValue)) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().pleaseSelectAbhaAddress,
      );
    } else {
      await _loginController
          .functionHandler(
        function: () => _loginController.getUserVerify(
          _loginController.abhaAddressSelectedValue!,
        ),
        isLoaderReq: true,
      )
          .whenComplete(() async {
        if (_loginController.responseHandler.status == Status.success) {
          abhaSingleton.getSharedPref.setLogin().whenComplete(() {
            var arguments = {
              IntentConstant.abhaAddress:
                  _loginController.abhaAddressSelectedValue
            };
            context.navigateGo(
              RoutePath.routeDashboard,
              arguments: arguments,
            );
          });
        }
      });
    }
  }
}
