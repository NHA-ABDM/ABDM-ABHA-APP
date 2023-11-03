import 'package:abha/export_packages.dart';

class AbhaNumberOtpDesktopView extends StatefulWidget {
  final VoidCallback verifyOtp;
  final VoidCallback resendOtp;

  const AbhaNumberOtpDesktopView({
    required this.verifyOtp,
    required this.resendOtp,
    super.key,
  });

  @override
  AbhaNumberOtpDesktopViewState createState() =>
      AbhaNumberOtpDesktopViewState();
}

class AbhaNumberOtpDesktopViewState extends State<AbhaNumberOtpDesktopView> {
  final AbhaNumberController _abhaNumberController = Get.find();

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.otpImage,
      title: LocalizationHandler.of().createAbhaNumber,
      child: abhaNumberMobileOtpWidget(),
    );
  }

  Widget abhaNumberMobileOtpWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            LocalizationHandler.of().sendOtpOnAadhaar,
            style: CustomTextStyle.titleLarge(context)?.apply(),
          ).marginOnly(top: Dimen.d_10),
          Flexible(
            child: AutoFocusTextView(
              textEditingController: _abhaNumberController.otpTextController,
              errorController: _abhaNumberController.otpErrorController,
              length: 6,
              width: Dimen.d_50,
              height: Dimen.d_50,
              onCompleted: (value) {},
              onChanged: (String value) {},
            )
                .alignAtCenter()
                .marginOnly(top: Dimen.d_30)
                .sizedBox(width: context.width / 1.5),
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
              left: Dimen.d_17,
              right: Dimen.d_17,
            ),
          ),
          mobileField(),
          ValueListenableBuilder<bool>(
            valueListenable: _abhaNumberController.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.desktop(
                isButtonEnable: isButtonEnable,
                text: LocalizationHandler.of().validate,
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
    );
  }

  Widget mobileField() {
    return Column(
      children: [
        Text(
          LocalizationHandler.of().enterMobileNumber,
          style: CustomTextStyle.titleMedium(context)?.apply(),
        )
            .alignAtTopLeft()
            .marginOnly(top: Dimen.d_30, left: Dimen.d_15, right: Dimen.d_15),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CustomSvgImageView(
              ImageLocalAssets.shareMobileNoIconSvg,
              width: Dimen.d_25,
              height: Dimen.d_25,
            ),
            Flexible(
              child: AppTextField(
                key: const Key(KeyConstant.mobileNumberField),
                fontSizeDelta: 4,
                textEditingController:
                    _abhaNumberController.mobileTextController,
                textInputType: TextInputType.number,
                maxLength: 10,
                onChanged: (value) {
                  _abhaNumberController.mobileNumber = value;
                  if (value.length == 10) {
                    _abhaNumberController.isButtonEnable.value = true;
                  } else {
                    _abhaNumberController.isButtonEnable.value = false;
                  }
                },
              ).marginOnly(left: Dimen.d_10),
            )
          ],
        ).marginOnly(left: Dimen.d_15, right: Dimen.d_15),
      ],
    );
  }
}
