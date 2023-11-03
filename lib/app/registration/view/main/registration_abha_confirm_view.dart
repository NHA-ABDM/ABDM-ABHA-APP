import 'package:abha/app/registration/view/desktop/registration_abha_confirm_desktop_view.dart';
import 'package:abha/app/registration/view/mobile/registration_abha_confirm_mobile_view.dart';
import 'package:abha/export_packages.dart';

class RegistrationAbhaConfirmView extends StatefulWidget {
  final Map arguments;

  const RegistrationAbhaConfirmView({required this.arguments, super.key});

  @override
  RegistrationAbhaConfirmViewState createState() =>
      RegistrationAbhaConfirmViewState();
}

class RegistrationAbhaConfirmViewState
    extends State<RegistrationAbhaConfirmView> {
  late RegistrationController _registrationController;
  late String _fromScreenString;
  String _screenTitle = '';
  late bool _isDarkTabBar = false;

  @override
  void initState() {
    super.initState();
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    _registrationController = Get.put<RegistrationController>(
      RegistrationController(RegistrationRepoImpl()),
    );
    _registrationController = Get.find<RegistrationController>();
    _registrationController.abhaAddressSelectedValue = null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// This method is used to handle the mobile email login confirm action.
  /// It checks if the [_abhaAddressSelectedValue] is null or empty. If it is, then a toast message is shown.
  /// Else, it creates a [formObject] and calls the [_registrationController] to get the login from registration Abha with the [formObject].
  /// If the response status is success, then it sets the shared preference to true and navigates to dashboard page with arguments of abha address.
  void _onMobileEmailLoginConfirm() async {
    if (Validator.isNullOrEmpty(
      _registrationController.abhaAddressSelectedValue?.abhaAddress,
    )) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().pleaseSelectAbhaAddress,
      );
    } else {
      await _registrationController
          .functionHandler(
        function: () => _registrationController.getLoginFromRegistrationAbha(),
        isLoaderReq: true,
      )
          .then((_) {
        if (_registrationController.responseHandler.status == Status.success) {
          abhaSingleton.getSharedPref.setLogin().whenComplete(() {
            var arguments = {
              IntentConstant.abhaAddress: _registrationController
                      .abhaAddressSelectedValue?.abhaAddress ??
                  ''
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

  void initScreenTitleText() {
    if (_fromScreenString == 'registrationEmail') {
      _isDarkTabBar = false;
      _screenTitle =
          LocalizationHandler.of().registrationWithEmail.toTitleCase();
    } else if (_fromScreenString == 'registrationMobile') {
      _isDarkTabBar = false;
      _screenTitle =
          LocalizationHandler.of().registrationWithMobileNumber.toTitleCase();
    } else if (_fromScreenString == 'registrationAbha') {
      _isDarkTabBar = true;
      _screenTitle = LocalizationHandler.of().registrationWithABHANUmber;
    }
  }

  @override
  Widget build(BuildContext context) {
    initScreenTitleText();
    return BaseView(
      isDarkTabBar: _isDarkTabBar,
      mobileBackgroundColor: AppColors.colorWhite,
      title: _screenTitle,
      type: RegistrationAbhaConfirmView,
      bodyMobile: RegistrationAbhaConfirmMobileView(
        arguments: widget.arguments,
        onMobileEmailLoginConfirm: _onMobileEmailLoginConfirm,
      ),
      bodyDesktop: RegistrationAbhaConfirmDesktopView(
        arguments: widget.arguments,
        onMobileEmailLoginConfirm: _onMobileEmailLoginConfirm,
      ),
      paddingValueMobile: Dimen.d_0,
      height: 0.30,
    );
  }
}
