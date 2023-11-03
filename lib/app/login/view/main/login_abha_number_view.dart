import 'package:abha/app/login/view/desktop/login_abha_number_desktop_view.dart';
import 'package:abha/app/login/view/mobile/login_abha_number_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LoginAbhaNumberView extends StatefulWidget {
  const LoginAbhaNumberView({super.key});

  @override
  LoginAbhaNumberViewState createState() => LoginAbhaNumberViewState();
}

class LoginAbhaNumberViewState extends State<LoginAbhaNumberView> {
  late LoginController _loginController;

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  void dispose() {
    _loginController.selectedBirthYear = null;
    _loginController.abhaNumberValue = '';
    _loginController.birthYears = [];
    // _loginController.isAuthModeFetched = false;
    _loginController.isShowEnable = false;
    _loginController.selectedValidationMethod = null;
    super.dispose();
  }

  void init() {
    _loginController = Get.find<LoginController>();
    _loginController.selectedValidationMethod = null;
    _loginController.textAadhaarMobileOtpType = [
      LocalizationHandler.of().aadhaarOtp,
      LocalizationHandler.of().mobileOtp,
    ];

    _loginController.iconsAadhaarMobileOtpType = [
      ImageLocalAssets.loginAdhaarOtpIconOneSvg,
      ImageLocalAssets.loginMobileNoIconSvg,
    ];
    _loginController.birthYears = _loginController.getBirthYears();
    _loginController.update([LoginUpdateUiBuilderIds.abhaNumberValidator]);
  }

  /// This method is used to search for an Abha number and validate it.
  ///
  /// It takes the input from the text fields abhaOneTEC, abhaTwoTEC, abhaThreeTEC, abhaFourTEC, abhaFiveTEC, abhaSixTEC, abhaSevenTEC, abhaEightTEC, abhaNineTEC, abhaTenTEC, abhaElevenTEC and abhaTwelveTEC and combines them into a single string.
  /// The string is then validated using the [Validator.isAbhaNumberValid] method. If it is valid then the [_loginController.getAbbaNumberAuthSearch] method is called with the combined string and _selectedBirthYear as parameters.
  /// If the response status is successful then _isAuthModeFetched is set to true.
  // Future<void> _onAbhaNumberSearch() async {
  //   // _loginController.abhaNumberValue =
  //   //     _loginController.abhaNumberTEC.text.replaceAll('-', '');
  //
  //   if (!Validator.isAbhaNumberValid(_loginController.abhaNumberValue)) {
  //     MessageBar.showToastDialog(LocalizationHandler.of().invalidAbhaNumber);
  //   } else if (Validator.isNullOrEmpty(_loginController.selectedBirthYear)) {
  //     MessageBar.showToastDialog(
  //       LocalizationHandler.of().pleaseSelectBirthYear,
  //     );
  //   } else {
  //     await _loginController.functionHandler(
  //       function: () => _loginController.getAbhaNumberAuthSearch(
  //         _loginController.abhaNumberValue,
  //         _loginController.selectedBirthYear ?? '',
  //       ),
  //       isLoaderReq: true,
  //       isUpdateUi: true,
  //       updateUiBuilderIds: [LoginUpdateUiBuilderIds.abhaNumberValidator],
  //     );
  //     if (_loginController.responseHandler.status == Status.success) {
  //       _loginController.isAuthModeFetched = true;
  //       _loginController.functionHandler(
  //         isUpdateUi: true,
  //         updateUiBuilderIds: [LoginUpdateUiBuilderIds.abhaNumberValidator],
  //       );
  //     }
  //   }
  // }

  /// This method is used to initialize the authentication process for a user with an Abha Number.
  /// It checks if the Abha Number is valid and a validation method has been selected,
  /// then calls the [getAbhaNumberAuthInit from controller] method and navigates
  /// to the [RoutePath.routeLoginOtp] route with the mobile/email as argument.
  ///
  /// @param _abhaNumberValue The Abha Number of the user
  /// @param _selectedValidationMethod The selected validation method for authentication
  /// @returns Future<void>
  Future<void> _onAbhaNumberAuthInit() async {
    _loginController.abhaNumberValue =
        _loginController.abhaNumberTEC.text.trim();
    if (!Validator.isAbhaNumberWithDashValid(
      _loginController.abhaNumberValue,
    )) {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidAbhaNumber);
    } else if (Validator.isNullOrEmpty(
      _loginController.selectedValidationMethod,
    )) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().pleaseSelectValidationType,
      );
    } else {
      await _loginController
          .functionHandler(
        function: () =>
            _loginController.getGenerateOtp(_loginController.abhaNumberValue),
        isLoaderReq: true,
      )
          .whenComplete(() async {
        if (_loginController.responseHandler.status == Status.success) {
          var arguments = {
            IntentConstant.mobileEmail: _loginController.abhaNumberValue,
            IntentConstant.fromScreen: IntentConstant.fromLoginWithAbhaNumberScreen
          };
          _loginController.webAutoValidateMode = AutovalidateMode.disabled;
          await context.navigatePush(
            RoutePath.routeLoginOtp,
            arguments: arguments,
          );
          setState(() {
            _loginController.selectedValidationMethod = null;
            _loginController.isShowEnable = false;
            _loginController.abhaNumberTEC.text = '';
            _loginController.abhaNumberValue = '';
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().loginAbhaNumber,
      type: LoginAbhaNumberView,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: LoginAbhaNumberMobileView(
        onAbhaNumberAuthInit: _onAbhaNumberAuthInit,
      ),
      bodyDesktop: LoginAbhaNumberDesktopView(
        onAbhaNumberAuthInit: _onAbhaNumberAuthInit,
      ),
      paddingValueMobile: Dimen.d_0,
    );
  }
}
