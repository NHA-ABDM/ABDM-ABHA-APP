import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberForgetOtpDesktopView extends StatefulWidget {
  final VoidCallback verifyOtp;
  final AbhaNumberController abhaNumberController;
  final VoidCallback reGenerateOtp;

  const AbhaNumberForgetOtpDesktopView({
    required this.verifyOtp,
    required this.abhaNumberController,
    required this.reGenerateOtp,
    super.key,
  });

  @override
  AbhaNumberForgetOtpDesktopViewState createState() =>
      AbhaNumberForgetOtpDesktopViewState();
}

class AbhaNumberForgetOtpDesktopViewState
    extends State<AbhaNumberForgetOtpDesktopView> {
  late AbhaNumberController _abhaNumberController;
  @override
  void initState() {
    _abhaNumberController = widget.abhaNumberController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.otpImage,
      title: LocalizationHandler.of().titleForgotAbhaNumber,
      child: _otpWidget(),
    );
  }

  Widget _otpWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            LocalizationHandler.of().sendOtpOnAadhaar,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorBlack6,
              fontSizeDelta: -1,
            ),
          ).marginOnly(top: Dimen.d_10, left: Dimen.d_17, right: Dimen.d_17),
          Row(
            children: [
              Flexible(
                child: AutoFocusTextView(
                  textEditingController:
                      _abhaNumberController.otpTextController,
                  errorController: _abhaNumberController.otpErrorController,
                  length: 6,
                  width: Dimen.d_50,
                  height: Dimen.d_50,
                  onCompleted: (value) {},
                  onChanged: (String value) {
                    if (!Validator.isNullOrEmpty(value) && value.length == 6) {
                      _abhaNumberController.isButtonEnable.value = true;
                    } else {
                      _abhaNumberController.isButtonEnable.value = false;
                    }
                  },
                )
                    //.alignAtCenter()
                    .marginOnly(
                      top: Dimen.d_30,
                      left: Dimen.d_17,
                      right: Dimen.d_17,
                    )
                    //.sizedBox(width: context.width / 1.5),
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
            ).marginOnly(
              left: Dimen.d_17,
              right: Dimen.d_17,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _abhaNumberController.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.desktop(
                isButtonEnable: isButtonEnable,
                text: LocalizationHandler.of().continuee,
                onPressed: () {
                  if (isButtonEnable) {
                    widget.verifyOtp();
                  }
                },
              ).alignAtCenter().marginOnly(top: Dimen.d_50);
            },
          )
        ],
      ),
    ).paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0);
  }
}
