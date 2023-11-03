import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/textfield/decoration/app_text_field_no_underline_decoration.dart';

class AbhaNumberPhoneDesktopView extends StatefulWidget {
  final VoidCallback verifyFaceAuth;

  const AbhaNumberPhoneDesktopView({required this.verifyFaceAuth, super.key});

  @override
  AbhaNumberPhoneDesktopViewState createState() =>
      AbhaNumberPhoneDesktopViewState();
}

class AbhaNumberPhoneDesktopViewState
    extends State<AbhaNumberPhoneDesktopView> {
  final AbhaNumberController _abhaNumberController = Get.find();

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
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithEmailImg,
      title: LocalizationHandler.of().createAbhaNumber,
      child: _abhaNumberMobileOtpWidget(),
    );
  }

  Widget _abhaNumberMobileOtpWidget() {
    return Column(
      children: [
        Column(
          children: [
            Text(
              LocalizationHandler.of().enterMobileNumber,
              style: CustomTextStyle.titleSmall(context)
                  ?.apply(color: AppColors.colorGrey3),
            ).alignAtTopLeft().marginOnly(
                  top: Dimen.d_30,
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  StringConstants.countryCode,
                  style: CustomTextStyle.titleSmall(context)
                      ?.apply(color: AppColors.colorGrey3),
                ),
                VerticalDivider(
                  thickness: Dimen.d_1,
                  color: AppColors.colorGreyWildSand,
                ),
                Expanded(
                  child: AppTextField(
                    textEditingController:
                        _abhaNumberController.mobileTextController,
                    textInputType: TextInputType.number,
                    autofocus: true,
                    maxLength: 10,
                    decoration: AppTextFormNoUnderlineDecoration()
                        .getDefaultDecoration(context: context),
                  ).marginOnly(left: Dimen.d_10),
                )
              ],
            )
                .marginOnly(
                  top: Dimen.d_30,
                )
                .sizedBox(height: Dimen.d_50),
            Divider(
              thickness: Dimen.d_1,
              color: AppColors.colorGreyWildSand,
            ).marginOnly(top: Dimen.d_10),
            InfoNote(
              note: LocalizationHandler.of().mobileNumberForAbha,
            ).marginOnly(top: Dimen.d_10),
          ],
        ),
        TextButtonOrange.desktop(
          text: LocalizationHandler.of().continuee,
          onPressed: () {
            widget.verifyFaceAuth();
          },
        ).alignAtCenter().marginOnly(top: Dimen.d_50),
      ],
    );
  }
}
