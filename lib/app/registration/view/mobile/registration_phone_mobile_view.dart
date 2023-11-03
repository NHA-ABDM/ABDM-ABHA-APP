import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class RegistrationPhoneMobileView extends StatefulWidget {
  final VoidCallback onRegistrationContinueInit;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationPhoneMobileView({
    required this.onRegistrationContinueInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationPhoneMobileViewState createState() =>
      RegistrationPhoneMobileViewState();
}

class RegistrationPhoneMobileViewState
    extends State<RegistrationPhoneMobileView> {
  late RegistrationController _registrationController;

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(
            child: loginMobileWidget().paddingOnly(bottom: Dimen.d_16),
          )
        : SingleChildScrollView(child: loginMobileWidget());
  }

  Widget loginMobileWidget() {
    return Column(
      children: [
        Column(
          children: [
            if (kIsWeb)
              Text(
                LocalizationHandler.of().registrationWithMobileNumber,
                style: CustomTextStyle.titleLarge(context)?.apply(
                  color: AppColors.colorAppBlue,
                  fontWeightDelta: 2,
                ),
              ).paddingSymmetric(
                vertical: Dimen.d_20,
                horizontal: Dimen.d_20,
              ),
            CustomImageView(
              image: ImageLocalAssets.loginWithMobileImg,
              height: context.height * 0.25,
            ).marginOnly(top: Dimen.d_30).centerWidget,
            Column(
              children: [
                AppTextFormField.mobile(
                  context: context,
                  title: LocalizationHandler.of().enterMobileNumber,
                  prefix: const CustomSvgImageView(
                    ImageLocalAssets.shareMobileNoIconSvg,
                  ),
                  hintText: LocalizationHandler.of().hintEnterMobileNumber,
                  key: const Key(KeyConstant.mobileNumberField),
                  textEditingController:
                      _registrationController.mobileTexController,
                  textInputType: TextInputType.number,
                  maxLength: 10,
                  validator: (String? value) {
                    return Validator.validateMobileNumber(value);
                  },
                  onChanged: (value) {
                    if (value.length == 10) {
                      widget.isButtonEnable.value = true;
                      _registrationController.functionHandler(
                        isUpdateUi: true,
                        updateUiBuilderIds: [
                          UpdateAddressSelectUiBuilderIds.updateLoginButton
                        ],
                      );
                    } else {
                      widget.isButtonEnable.value = false;
                      _registrationController.functionHandler(
                        isUpdateUi: true,
                        updateUiBuilderIds: [
                          UpdateAddressSelectUiBuilderIds.updateLoginButton
                        ],
                      );
                    }
                  },
                ).marginOnly(top: Dimen.d_30),
              ],
            )
          ],
        ).marginSymmetric(horizontal: Dimen.d_20),
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              isButtonEnable: isButtonEnable,
              text: LocalizationHandler.of().continuee,
              onPressed: () {
                if (isButtonEnable) {
                  _registrationController.registrationMethod =
                      RegistrationMethod.mobile;
                  widget.onRegistrationContinueInit();
                }
              },
            ).marginOnly(top: Dimen.d_30, left: Dimen.d_17, right: Dimen.d_17);
          },
        )
      ],
    );
  }
}
