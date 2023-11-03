import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LinkUnlinkOtpMobileView extends StatefulWidget {
  final VoidCallback onResendOtp;
  final VoidCallback onOtpVerify;
  final String mobileEmailValue;

  const LinkUnlinkOtpMobileView({
    required this.onResendOtp,
    required this.onOtpVerify,
    required this.mobileEmailValue,
    super.key,
  });

  @override
  LinkUnlinkOtpMobileViewState createState() => LinkUnlinkOtpMobileViewState();
}

class LinkUnlinkOtpMobileViewState extends State<LinkUnlinkOtpMobileView> {
  late LinkUnlinkController _linkUnlinkController;

  @override
  void initState() {
    _linkUnlinkController = Get.find<LinkUnlinkController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? MobileWebCardWidget(child: _otpWidget()) : _otpWidget();
  }

  Widget _otpWidget() {
    return GetBuilder<LinkUnlinkController>(
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            children: [
              CustomImageView(
                image: ImageLocalAssets.otpImage,
                height: context.height * 0.25,
              ).centerWidget.marginOnly(top: Dimen.d_20),
              Text(
                _linkUnlinkController.linkUnlinkMethod ==
                        LinkUnlinkMethod.verifyAadhaar
                    ? LocalizationHandler.of().sentOTPOnAbhaNumberWithAadhaar
                    : LocalizationHandler.of().sentOTPOnAbhaNumberWithMobile,
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack6,
                  fontWeightDelta: 2,
                ),
                //textAlign: TextAlign.center,
              ).marginOnly(top: Dimen.d_40),
              Row(
                children: [
                  Flexible(
                    child: AutoFocusTextView(
                      textEditingController:
                          _linkUnlinkController.textEditingController,
                      errorController: _linkUnlinkController.errorController,
                      length: 6,
                      width: Dimen.d_50,
                      height: Dimen.d_50,
                      onCompleted: (value) {
                        _linkUnlinkController.otpValue = value;
                      },
                      onChanged: (String value) {
                        if (!Validator.isNullOrEmpty(value) &&
                            value.length == 6) {
                          _linkUnlinkController.isSubmitEnable = true;
                        } else {
                          _linkUnlinkController.isSubmitEnable = false;
                        }
                        _linkUnlinkController.update();
                      },
                    ).marginOnly(top: Dimen.d_30),
                  ),
                ],
              ),
              GetBuilder<LinkUnlinkController>(
                builder: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_linkUnlinkController.isResendOtpEnabled)
                      Container()
                    else
                      Text(
                        '${LocalizationHandler.of().resend_code_in} ${_linkUnlinkController.otpCountDown} ${LocalizationHandler.of().sec}',
                        style: CustomTextStyle.bodyMedium(context)?.apply(
                          color: AppColors.colorBlack4,
                          fontSizeDelta: -2,
                        ),
                      ),
                    TextButton(
                      key: const Key(KeyConstant.resendOTPBtn),
                      onPressed: () async {
                        // _linkUnlinkController.textEditingController.text = '';
                        widget.onResendOtp();
                      },
                      child: Text(
                        LocalizationHandler.of().resendOTP,
                        style: CustomTextStyle.bodyMedium(context)?.apply(
                          fontSizeDelta: -2,
                          color: _linkUnlinkController.isResendOtpEnabled
                              ? AppColors.colorAppOrange
                              : AppColors.colorGrey,
                        ),
                      ),
                    )
                  ],
                ).marginOnly(
                  top: Dimen.d_25,
                ),
              ),
              TextButtonOrange.mobile(
                key: const Key(KeyConstant.submit),
                isButtonEnable: _linkUnlinkController.isSubmitEnable,
                text: LocalizationHandler.of().submit,
                onPressed: () {
                  if (_linkUnlinkController.isSubmitEnable) {
                    widget.onOtpVerify();
                  }
                },
              ).marginOnly(top: Dimen.d_30),
            ],
          ),
        ).paddingSymmetric(
          vertical: Dimen.d_16,
          horizontal: Dimen.d_16,
        );
      },
    );
  }
}
