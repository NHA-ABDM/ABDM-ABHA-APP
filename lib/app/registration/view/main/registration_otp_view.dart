import 'package:abha/app/registration/view/desktop/registration_otp_desktop_view.dart';
import 'package:abha/app/registration/view/mobile/registration_otp_mobile_view.dart';
import 'package:abha/export_packages.dart';

class RegistrationOtpView extends StatefulWidget {
  final Map arguments;

  const RegistrationOtpView({required this.arguments, super.key});

  @override
  RegistrationOtpViewState createState() => RegistrationOtpViewState();
}

class RegistrationOtpViewState extends State<RegistrationOtpView> {
  late RegistrationController _registrationController;
  String _otpValue = '';
  late String _data;
  String _screenTitle = '';
  late String _fromScreenString;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    _data = widget.arguments[IntentConstant.sentToString];
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    _registrationController = Get.find<RegistrationController>();
    _registrationController.otpTextController.clear();
    _startOtpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _resetOtpFlow();
    super.dispose();
  }

  /// TO-IMPLEMENT: error will show in logcat
  void _resetOtpFlow() {
    _registrationController.timer.cancel();
    _registrationController.otpTextController.clear();
  }

  /// @Here function call the api and resend the otp on users device.
  void _onResendOtp() async {
    if (_registrationController.isResendOtpEnabled) {
      _registrationController.otpTextController.text = '';
      await _registrationController.functionHandler(
        function: () => _registrationController.getResendOtp(_data),
        isLoaderReq: true,
      );
      if (_registrationController.responseHandler.status == Status.success) {
        _resetOtpFlow();
        _startOtpTimer();
      }
    }
  }

  /// @Here start the timer
  void _startOtpTimer() {
    _registrationController.functionHandler(
      function: () => _registrationController.otpTimerInit(),
      isUpdateUi: true,
    );
    _registrationController.timer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      _registrationController.functionHandler(
        function: () => _registrationController.otpTimerCountDown(),
        isUpdateUi: true,
      );
    });
  }

  /// @Here function verifies the entered otp on textfield.
  /// Otp value is verified by calling api by passing the entered otp value.
  Future<void> onOtpVerify() async {
    _otpValue = _registrationController.otpTextController.text;
    if (Validator.isOtpValid(_otpValue)) {
      await _registrationController.functionHandler(
        function: () => _registrationController.checkVerifyOtp(
          _otpValue,
          _fromScreenString,
        ),
        isLoaderReq: true,
      );
      if (_registrationController.responseHandler.status == Status.success) {
        /// TO-IMPLEMENT: make it proper at backend
        if (_registrationController.tempResponseData
                .containsKey(ApiKeys.responseKeys.authResult) &&
            _registrationController
                .tempResponseData[ApiKeys.responseKeys.authResult]
                .toString()
                .contains('failed')) {
          String message = _registrationController
              .tempResponseData[ApiKeys.responseKeys.message];
          if (message.toString().contains(
                    'Entered OTP is incorrect. Kindly re-enter valid OTP.',
                  ) ||
              message.toString().contains(
                    'Please enter a valid OTP',
                  )) {
            MessageBar.showToastDialog(
              LocalizationHandler.of().invalidOTP,
              onPositiveButtonPressed: () {
                _registrationController.otpTextController.text = '';
              },
            );
          } else if (message.toString().toLowerCase().contains('otp expired')) {
            MessageBar.showToastDialog(
              LocalizationHandler.of().otpExpired,
              onPositiveButtonPressed: () {
                _registrationController.otpTextController.text = '';
              },
            );
          }
        } else {
          abhaSingleton.getApiProvider
              .addTHeaderToken(_registrationController.tempResponseData);
          navigate();
        }
      }
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
    }
  }

  /// @Here is the function to navigate to Registration form
  void navigate() {
    Map data = _registrationController.responseHandler.data;
    if (data.isNotEmpty) {
      List<ProfileModel> mappedPhrAddress = [];
      for (Map<String, dynamic> jsonMap in data[ApiKeys.responseKeys.users]) {
        mappedPhrAddress.add(ProfileModel.fromMappedUserMap(jsonMap));
      }

      /// IF Mapped Addresses are found navigate to
      /// Registration Abha confirm Screen along with data in arguments.
      if (!Validator.isNullOrEmpty(mappedPhrAddress)) {
        var arguments = {
          IntentConstant.mappedPhrAddress: mappedPhrAddress,
          IntentConstant.data: data,
          IntentConstant.fromScreen: _fromScreenString,
          IntentConstant.sentToString: _data,
        };

        /// Adding below lines as we have to clear ABHA number view selections
        _registrationController.registrationMethod = null;
        _registrationController.selectedValidationMethod = null;

        context.navigatePushReplacement(
          RoutePath.routeRegistrationAbhaConfirm,
          arguments: arguments,
        );
      } else {
        ///If no mapped addresses are found and
        ///came from screen Registration Abha Number
        if (_fromScreenString == 'registrationAbha') {
          var arguments = {
            IntentConstant.mappedPhrAddress: mappedPhrAddress,
            IntentConstant.data: data,
            IntentConstant.fromScreen: _fromScreenString,
            IntentConstant.sentToString: _data,
          };
          context.navigatePushReplacement(
            RoutePath.routeRegistrationAbhaConfirm,
            arguments: arguments,
          );
        } else {
          ///came from Registration Email or Mobile screen
          var arguments = {
            IntentConstant.fromScreen: _fromScreenString,
            IntentConstant.sentToString: _data,
          };
          context.navigatePushReplacement(
            RoutePath.routeRegistrationForm,
            arguments: arguments,
          );
        }
      }
    }
  }

  /// @Here function used to set the different titles as registration type selected.
  void initScreenTitleText() {
    if (_fromScreenString == 'registrationEmail') {
      _screenTitle =
          LocalizationHandler.of().registrationWithEmail.toTitleCase();
    } else if (_fromScreenString == 'registrationMobile') {
      _screenTitle =
          LocalizationHandler.of().registrationWithMobileNumber.toTitleCase();
    } else if (_fromScreenString == 'registrationAbha') {
      _screenTitle = LocalizationHandler.of().registrationWithABHANUmber;
    }
  }

  @override
  Widget build(BuildContext context) {
    initScreenTitleText();
    return BaseView(
      title: _screenTitle,
      type: RegistrationOtpView,
      mobileBackgroundColor: AppColors.colorWhite,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: RegistrationOtpMobileView(
        arguments: widget.arguments,
        onResendOtp: _onResendOtp,
        onOtpVerify: onOtpVerify,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: RegistrationOtpDesktopView(
        arguments: widget.arguments,
        onResendOtp: _onResendOtp,
        onOtpVerify: onOtpVerify,
        isButtonEnable: isButtonEnable,
      ),
    );
  }
}
