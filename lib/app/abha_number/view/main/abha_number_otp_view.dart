import 'package:abha/app/abha_number/view/desktop/abha_number_otp_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/abha_number_otp_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberOtpView extends StatefulWidget {
  const AbhaNumberOtpView({super.key});

  @override
  AbhaNumberOtpViewState createState() => AbhaNumberOtpViewState();
}

class AbhaNumberOtpViewState extends State<AbhaNumberOtpView> {
  final AbhaNumberController _abhaNumberController = Get.find();
  String _otpValue = '';
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);
  late Timer _timer;
  @override
  void initState() {
    _startOtpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _abhaNumberController.otpTextController.clear();
    _abhaNumberController.mobileTextController.clear();
    isButtonEnable = ValueNotifier(false);
    super.dispose();
  }

  /// This method is used to verify the OTP entered by the user.
  /// It takes in the OTP value from the text fields and checks if it is valid using the [Validator.isOtpValid] method.
  /// If valid, it calls [_abhaNumberController._verifyOtp] with the OTP value and sets the response status to success.
  /// If unsuccessful, a toast message is displayed with [MessageBar.showToast] and [LocalizationHandler.of().invalidOtp].

  Future<void> _reGenerateOtp() async {
    await _abhaNumberController.functionHandler(
      function: () => _abhaNumberController.genAbhaNumberCreateOtp(),
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

  Future<void> _verifyOtp() async {
    _otpValue = _abhaNumberController.otpTextController.text;
    if (Validator.isOtpValid(_otpValue)) {
      _abhaNumberController
          .functionHandler(
        function: () => _abhaNumberController.verifyOtp(_otpValue),
        isLoaderReq: true,
      )
          .then((_) {
        if (_abhaNumberController.responseHandler.status == Status.success) {
          _getAbhaCard();
        }
      });
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
    }
  }

  /// This method is used to get the Abha Card associated with the user.
  /// It requires a [_abhaNumberController] to be passed in, which is used to call the [_abhaNumberController.getAbhaCard()] function.
  /// The [isLoaderReq] and [isUpdateUi] parameters are also required, and are used to determine whether or not a loading screen should be displayed and if the UI should be updated respectively.
  /// The return type of this method is a Future<void>.
  Future<void> _getAbhaCard() async {
    await _abhaNumberController
        .functionHandler(
      function: () => _abhaNumberController.getAbhaCard(),
      isLoaderReq: true,
      isUpdateUi: true,
    )
        .then((value) {
      _abhaNumberController.otpTextController.clear();
      _abhaNumberController.mobileTextController.clear();
      isButtonEnable = ValueNotifier(false);
      context.navigatePushReplacement(RoutePath.routeAbhaNumberCard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().createAbhaNumber,
      type: AbhaNumberOtpView,
      paddingValueMobile: Dimen.d_0,
      webBackgroundColor: AppColors.colorBlueLight8,
      bodyMobile: AbhaNumberOtpMobileView(
        verifyOtp: _verifyOtp,
        resendOtp: _reGenerateOtp,
      ),
      bodyDesktop: AbhaNumberOtpDesktopView(
        verifyOtp: _verifyOtp,
        resendOtp: _reGenerateOtp,
      ),
      mobileBackgroundColor: AppColors.colorWhite,
    );
  }
}
