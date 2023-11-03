import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberForgetOtpMobileView extends StatefulWidget {
  final VoidCallback verifyOtp;
  final AbhaNumberController abhaNumberController;
  final VoidCallback reGenerateOtp;

  const AbhaNumberForgetOtpMobileView({
    required this.verifyOtp,
    required this.abhaNumberController,
    required this.reGenerateOtp,
    super.key,
  });

  @override
  AbhaNumberForgetOtpMobileViewState createState() =>
      AbhaNumberForgetOtpMobileViewState();
}

class AbhaNumberForgetOtpMobileViewState
    extends State<AbhaNumberForgetOtpMobileView> {
  late AbhaNumberController _abhaNumberController;

  @override
  void initState() {
    _abhaNumberController = widget.abhaNumberController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? MobileWebCardWidget(child: _otpWidget()) : _otpWidget();
  }

  Widget _otpWidget() {
    return SingleChildScrollView(
      //padding: kIsWeb ? EdgeInsets.all(Dimen.d_18) : EdgeInsets.zero,
      child: Column(
        children: [
          const CustomSvgImageView(ImageLocalAssets.otp),
          Text(
            LocalizationHandler.of().sendOtpOnAadhaar,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorBlack6,
              fontSizeDelta: -1,
            ),
          ).marginOnly(
            top: Dimen.d_10,
          ),
          Row(
            children: [
              Expanded(
                child: AutoFocusTextView(
                  textEditingController:
                      _abhaNumberController.otpTextController,
                  errorController: _abhaNumberController.otpErrorController,
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
                    if (!Validator.isNullOrEmpty(value) && value.length == 6) {
                      _abhaNumberController.isButtonEnable.value = true;
                    } else {
                      _abhaNumberController.isButtonEnable.value = false;
                    }
                    //setState(() {});
                  },
                )
                    .marginOnly(
                      top: Dimen.d_30,
                    )
                    .sizedBox(width: context.width),
              ),
            ],
          ),
          GetBuilder<AbhaNumberController>(
            builder: (_) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_abhaNumberController.isResendOtpEnabled)
                  Container()
                else
                  Text(
                    '${LocalizationHandler.of().resend_code_in} '
                    '${_abhaNumberController.otpCountDown} ${LocalizationHandler.of().sec}',
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack4,
                      fontWeightDelta: -1,
                      fontSizeDelta: -1,
                    ),
                  ).marginOnly(right: Dimen.d_17),
                TextButton(
                  key: const Key(KeyConstant.resendOTPBtn),
                  onPressed: () async {
                    if (_abhaNumberController.isResendOtpEnabled) {
                      // _abhaNumberController.otpTextController.text = '';
                      widget.reGenerateOtp();
                    }
                  },
                  child: Text(
                    LocalizationHandler.of().resendOTP,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      fontSizeDelta: -1,
                      decoration: TextDecoration.underline,
                      color: _abhaNumberController.isResendOtpEnabled
                          ? AppColors.colorAppOrange
                          : AppColors.colorGrey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _abhaNumberController.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.mobile(
                key: const Key(KeyConstant.continueBtn),
                isButtonEnable: isButtonEnable,
                text: LocalizationHandler.of().continuee,
                onPressed: () {
                  if (isButtonEnable) {
                    widget.verifyOtp();
                  }
                },
              ).marginOnly(top: Dimen.d_50);
            },
          )
        ],
      ).marginOnly(
        left: Dimen.d_17,
        right: Dimen.d_17,
      ),
    ).paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0);
  }
}
