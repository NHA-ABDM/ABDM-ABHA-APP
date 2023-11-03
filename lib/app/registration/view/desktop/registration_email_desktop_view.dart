import 'package:abha/export_packages.dart';

class RegistrationEmailDesktopView extends StatefulWidget {
  final VoidCallback onRegistrationContinueInit;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationEmailDesktopView({
    required this.onRegistrationContinueInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationEmailDesktopViewState createState() =>
      RegistrationEmailDesktopViewState();
}

class RegistrationEmailDesktopViewState
    extends State<RegistrationEmailDesktopView> {
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
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithEmailImg,
      title: LocalizationHandler.of().registrationWithEmail.toTitleCase(),
      child: registrationEmailWidget(),
    );
  }

  Widget registrationEmailWidget() {
    return Column(
      children: [
        AppTextFormField.desktop(
          context: context,
          title: LocalizationHandler.of().emailId,
          prefix: const CustomSvgImageView(ImageLocalAssets.shareEmailIconSvg),
          hintText: LocalizationHandler.of().hintEnterEmailAddress,
          key: const Key(KeyConstant.textFieldEmail),
          textEditingController: _registrationController.emailTextController,
          textInputType: TextInputType.emailAddress,
          onChanged: (value) {
            if (_registrationController.autoValidateModeWeb ==
                AutovalidateMode.disabled) {
              setState(() {
                _registrationController.autoValidateModeWeb =
                    AutovalidateMode.onUserInteraction;
              });
            }
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
          autoValidateMode: _registrationController.autoValidateModeWeb,
          validator: (value) {
            if (Validator.isNullOrEmpty(value)) {
              return LocalizationHandler.of().errorEnterEmailAddress;
            }
            if (!Validator.isEmailValid(value!)) {
              return LocalizationHandler.of().invalidEmailError;
            }
            return null;
          },
        ).marginOnly(top: Dimen.d_10),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.isButtonEnable,
              builder: (context, isButtonEnable, _) {
                return TextButtonOrange.desktop(
                  isButtonEnable: isButtonEnable,
                  text: LocalizationHandler.of().continuee,
                  onPressed: () {
                    if (isButtonEnable) {
                      _registrationController.registrationMethod =
                          RegistrationMethod.email;
                      widget.onRegistrationContinueInit();
                    }
                  },
                );
              },
            ).marginOnly(right: Dimen.d_16),
            TextButtonPurple.desktop(
              text: LocalizationHandler.of().cancel,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(right: Dimen.d_16),
          ],
        ).marginOnly(top: Dimen.d_20)
      ],
    );
  }
}
