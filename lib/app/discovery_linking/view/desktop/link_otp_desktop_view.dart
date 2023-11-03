import 'package:abha/app/discovery_linking/discovery_linking_controller.dart';
import 'package:abha/app/discovery_linking/widget/steps_desktop_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class LinkOtpDesktopView extends StatefulWidget {
  final void Function(String) onOtpVerify;

  const LinkOtpDesktopView({required this.onOtpVerify, super.key});

  @override
  LinkOtpViewState createState() => LinkOtpViewState();
}

class LinkOtpViewState extends State<LinkOtpDesktopView> {
  String _otpValue = '';
  final TextEditingController otpTEC = TextEditingController();
  final DiscoveryLinkingController _discoveryLinkingController = Get.find<DiscoveryLinkingController>();

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
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().linkMyHealthRecord,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StepsDesktopView(
                  steps: '1',
                  title: LocalizationHandler.of().search_Record,
                  bgColor: AppColors.colorGreen,
                  fgColor: AppColors.colorWhite,
                ),
              ),
              Expanded(
                child: StepsDesktopView(
                  steps: '2',
                  title: LocalizationHandler.of().discoverRecord,
                  bgColor: AppColors.colorGreen,
                  fgColor: AppColors.colorWhite,
                ),
              ),
              Expanded(
                child: StepsDesktopView(
                  bgColor: AppColors.colorAppBlue,
                  fgColor: AppColors.colorWhite,
                  steps: '3',
                  title: LocalizationHandler.of().otpVerification,
                ),
              ),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          CommonBackgroundCard(child: _otpWidget()).sizedBox(width: context.width)
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget _otpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationHandler.of().sendOtp,
          style: CustomTextStyle.bodySmall(context)?.apply(fontWeightDelta: 2, color: AppColors.colorBlack6),
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
            )
            .sizedBox(width: context.width / 3),
        ValueListenableBuilder<bool>(
          valueListenable: _discoveryLinkingController.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.desktop(
              text: LocalizationHandler.of().next,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                if (isButtonEnable) {
                  widget.onOtpVerify(_otpValue);
                }
              },
            ).marginOnly(top: Dimen.d_25);
          },
        )
      ],
    );
  }
}
