import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class RegistrationEmailMobileView extends StatefulWidget {
  final VoidCallback onRegistrationContinueInit;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationEmailMobileView({
    required this.onRegistrationContinueInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationEmailMobileViewState createState() =>
      RegistrationEmailMobileViewState();
}

class RegistrationEmailMobileViewState
    extends State<RegistrationEmailMobileView> {
  late RegistrationController _registrationController;

  @override
  void initState() {
    _registrationController = Get.find();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: kIsWeb
          ? MobileWebCardWidget(child: registrationEmailWidget())
          : SingleChildScrollView(child: registrationEmailWidget()),
    );
  }

  Widget registrationEmailWidget() {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (kIsWeb)
              Text(
                LocalizationHandler.of().registrationWithEmail.toTitleCase(),
                style: CustomTextStyle.titleLarge(context)?.apply(
                  color: AppColors.colorAppBlue,
                  fontWeightDelta: 2,
                ),
              )
                  .paddingSymmetric(
                    vertical: Dimen.d_20,
                    horizontal: Dimen.d_20,
                  )
                  .centerWidget,
            CustomImageView(
              image: ImageLocalAssets.loginWithEmailImg,
              height: context.height * 0.25,
            ).marginOnly(top: Dimen.d_30).centerWidget,
            Column(
              children: [
                AppTextFormField.mobile(
                  context: context,
                  title: LocalizationHandler.of().enterEmailId,
                  prefix: const CustomSvgImageView(
                    ImageLocalAssets.shareEmailIconSvg,
                  ),
                  hintText: LocalizationHandler.of().hintEnterEmailAddress,
                  key: const Key(KeyConstant.textFieldEmail),
                  textEditingController:
                      _registrationController.emailTextController,
                  textInputType: TextInputType.emailAddress,
                  onChanged: (value) {
                    if (Validator.isEmailValid(value)) {
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
                  validator: (value) {
                    if (Validator.isNullOrEmpty(value)) {
                      return LocalizationHandler.of().errorEnterEmailAddress;
                    }
                    if (!Validator.isEmailValid(value!)) {
                      return LocalizationHandler.of().invalidEmailError;
                    }
                    return null;
                  },
                ).marginOnly(top: Dimen.d_30),
              ],
            ).marginOnly(
              left: Dimen.d_17,
              right: Dimen.d_17,
            )
          ],
        ).marginSymmetric(horizontal: Dimen.d_5),
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              isButtonEnable: widget.isButtonEnable.value,
              text: LocalizationHandler.of().continuee,
              onPressed: () {
                if (widget.isButtonEnable.value) {
                  _registrationController.registrationMethod =
                      RegistrationMethod.email;
                  widget.onRegistrationContinueInit();
                }
              },
            ).marginOnly(
              top: Dimen.d_30,
              bottom: Dimen.d_30,
              left: Dimen.d_17,
              right: Dimen.d_17,
            );
          },
        )
      ],
    );
  }
}
