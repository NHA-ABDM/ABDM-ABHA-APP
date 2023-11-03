import 'package:abha/export_packages.dart';

class RegistrationOtpDesktopView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onResendOtp;
  final VoidCallback onOtpVerify;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationOtpDesktopView({
    required this.arguments,
    required this.onResendOtp,
    required this.onOtpVerify,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationOtpDesktopViewState createState() =>
      RegistrationOtpDesktopViewState();
}

class RegistrationOtpDesktopViewState
    extends State<RegistrationOtpDesktopView> {
  final RegistrationController _registrationController =
      Get.find<RegistrationController>();
  late String _data;

  @override
  void initState() {
    super.initState();
    _data = widget.arguments[IntentConstant.sentToString];
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// @Here function used to set the different titles as registration type selected.
  String initScreenTitleText() {
    String fromScreenString = widget.arguments[IntentConstant.fromScreen];
    if (fromScreenString == 'registrationEmail') {
      return LocalizationHandler.of().registrationWithEmail.toTitleCase();
    } else if (fromScreenString == 'registrationMobile') {
      return LocalizationHandler.of()
          .registrationWithMobileNumber
          .toTitleCase();
    } else if (fromScreenString == 'registrationAbha') {
      return LocalizationHandler.of().registrationWithABHANUmber;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.otpImage,
      title: initScreenTitleText(),
      child: otpWidget(),
    );
  }

  Widget otpWidget() {
    String textString = '';

    if (_registrationController.registrationMethod ==
        RegistrationMethod.verifyAadhaar) {
      textString = LocalizationHandler.of().sentOTPOnAbhaNumberWithAadhaar;
    } else if (_registrationController.registrationMethod ==
        RegistrationMethod.verifyMobile) {
      textString = LocalizationHandler.of().sentOTPOnAbhaNumberWithMobile;
    } else if (_registrationController.registrationMethod ==
        RegistrationMethod.mobile) {
      textString =
          '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskingNumber(_data)}';
    } else if (_registrationController.registrationMethod ==
        RegistrationMethod.email) {
      textString =
          '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskEmail(_data)}';
    }
    return Column(
      children: [
        Text(
          textString,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorBlack6, fontSizeDelta: -2),
        ).alignAtTopLeft(),
        AutoFocusTextView(
          textEditingController: _registrationController.otpTextController,
          errorController: _registrationController.errorController,
          fieldOuterPadding: EdgeInsets.only(right: Dimen.d_12),
          mainAxisAlignment: MainAxisAlignment.start,
          length: 6,
          width: Dimen.d_50,
          height: Dimen.d_50,
          onChanged: (String value) {
            if (!Validator.isNullOrEmpty(value) && value.length == 6) {
              widget.isButtonEnable.value = true;
            } else {
              widget.isButtonEnable.value = false;
            }
            // setState(() {});
          },
        ).alignAtCenter().marginOnly(top: Dimen.d_20),
        GetBuilder<RegistrationController>(
          builder: (_) => Row(
            children: [
              if (!_registrationController.isResendOtpEnabled)
                Text(
                  '${LocalizationHandler.of().resendOtpIn} ${_registrationController.otpCountDown} ${LocalizationHandler.of().sec}',
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack4,
                    fontWeightDelta: -1,
                    fontSizeDelta: -2,
                  ),
                ).paddingSymmetric(vertical: Dimen.d_8)
              else
                //   Container(),
                // if (registrationController.isResendOtpEnabled)
                TextButton(
                  key: const Key(KeyConstant.resendOTPBtn),
                  onPressed: () async {
                    // registrationController.otpTextController.text = '';
                    widget.onResendOtp();
                  },
                  child: Text(
                    LocalizationHandler.of().resendOTP,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      fontSizeDelta: -2,
                      decoration: TextDecoration.underline,
                      color: _registrationController.isResendOtpEnabled
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
                  isButtonEnable: isButtonEnable,
                  text: LocalizationHandler.of().continuee,
                  onPressed: () {
                    if (isButtonEnable) {
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
        ).marginOnly(top: Dimen.d_20)
      ],
    ).marginOnly(top: Dimen.d_0);
  }
}
