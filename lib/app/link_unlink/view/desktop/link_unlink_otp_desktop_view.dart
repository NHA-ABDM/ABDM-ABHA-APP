import 'package:abha/app/link_unlink/view/widget/common_link_unlink_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class LinkUnlinkOtpDesktopView extends StatefulWidget {
  final VoidCallback onResendOtp;
  final VoidCallback onOtpVerify;
  final String mobileEmailValue;

  const LinkUnlinkOtpDesktopView({
    required this.onResendOtp,
    required this.onOtpVerify,
    required this.mobileEmailValue,
    super.key,
  });

  @override
  LinkUnlinkOtpDesktopViewState createState() =>
      LinkUnlinkOtpDesktopViewState();
}

class LinkUnlinkOtpDesktopViewState extends State<LinkUnlinkOtpDesktopView> {
  late LinkUnlinkController _linkUnlinkController;

  @override
  void initState() {
    _linkUnlinkController = Get.find<LinkUnlinkController>();
    abhaLog.e(widget.mobileEmailValue);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: _linkUnlinkOtpParentWidget(),
    );
  }

  Widget _linkUnlinkOtpParentWidget() {
    return Column(
      children: [
        Text(
          _linkUnlinkController.actionType == StringConstants.link
              ? LocalizationHandler.of().linkAbhaNumber
              : LocalizationHandler.of().unlinkAbhaNumber,
          style: CustomTextStyle.titleLarge(context)?.apply(
            color: AppColors.colorAppBlue,
            fontWeightDelta: 2,
          ),
        ).alignAtTopLeft().marginOnly(bottom: Dimen.d_20),
        CommonBackgroundCard(
          child: CommonLinkUnlinkWidget(
            image: _linkUnlinkController.actionType == StringConstants.link
                ? ImageLocalAssets.linkAbhaNumberSvg
                : ImageLocalAssets.unlinkAbhaNumberSvg,
            child: _otpWidget(),
          ),
        )
      ],
    ).marginAll(
      Dimen.d_20,
    );
  }

  Widget _otpWidget() {
    return GetBuilder<LinkUnlinkController>(
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              ),
              // Text(
              //   widget.mobileEmailValue,
              // ).marginOnly(top: Dimen.d_3),
              AutoFocusTextView(
                textEditingController:
                    _linkUnlinkController.textEditingController,
                errorController: _linkUnlinkController.errorController,
                fieldOuterPadding: EdgeInsets.only(right: Dimen.d_12),
                mainAxisAlignment: MainAxisAlignment.start,
                length: 6,
                width: Dimen.d_50,
                height: Dimen.d_50,
                onCompleted: (value) {
                  _linkUnlinkController.otpValue = value;
                },
                onChanged: (String value) {
                  if (!Validator.isNullOrEmpty(value) && value.length == 6) {
                    _linkUnlinkController.isSubmitEnable = true;
                  } else {
                    _linkUnlinkController.isSubmitEnable = false;
                  }
                  _linkUnlinkController.update();
                },
              ).marginOnly(
                top: Dimen.d_30,
              ),
              // .sizedBox(width: context.width),
              GetBuilder<LinkUnlinkController>(
                builder: (_) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!_linkUnlinkController.isResendOtpEnabled)
                      //   Container()
                      // else
                      Text(
                        '${LocalizationHandler.of().resend_code_in} ${_linkUnlinkController.otpCountDown} ${LocalizationHandler.of().sec}',
                        style: CustomTextStyle.bodyMedium(context)?.apply(
                          color: AppColors.colorBlack4,
                          fontSizeDelta: -2,
                        ),
                      )
                    else
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
                  top: Dimen.d_5,
                ),
              ),
              Row(
                children: [
                  TextButtonOrange.desktop(
                    key:const Key(KeyConstant.submit),
                    isButtonEnable: _linkUnlinkController.isSubmitEnable,
                    text: LocalizationHandler.of().submit,
                    onPressed: () {
                      if (_linkUnlinkController.isSubmitEnable) {
                        widget.onOtpVerify();
                      }
                    },
                  ),
                  TextButtonPurple.desktop(
                    text: LocalizationHandler.of().cancel,
                    onPressed: () {
                      context.navigateBack();
                    },
                  ).marginOnly(
                    left: Dimen.d_20,
                    right: Dimen.d_20,
                  )
                ],
              ).marginOnly(
                top: Dimen.d_30,
              ),
            ],
          ),
        );
      },
    );
  }
}
