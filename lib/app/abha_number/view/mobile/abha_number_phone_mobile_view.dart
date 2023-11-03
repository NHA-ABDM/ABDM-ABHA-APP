import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberPhoneMobileView extends StatefulWidget {
  final VoidCallback verifyFaceAuth;

  const AbhaNumberPhoneMobileView({
    required this.verifyFaceAuth,
    super.key,
  });

  @override
  AbhaNumberPhoneMobileViewState createState() =>
      AbhaNumberPhoneMobileViewState();
}

class AbhaNumberPhoneMobileViewState extends State<AbhaNumberPhoneMobileView> {
  final AbhaNumberController _abhaNumberController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _abhaNumberController.mobileTextController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _abhaNumberMobileOtpWidget();
  }

  Widget _abhaNumberMobileOtpWidget() {
    return Column(
      children: [
        if (kIsWeb)
          Text(
            LocalizationHandler.of().createAbhaNumber,
            style: CustomTextStyle.titleMedium(context)
                ?.apply(color: AppColors.colorAppBlue, fontWeightDelta: 2),
          ).alignAtCenter().paddingSymmetric(
                vertical: Dimen.d_20,
                horizontal: Dimen.d_20,
              ),
        if (kIsWeb)
          bodyWidget()
        else
          bodyWidget().marginOnly(left: Dimen.d_17, right: Dimen.d_17),
        TextButtonOrange.mobile(
          key: const Key(KeyConstant.continueBtn),
          text: LocalizationHandler.of().continuee,
          onPressed: () {
            widget.verifyFaceAuth();
          },
        ).marginOnly(top: Dimen.d_50),
      ],
    ).paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0);
  }

  Widget bodyWidget() {
    return Column(
      children: [
        AppTextFormField.mobile(
          context: context,
          key: const Key(KeyConstant.mobileNumberField),
          textEditingController: _abhaNumberController.mobileTextController,
          hintText: LocalizationHandler.of().hintEnterMobileNumber,
          title: LocalizationHandler.of().enterMobileNumber,
          prefix: const CustomSvgImageView(
            ImageLocalAssets.shareMobileNoIconSvg,
          ),
          textInputType: TextInputType.number,
          maxLength: 10,
          onChanged: (value) {
            if (value.length == 10) {
              _abhaNumberController.isButtonEnable.value = true;
              _abhaNumberController.functionHandler(
                isUpdateUi: true,
                updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
              );
            } else {
              _abhaNumberController.isButtonEnable.value = false;
              _abhaNumberController.functionHandler(
                isUpdateUi: true,
                updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
              );
            }
          },
        ).marginOnly(top: Dimen.d_30),
        Row(
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
        ).marginOnly(top: Dimen.d_10),
      ],
    );
  }
}
