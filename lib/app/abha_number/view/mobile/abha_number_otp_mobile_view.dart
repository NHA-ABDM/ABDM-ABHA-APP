import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberOtpMobileView extends StatefulWidget {
  final VoidCallback verifyOtp;
  final VoidCallback resendOtp;

  const AbhaNumberOtpMobileView({
    required this.verifyOtp,
    required this.resendOtp,
    super.key,
  });

  @override
  AbhaNumberOtpMobileViewState createState() => AbhaNumberOtpMobileViewState();
}

class AbhaNumberOtpMobileViewState extends State<AbhaNumberOtpMobileView> {
  final AbhaNumberController _abhaNumberController = Get.find();

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _abhaNumberMobileOtpWidget())
        : _abhaNumberMobileOtpWidget();
  }

  Widget _abhaNumberMobileOtpWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomSvgImageView(ImageLocalAssets.otp),
          Text(
            LocalizationHandler.of().sendOtpOnAadhaar,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorBlack6,
              fontSizeDelta: -1,
            ),
          ).marginOnly(top: Dimen.d_10, left: Dimen.d_16, right: Dimen.d_16),
          Row(
            children: [
              Expanded(
                child: AutoFocusTextView(
                  textEditingController:
                      _abhaNumberController.otpTextController,
                  errorController: _abhaNumberController.otpErrorController,
                  length: 6,
                  width: Dimen.d_50,
                  height: Dimen.d_50,
                  onCompleted: (value) {},
                  onChanged: (String value) {},
                ).marginOnly(
                  top: Dimen.d_30,
                  left: Dimen.d_16,
                  right: Dimen.d_16,
                ),
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
                  ).marginOnly(right: Dimen.d_16),
                TextButton(
                  key: const Key(KeyConstant.resendOTPBtn),
                  onPressed: () async {
                    if (_abhaNumberController.isResendOtpEnabled) {
                      // _abhaNumberController.otpTextController.text = '';
                      widget.resendOtp();
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
              left: Dimen.d_16,
              right: Dimen.d_16,
            ),
          ),
          mobileField(),
          ValueListenableBuilder<bool>(
            valueListenable: _abhaNumberController.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.mobile(
                key: const Key(KeyConstant.continueBtn),
                isButtonEnable: isButtonEnable,
                text: LocalizationHandler.of().validate,
                onPressed: () {
                  if (isButtonEnable) {
                    widget.verifyOtp();
                  }
                },
              ).marginOnly(
                top: Dimen.d_50,
                left: Dimen.d_16,
                right: Dimen.d_16,
              );
            },
          )
        ],
      ).paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0),
    );
  }

  Widget mobileField() {
    return Column(
      children: [
        AppTextFormField.mobile(
          context: context,
          key: const Key(KeyConstant.mobileNumberField),
          textEditingController: _abhaNumberController.mobileTextController,
          hintText: LocalizationHandler.of().hintEnterMobileNumber,
          title: LocalizationHandler.of().enterMobileNumber,
          prefix:
              const CustomSvgImageView(ImageLocalAssets.shareMobileNoIconSvg),
          textInputType: TextInputType.number,
          maxLength: 10,
          isRequired: true,
          validator: (String? value) {
            return Validator.validateMobileNumber(value);
          },
          onChanged: (value) {
            _abhaNumberController.mobileNumber = value;
            if (value.length == 10) {
              _abhaNumberController.isButtonEnable.value = true;
            } else {
              _abhaNumberController.isButtonEnable.value = false;
            }
          },
        ).marginOnly(top: Dimen.d_20),
        _note().marginOnly(top: Dimen.d_3)
      ],
    ).marginOnly(left: Dimen.d_17, right: Dimen.d_17);
  }

  Widget _note() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          IconAssets.infoOutline,
          size: Dimen.d_20,
          color: AppColors.colorAppBlue,
        ),
        Flexible(
          child: Text(
            LocalizationHandler.of().noteAbhaNumberCreation,
            softWrap: true,
            style: CustomTextStyle.titleSmall(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: -1,
              fontSizeDelta: -1,
              heightDelta: 0.3,
            ),
          ).marginOnly(left: Dimen.d_10, right: Dimen.d_10),
        )
      ],
    );
  }
}
