import 'package:abha/export_packages.dart';

class LoginOtpDesktopView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onResendOtp;
  final VoidCallback onOtpVerify;
  final ValueNotifier<bool> isButtonEnable;

  const LoginOtpDesktopView({
    required this.arguments,
    required this.onResendOtp,
    required this.onOtpVerify,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginOtpDesktopViewState createState() => LoginOtpDesktopViewState();
}

class LoginOtpDesktopViewState extends State<LoginOtpDesktopView> {
  late LoginController _loginController;

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// @Here function used to set the different titles as registration type selected.
  String initScreenTitleText() {
    String fromScreenString = widget.arguments[IntentConstant.fromScreen];
    if (fromScreenString == IntentConstant.fromLoginWithMobileScreen) {
      return LocalizationHandler.of().loginWithMobileNumber.toTitleCase();
    }
    if (fromScreenString == IntentConstant.fromLoginWithAbhaAddressScreen) {
      return LocalizationHandler.of().loginAbhaAddress;
    }
    if (fromScreenString == IntentConstant.fromLoginWithAbhaNumberScreen) {
      return LocalizationHandler.of().loginAbhaNumber;
    }
    if (fromScreenString == IntentConstant.fromLoginWithEmailScreen) {
      return LocalizationHandler.of().loginEmailId.toTitleCase();
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.otpImage,
      title: initScreenTitleText(),
      child: _otpWidget(),
    );
  }

  Widget _otpWidget() {
    return Column(
      children: [
        Text(
          !Validator.isNullOrEmpty(
            widget.arguments[IntentConstant.abhaAddress],
          )
              ? LocalizationHandler.of().enterSixDigitOTP
              : _loginController.loginMethod == LoginMethod.verifyAadhaar
                  ? LocalizationHandler.of().sentOTPOnAbhaNumberWithAadhaar
                  : _loginController.loginMethod == LoginMethod.verifyMobile
                      ? LocalizationHandler.of().sentOTPOnAbhaNumberWithMobile
                      : _loginController.loginMethod == LoginMethod.mobile
                          ? '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskingNumber(widget.arguments[IntentConstant.mobileEmail])}'
                          : _loginController.loginMethod == LoginMethod.email
                              ? '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskEmail(widget.arguments[IntentConstant.mobileEmail])}'
                              : _loginController.loginMethod ==
                                      LoginMethod.verifyAbhaMobileOtp
                                  ? LocalizationHandler.of()
                                      .sentOTPOnAbhaNumberWithMobile
                                  : '',
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6,
            fontSizeDelta: -2,
          ),
        ).alignAtTopLeft(),
        AutoFocusTextView(
          textEditingController: _loginController.otpTextController,
          errorController: _loginController.errorController,
          fieldOuterPadding: EdgeInsets.only(right: Dimen.d_12),
          mainAxisAlignment: MainAxisAlignment.start,
          length: 6,
          width: Dimen.d_50,
          height: Dimen.d_50,
          onCompleted: (value) {},
          onChanged: (String value) {
            if (mounted) {
              if (!Validator.isNullOrEmpty(value) && value.length == 6) {
                widget.isButtonEnable.value = true;
              } else {
                widget.isButtonEnable.value = false;
              }
            }
          },
        ).alignAtCenter().marginOnly(top: Dimen.d_4),
        GetBuilder<LoginController>(
          builder: (_) => Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!_loginController.isResendOtpEnabled)
                //   Container()
                // else
                Text(
                  '${LocalizationHandler.of().resendOtpIn}'
                  '${_loginController.otpCountDown} ${LocalizationHandler.of().sec}',
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack4,
                    fontWeightDelta: -1,
                    fontSizeDelta: -2,
                  ),
                ).marginOnly(right: Dimen.d_20)
              else
                TextButton(
                  key: const Key(KeyConstant.resendOTPBtn),
                  onPressed: () async {
                    // _loginController.otpTextController.text = '';
                    widget.onResendOtp();
                  },
                  child: Text(
                    LocalizationHandler.of().resendOTP,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      fontSizeDelta: -2,
                      decoration: TextDecoration.underline,
                      color: _loginController.isResendOtpEnabled
                          ? AppColors.colorAppOrange
                          : AppColors.colorGrey,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.isButtonEnable,
              builder: (context, isButtonEnable, _) {
                return TextButtonOrange.desktop(
                  text: LocalizationHandler.of().submit,
                  isButtonEnable: isButtonEnable,
                  onPressed: () {
                    if (widget.isButtonEnable.value) {
                      widget.onOtpVerify();
                    }
                  },
                );
              },
            ).marginOnly(right: Dimen.d_16),
            TextButtonPurple.desktop(
              text: LocalizationHandler.of().cancel,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(right: Dimen.d_16),
          ],
        ).marginOnly(
          top: Dimen.d_30,
        )
      ],
    );
  }
}
