import 'package:abha/app/abha_number/view/desktop/abha_number_option_desktop_view.dart';
import 'package:abha/app/abha_number/view/mobile/abha_number_option_mobile_view.dart';
import 'package:abha/export_packages.dart';

class AbhaNumberOptionView extends StatefulWidget {
  const AbhaNumberOptionView({super.key});

  @override
  AbhaNumberOptionViewState createState() => AbhaNumberOptionViewState();
}

class AbhaNumberOptionViewState extends State<AbhaNumberOptionView> {
  final AbhaNumberController _abhaNumberController =
      Get.find<AbhaNumberController>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _abhaNumberController.aadhaarNumberTextController.clear();
    super.dispose();
  }

  /// This method is used to generate OTP for the Abha Number.
  /// It takes no arguments and returns a Future<void> type.
  /// The functionHandler() is called to generate OTP and the responseHandler.status is checked for success.
  /// If successful, navigatePushNamed() is called to navigate to the Abha Number OTP page.
  void _generateOtp() {
    abhaLog.e(_abhaNumberController.aadhaarNumber);
    _abhaNumberController
        .functionHandler(
      function: () => _abhaNumberController.genAbhaNumberCreateOtp(),
      isLoaderReq: true,
    )
        .then((_) {
      if (_abhaNumberController.responseHandler.status == Status.success) {
        context.navigatePushReplacement(RoutePath.routeAbhaNumberOtp);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().createAbhaNumber,
      type: AbhaNumberOptionView,
      bodyMobile: AbhaNumberOptionMobileView(
        generateOtp: _generateOtp,
      ),
      bodyDesktop: AbhaNumberOptionDesktopView(
        generateOtp: _generateOtp,
      ),
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
    );
  }

  void _faceAuthValidationDialog() {
    TextStyle? defaultStyle = CustomTextStyle.titleSmall(context)
        ?.apply(color: AppColors.colorAppOrange);
    TextStyle? inlineStyle =
        CustomTextStyle.titleSmall(context)?.apply(fontWeightDelta: -1);
    context.openDialog(
      CustomSimpleDialog(
        paddingLeft: Dimen.d_10,
        size: Dimen.d_10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImageView(
              image: ImageLocalAssets.usbDebug,
              height: Dimen.d_70,
            ),
            Text(
              LocalizationHandler.of().turnOffDebug,
              style: CustomTextStyle.bodyLarge(context)?.apply(
                fontWeightDelta: 2,
              ),
              textAlign: TextAlign.center,
            )
                .marginOnly(top: Dimen.d_10)
                .sizedBox(width: Dimen.d_200)
                .alignAtCenter(),
            Text(
              LocalizationHandler.of().faceAuthVerification,
              style: CustomTextStyle.bodySmall(context)?.apply(
                fontWeightDelta: -1,
              ),
              textAlign: TextAlign.center,
            ).marginOnly(top: Dimen.d_10),
            Divider(
              thickness: Dimen.d_1,
              color: AppColors.colorGreyWildSand,
            ).marginOnly(top: Dimen.d_10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  image: ImageLocalAssets.hint,
                  height: Dimen.d_30,
                  width: Dimen.d_30,
                ).marginOnly(top: Dimen.d_5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        LocalizationHandler.of().disableUsbDebugging,
                        style: CustomTextStyle.bodySmall(context)?.apply(
                          fontWeightDelta: 2,
                        ),
                      ).marginOnly(top: Dimen.d_10, left: Dimen.d_10),
                      RichText(
                        text: TextSpan(
                          style: defaultStyle,
                          children: [
                            const TextSpan(
                              text: '1. ',
                            ),
                            TextSpan(
                              text: LocalizationHandler.of()
                                  .disableUsbDebuggingSteps1,
                              style: inlineStyle,
                            ),
                          ],
                        ),
                      ).marginOnly(top: Dimen.d_10, left: Dimen.d_5),
                      RichText(
                        text: TextSpan(
                          style: defaultStyle,
                          children: [
                            const TextSpan(
                              text: '2. ',
                            ),
                            TextSpan(
                              text: LocalizationHandler.of()
                                  .disableUsbDebuggingSteps2,
                              style: inlineStyle,
                            ),
                          ],
                        ),
                      ).marginOnly(top: Dimen.d_10, left: Dimen.d_5),
                      RichText(
                        text: TextSpan(
                          style: defaultStyle,
                          children: [
                            const TextSpan(
                              text: '3. ',
                            ),
                            TextSpan(
                              text: LocalizationHandler.of()
                                  .disableUsbDebuggingSteps3,
                              style: inlineStyle,
                            ),
                          ],
                        ),
                      ).marginOnly(top: Dimen.d_10, left: Dimen.d_5),
                      RichText(
                        text: TextSpan(
                          style: defaultStyle,
                          children: [
                            const TextSpan(
                              text: '4. ',
                            ),
                            TextSpan(
                              text: LocalizationHandler.of()
                                  .disableUsbDebuggingSteps4,
                              style: inlineStyle,
                            ),
                          ],
                        ),
                      ).marginOnly(top: Dimen.d_10, left: Dimen.d_5),
                    ],
                  ),
                )
              ],
            ),
            TextButtonOrange.mobile(
              text: LocalizationHandler.of().okay,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(top: Dimen.d_30),
          ],
        ).paddingAll(Dimen.d_15),
      ),
    );
  }
}
