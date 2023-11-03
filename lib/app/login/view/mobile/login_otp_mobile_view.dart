import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LoginOtpMobileView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onResendOtp;
  final VoidCallback onOtpVerify;
  final ValueNotifier<bool> isButtonEnable;

  const LoginOtpMobileView({
    required this.arguments,
    required this.onResendOtp,
    required this.onOtpVerify,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginOtpMobileViewState createState() => LoginOtpMobileViewState();
}

class LoginOtpMobileViewState extends State<LoginOtpMobileView> {
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

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _otpWidget())
        : SingleChildScrollView(child: _otpWidget());
  }

  Widget _otpWidget() {
    return Column(
      children: [
        CustomImageView(
          image: ImageLocalAssets.otpImage,
          height: context.height * 0.25,
        ).marginOnly(top: Dimen.d_30).centerWidget,
        Row(
          children: [
            Flexible(
              child: Text(
                !Validator.isNullOrEmpty(
                  widget.arguments[IntentConstant.abhaAddress],
                )
                    ? LocalizationHandler.of().enterSixDigitOTP
                    : _loginController.loginMethod == LoginMethod.verifyAadhaar
                        ? LocalizationHandler.of()
                            .sentOTPOnAbhaNumberWithAadhaar
                        : _loginController.loginMethod ==
                                LoginMethod.verifyMobile
                            ? LocalizationHandler.of()
                                .sentOTPOnAbhaNumberWithMobile
                            : _loginController.loginMethod == LoginMethod.mobile
                                ? '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskingNumber(widget.arguments[IntentConstant.mobileEmail])}'
                                : _loginController.loginMethod ==
                                        LoginMethod.email
                                    ? '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskEmail(widget.arguments[IntentConstant.mobileEmail])}'
                                    : _loginController.loginMethod ==
                                            LoginMethod.verifyAbhaMobileOtp
                                        ? LocalizationHandler.of()
                                            .sentOTPOnAbhaNumberWithMobile
                                        : '',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack6,
                  fontSizeDelta: -1,
                ),
              ).marginOnly(
                top: Dimen.d_40,
                left: Dimen.d_17,
                right: Dimen.d_17,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: AutoFocusTextView(
                textEditingController: _loginController.otpTextController,
                errorController: _loginController.errorController,
                length: 6,
                width: kIsWeb ? Dimen.d_40 : Dimen.d_50,
                fieldOuterPadding: kIsWeb
                    ? EdgeInsets.only(right: Dimen.d_12)
                    : EdgeInsets.zero,
                mainAxisAlignment: kIsWeb
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
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
              ).marginOnly(
                top: Dimen.d_30,
                left: Dimen.d_17,
                right: Dimen.d_17,
              ),
            ),
          ],
        ),
        GetBuilder<LoginController>(
          builder: (_) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_loginController.isResendOtpEnabled)
                Container()
              else
                Text(
                  '${LocalizationHandler.of().resend_code_in}'
                  '${_loginController.otpCountDown} ${LocalizationHandler.of().sec}',
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack4,
                    fontWeightDelta: -1,
                    fontSizeDelta: -1,
                  ),
                ).marginOnly(right: Dimen.d_17),
              TextButton(
                key: const Key(KeyConstant.resendOTPBtn),
                onPressed: () async {
                  // _loginController.otpTextController.text = '';
                  widget.onResendOtp();
                },
                child: Text(
                  LocalizationHandler.of().resendOTP,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    fontSizeDelta: -1,
                    decoration: TextDecoration.underline,
                    color: _loginController.isResendOtpEnabled
                        ? AppColors.colorAppOrange
                        : AppColors.colorGrey,
                  ),
                ),
              ),
            ],
          ).marginOnly(left: Dimen.d_17, right: Dimen.d_17),
        ),
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              text: LocalizationHandler.of().submit,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                if (widget.isButtonEnable.value) {
                  widget.onOtpVerify();
                }
              },
            )
                .paddingSymmetric(
                  horizontal: kIsWeb ? Dimen.d_16 : Dimen.d_16,
                  vertical: kIsWeb ? Dimen.d_16 : Dimen.d_0,
                )
                .marginOnly(top: Dimen.d_30);
          },
        )
      ],
    );
  }
}
