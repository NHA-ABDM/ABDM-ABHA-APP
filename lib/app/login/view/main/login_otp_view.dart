import 'package:abha/app/login/view/desktop/login_otp_desktop_view.dart';
import 'package:abha/app/login/view/mobile/login_otp_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LoginOtpView extends StatefulWidget {
  final Map arguments;

  const LoginOtpView({required this.arguments, super.key});

  @override
  LoginOtpViewState createState() => LoginOtpViewState();
}

class LoginOtpViewState extends State<LoginOtpView> {
  late LoginController _loginController;
  late LoginMethod _previousLoginMethod;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);
  String? _userData;
  String _otpValue = '';

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    _previousLoginMethod = _loginController.loginMethod;
    _loginController.otpTextController.clear();
    _handleData();
    _startOtpTimer();
    super.initState();
  }

  void _handleData() {
    if (widget.arguments.containsKey(IntentConstant.abhaAddress)) {
      _userData = widget.arguments[IntentConstant.abhaAddress];
      Map configData = abhaSingleton.getAppConfig.getConfigData();
      _userData = '${_userData?.trim()}${configData[AppConfig.abhaAddressSuffix]}';
    } else if (widget.arguments.containsKey(IntentConstant.mobileEmail)) {
      _userData = widget.arguments[IntentConstant.mobileEmail];
    }
  }

  /// @Here start the timer
  void _startOtpTimer() {
    _loginController.functionHandler(
      function: () => _loginController.otpTimerInit(),
      isUpdateUi: true,
    );
    _loginController.otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _loginController.functionHandler(
        function: () => _loginController.otpTimerCountDown(),
        isUpdateUi: true,
        isLoaderReq: true,
      );
    });
  }

  @override
  void dispose() {
    _loginController.otpTimer.cancel();
    _loginController.otpTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().otpVerification,
      type: LoginOtpView,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: LoginOtpMobileView(
        arguments: widget.arguments,
        onResendOtp: _onResendOtp,
        onOtpVerify: onOtpVerify,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: LoginOtpDesktopView(
        arguments: widget.arguments,
        onResendOtp: _onResendOtp,
        onOtpVerify: onOtpVerify,
        isButtonEnable: isButtonEnable,
      ),
      paddingValueMobile: Dimen.d_0,
    );
  }

  /// @Here function call the api and resend the otp on users device.
  void _onResendOtp() async {
    if (_loginController.isResendOtpEnabled) {
      String data = '';
      if (widget.arguments.containsKey(IntentConstant.abhaAddress)) {
        data = widget.arguments[IntentConstant.abhaAddress];
        Map configData = abhaSingleton.getAppConfig.getConfigData();
        data = '${data.trim()}${configData[AppConfig.abhaAddressSuffix]}';
      } else if (widget.arguments.containsKey(IntentConstant.mobileEmail)) {
        data = widget.arguments[IntentConstant.mobileEmail];
      }
      await _loginController.functionHandler(
        function: () => _loginController.getGenerateOtp(data),
        isLoaderReq: true,
      );
      if (_loginController.responseHandler.status == Status.success) {
        _loginController.otpTimer.cancel();
        _loginController.otpTextController.text = '';
        _startOtpTimer();
      }
    }
  }

  /// @Here function verifies the entered otp on textfield.
  /// Otp value is verified by calling api by passing the entered otp value.
  Future<void> onOtpVerify() async {
    _otpValue = _loginController.otpTextController.text;
    if (Validator.isOtpValid(_otpValue)) {
      await _loginController.functionHandler(
        function: () => _loginController.getVerify(_otpValue, abhaAddress: _userData),
        isLoaderReq: true,
        isUpdateUi: true,
      );
      if (_loginController.responseHandler.status == Status.success) {
        /// TO-IMPLEMENT: make it proper at backend
        if (_loginController.tempResponseData.containsKey(ApiKeys.responseKeys.authResult) && _loginController.tempResponseData[ApiKeys.responseKeys.authResult].toString().contains('failed')) {
          String message = _loginController.tempResponseData[ApiKeys.responseKeys.message];
          if (message.toLowerCase().contains('otp expired, please try again')) {
            message = LocalizationHandler.of().otpExpired;
          } else if (message.toLowerCase().contains('otp is either expired or incorrect')) {
            message = LocalizationHandler.of().invalidOrExpiredOtp;
          } else if (message.toLowerCase().contains('otp did not match')) {
            message = LocalizationHandler.of().invalidOrExpiredOtp;
          } else if (message.toLowerCase().contains('entered otp is incorrect')) {
            message = LocalizationHandler.of().invalidOrExpiredOtp;
          } else {
            message = LocalizationHandler.of().somethingWrong;
          }
          MessageBar.showToastDialog(
            message,
            onPositiveButtonPressed: () {
              _loginController.otpTextController.text = '';
            },
          );
        } else {
          isButtonEnable.value = false;
          abhaSingleton.getApiProvider.addTHeaderToken(_loginController.tempResponseData);
          String abhaAddress = widget.arguments[IntentConstant.abhaAddress] ?? '';

          /// Below code will clear the abha number value and selection
          _loginController.selectedValidationMethod = null;
          _loginController.isShowEnable = false;
          _loginController.abhaNumberTEC.text = '';
          _loginController.abhaNumberValue = '';

          if (!Validator.isNullOrEmpty(abhaAddress)) {
            // _onMobileEmailLoginConfirm(abhaAddress);
            abhaSingleton.getApiProvider.addXHeaderToken(_loginController.tempResponseData);
            navigateToDashboardView(abhaAddress);
          } else {
            // List<Map<String, dynamic>> users = _loginController.responseHandler.data[[ApiKeys.responseKeys.users]];
            // if (!Validator.isNullOrEmpty(_loginController.responseHandler.data[[ApiKeys.responseKeys.users]])) {
              navigateToConfirmView();
            // } else {
            //   MessageBar.showToastDialog('No mapped ABHA address found. Please create ABHA Address first', onPositiveButtonPressed: (){
            //     CustomDialog.dismissDialog();
            //   });
            // }
          }
        }
      }
      if (_loginController.responseHandler.status == Status.error) {
        _loginController.loginMethod = _previousLoginMethod;
      }
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
    }
  }

  Future<void> _onMobileEmailLoginConfirm(String abhaAddress) async {
    _loginController
        .functionHandler(
      function: () => _loginController.getUserVerify(abhaAddress),
      isLoaderReq: true,
    )
        .whenComplete(() async {
      if (_loginController.responseHandler.status == Status.success) {
        navigateToDashboardView(abhaAddress);
      }
    });
  }

  void navigateToDashboardView(String abhaAddress) {
    abhaSingleton.getSharedPref.setLogin().whenComplete(() {
      var arguments = {IntentConstant.abhaAddress: abhaAddress};
      context.navigateGo(
        RoutePath.routeDashboard,
        arguments: arguments,
      );
    });
  }

  /// @Here navigate to next Confirm Screen.
  void navigateToConfirmView() {
    Map data = _loginController.responseHandler.data;
    if (data.isNotEmpty) {
      /// TO-IMPLEMENT: For testing purpose saving users list so that we can use it to show on switch profile screen
      abhaSingleton.getSharedPref.set(SharedPref.userLists, jsonEncode(data[ApiKeys.responseKeys.users]));
      List<ProfileModel> mappedPhrAddress = [];
      for (Map<String, dynamic> jsonMap in data[ApiKeys.responseKeys.users]) {
        mappedPhrAddress.add(ProfileModel.fromMappedUserMap(jsonMap));
      }
      final arguments = {IntentConstant.mappedPhrAddress: mappedPhrAddress};
      context.navigatePushReplacement(
        RoutePath.routeLoginConfirm,
        arguments: arguments,
      );
    }
  }
}
