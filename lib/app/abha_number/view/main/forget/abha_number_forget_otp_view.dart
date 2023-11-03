import 'package:abha/app/abha_number/view/desktop/forget_desktop/abha_number_forget_otp_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/forget_mobile/abha_number_forget_otp_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberForgetOtpView extends StatefulWidget {
  final Map arguments;
  const AbhaNumberForgetOtpView({required this.arguments, super.key});

  @override
  AbhaNumberForgetOtpViewState createState() => AbhaNumberForgetOtpViewState();
}

class AbhaNumberForgetOtpViewState extends State<AbhaNumberForgetOtpView> {
  late AbhaNumberController _abhaNumberController;
  String _otpValue = '';
  String _authType = '';
  late Timer _timer;

  @override
  void initState() {
    _abhaNumberController = Get.find<AbhaNumberController>();
    _authType = widget.arguments[IntentConstant.sourceType].toString();
    _startOtpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _abhaNumberController.otpTextController.clear();
    _abhaNumberController.isButtonEnable = ValueNotifier(false);
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    _otpValue = _abhaNumberController.otpTextController.text;
    if (Validator.isOtpValid(_otpValue)) {
      _abhaNumberController
          .functionHandler(
        function: () => _abhaNumberController.verifyAadhaarOrMobileOtp(
          _otpValue,
          _authType,
        ),
        isLoaderReq: true,
      )
          .then((_) {
        if (_abhaNumberController.responseHandler.status == Status.success) {
          var message =
              'Please enter a valid OTP. Entered OTP is either expired or incorrect.';
          if (_abhaNumberController.responseHandler
              .toString()
              .contains(message)) {
            MessageBar.showToastDialog(
              LocalizationHandler.of().abhaNumberInvalidOtp,
            );
          } else {
            _abhaNumberController.otpTextController.clear();
            _abhaNumberController.isButtonEnable = ValueNotifier(false);
            navigateToCardView();
          }
        }
      });
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
    }
  }

  void navigateToCardView() {
    context.navigatePush(RoutePath.routeAbhaNumberForgotCardDetail);
  }

  Future<void> _reGenerateOtp() async {
    await _abhaNumberController.functionHandler(
      function: () => _authType == AbhaNumberForgotOptionEnum.aadhaarNumber.name
          ? _abhaNumberController.generateOtpViaAadhaar()
          : _abhaNumberController.generateOtpViaMobile(),
      isLoaderReq: true,
    );
    if (_abhaNumberController.responseHandler.status == Status.success) {
      _abhaNumberController.otpTextController.text = '';
      _timer.cancel();
      _startOtpTimer();
    }
  }

  void _startOtpTimer() {
    _abhaNumberController.functionHandler(
      function: () => _abhaNumberController.otpTimerInit(),
      isUpdateUi: true,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _abhaNumberController.functionHandler(
        function: () => _abhaNumberController.otpTimerCountDown(),
        isUpdateUi: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: AbhaNumberForgetOtpView,
      title: LocalizationHandler.of().titleForgotAbhaNumber,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: AbhaNumberForgetOtpMobileView(
        abhaNumberController: _abhaNumberController,
        verifyOtp: _verifyOtp,
        reGenerateOtp: _reGenerateOtp,
      ),
      bodyDesktop: AbhaNumberForgetOtpDesktopView(
        abhaNumberController: _abhaNumberController,
        verifyOtp: _verifyOtp,
        reGenerateOtp: _reGenerateOtp,
      ),
    );
  }
}
