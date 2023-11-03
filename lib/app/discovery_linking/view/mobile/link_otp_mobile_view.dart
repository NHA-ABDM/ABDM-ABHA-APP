import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/widget/steps_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LinkOtpMobileView extends StatefulWidget {
  final void Function(String) onOtpVerify;

  const LinkOtpMobileView({required this.onOtpVerify, super.key});

  @override
  LinkOtpMobileViewState createState() => LinkOtpMobileViewState();
}

class LinkOtpMobileViewState extends State<LinkOtpMobileView> {
  String _otpValue = '';
  final TextEditingController otpTEC = TextEditingController();
  final DiscoveryLinkingController _discoveryLinkingController =
      Get.find<DiscoveryLinkingController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _otpWidget();
  }

  Widget _otpWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StepsMobileView(
              title: LocalizationHandler.of().search_Record,
              icon: IconAssets.done,
              bgColor: AppColors.colorGreen,
            ),
            StepsMobileView(
              title: LocalizationHandler.of().discoverRecord,
              icon: IconAssets.done,
              bgColor: AppColors.colorGreen,
            ),
            StepsMobileView(steps: '3', title: LocalizationHandler.of().otp),
          ],
        ),
        Text(
          LocalizationHandler.of().sendOtp,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(fontWeightDelta: 2, color: AppColors.colorBlack6),
        ).marginOnly(
          top: Dimen.d_50,
          left: Dimen.d_10,
          right: Dimen.d_10,
        ),
        AutoFocusTextView(
          textEditingController: otpTEC,
          errorController: _discoveryLinkingController.errorController,
          length: 6,
          width: Dimen.d_50,
          height: Dimen.d_50,
          onCompleted: (value) {
            _otpValue = value;
          },
          onChanged: (String value) {
            if (!Validator.isNullOrEmpty(value) && value.length == 6) {
              _discoveryLinkingController.isButtonEnable.value = true;
            } else {
              _discoveryLinkingController.isButtonEnable.value = false;
            }
          },
        )
            .marginOnly(
              top: Dimen.d_20,
              left: Dimen.d_10,
              right: Dimen.d_10,
            )
            .sizedBox(width: context.width),
        ValueListenableBuilder<bool>(
          valueListenable: _discoveryLinkingController.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              text: LocalizationHandler.of().next,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                if (isButtonEnable) {
                  widget.onOtpVerify(_otpValue);
                }
              },
            ).marginOnly(top: Dimen.d_50, bottom: Dimen.d_20);
          },
        )
      ],
    );
  }
}
