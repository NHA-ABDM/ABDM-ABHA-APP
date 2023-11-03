import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class RegistrationOtpMobileView extends StatefulWidget {
  final Map arguments;
  final VoidCallback onResendOtp;
  final VoidCallback onOtpVerify;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationOtpMobileView({
    required this.arguments,
    required this.onResendOtp,
    required this.onOtpVerify,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationOtpMobileViewState createState() =>
      RegistrationOtpMobileViewState();
}

class RegistrationOtpMobileViewState extends State<RegistrationOtpMobileView> {
  late RegistrationController _registrationController;
  late String _data;

  @override
  void initState() {
    super.initState();
    _data = widget.arguments[IntentConstant.sentToString];
    _registrationController = Get.find();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: kIsWeb
          ? MobileWebCardWidget(child: _otpWidget())
          : SingleChildScrollView(child: _otpWidget()),
    );
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
                    : _registrationController.registrationMethod ==
                            RegistrationMethod.verifyAadhaar
                        ? LocalizationHandler.of()
                            .sentOTPOnAbhaNumberWithAadhaar
                        : _registrationController.registrationMethod ==
                                RegistrationMethod.verifyMobile
                            ? LocalizationHandler.of()
                                .sentOTPOnAbhaNumberWithMobile
                            : _registrationController.registrationMethod ==
                                    RegistrationMethod.mobile
                                ? '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskingNumber(_data)}'
                                : _registrationController.registrationMethod ==
                                        RegistrationMethod.email
                                    ? '${LocalizationHandler.of().sentSixDigitOTPCode} ${Validator.maskEmail(_data)}'
                                    : '',
                style: CustomTextStyle.titleMedium(context)?.apply(
                  fontSizeDelta: -1,
                  color: AppColors.colorGreyDark,
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
                textEditingController:
                    _registrationController.otpTextController,
                errorController: _registrationController.errorController,
                length: 6,
                fieldOuterPadding: kIsWeb
                    ? EdgeInsets.only(right: Dimen.d_12)
                    : EdgeInsets.zero,
                mainAxisAlignment: kIsWeb
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.spaceBetween,
                width: kIsWeb ? Dimen.d_40 : Dimen.d_50,
                height: Dimen.d_50,
                onCompleted: (value) {},
                onChanged: (String value) {
                  if (!Validator.isNullOrEmpty(value) && value.length == 6) {
                    widget.isButtonEnable.value = true;
                  } else {
                    widget.isButtonEnable.value = false;
                  }
                },
              ).marginOnly(
                top: Dimen.d_20,
                left: Dimen.d_17,
                right: Dimen.d_17,
              ),
            ),
          ],
        ),
        GetBuilder<RegistrationController>(
          builder: (_) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_registrationController.isResendOtpEnabled)
                Container()
              else
                Text(
                  '${LocalizationHandler.of().resend_code_in} '
                  '${_registrationController.otpCountDown} ${LocalizationHandler.of().sec}',
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorBlack4,
                    fontWeightDelta: -1,
                    fontSizeDelta: -1,
                  ),
                ).marginOnly(right: Dimen.d_17),
              TextButton(
                key: const Key(KeyConstant.resendOTPBtn),
                onPressed: () async {
                  // _registrationController.otpTextController.text = '';
                  widget.onResendOtp();
                },
                child: Text(
                  LocalizationHandler.of().resendOTP,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    fontSizeDelta: -1,
                    decoration: TextDecoration.underline,
                    color: _registrationController.isResendOtpEnabled
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
              isButtonEnable: isButtonEnable,
              text: LocalizationHandler.of().submit,
              onPressed: () {
                if (isButtonEnable) {
                  widget.onOtpVerify();
                }
              },
            ).marginOnly(
              top: Dimen.d_30,
              left: Dimen.d_17,
              right: Dimen.d_17,
              bottom: Dimen.d_30,
            );
          },
        ),
      ],
    );
  }
}
