import 'package:abha/export_packages.dart';

class AbhaNumberOptionDesktopView extends StatefulWidget {
  final VoidCallback generateOtp;

  const AbhaNumberOptionDesktopView({
    required this.generateOtp,
    super.key,
  });

  @override
  AbhaNumberOptionDesktopViewState createState() =>
      AbhaNumberOptionDesktopViewState();
}

class AbhaNumberOptionDesktopViewState
    extends State<AbhaNumberOptionDesktopView> {
  final AbhaNumberController _abhaNumberController =
      Get.find<AbhaNumberController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithEmailImg,
      title: LocalizationHandler.of().createAbhaNumber,
      child: abhaNumberWidget(),
    );
  }

  Widget abhaNumberWidget() {
    return GetBuilder<AbhaNumberController>(
      builder: (_) {
        return Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationHandler.of().validateUsing,
                  style: CustomTextStyle.headlineSmall(context)?.apply(
                    fontSizeDelta: -4,
                    fontWeightDelta: 1,
                  ),
                ).marginOnly(
                  left: Dimen.d_10,
                ),
                RadioListTile(
                  title: Text(
                    LocalizationHandler.of().otpVerifyAadhaar,
                    style: CustomTextStyle.bodyLarge(context)?.apply(
                      color:
                          _abhaNumberController.abhaVerificationOptionValue ==
                                  AbhaNumberOptionEnum.otpVerifyAadhaar
                              ? AppColors.colorBlack
                              : AppColors.colorAppBlue,
                    ),
                  ).paddingAll(Dimen.d_15),
                  value: AbhaNumberOptionEnum.otpVerifyAadhaar,
                  groupValue: _abhaNumberController.abhaVerificationOptionValue,
                  onChanged: (AbhaNumberOptionEnum? value) {
                    _abhaNumberController.abhaVerificationOptionValue = value;
                    _abhaNumberController.update();
                  },
                ).marginOnly(top: Dimen.d_10),
              ],
            ),
            TextButtonOrange.desktop(
              text: LocalizationHandler.of().next,
              onPressed: () async {
                if (_abhaNumberController.abhaVerificationOptionValue ==
                    AbhaNumberOptionEnum.otpVerifyAadhaar) {
                  widget.generateOtp();
                } else {}
              },
            ).marginOnly(top: Dimen.d_50),
          ],
        );
      },
    );
  }
}
