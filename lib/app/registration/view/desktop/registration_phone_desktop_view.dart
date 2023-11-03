import 'package:abha/export_packages.dart';

class RegistrationPhoneDesktopView extends StatefulWidget {
  final VoidCallback onRegistrationContinueInit;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationPhoneDesktopView({
    required this.onRegistrationContinueInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationPhoneDesktopViewState createState() =>
      RegistrationPhoneDesktopViewState();
}

class RegistrationPhoneDesktopViewState
    extends State<RegistrationPhoneDesktopView> {
  late RegistrationController _registrationController;

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find<RegistrationController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithMobileImg,
      title: LocalizationHandler.of().registrationWithMobileNumber,
      child: registerMobileWidget(),
    );
  }

  Widget registerMobileWidget() {
    return Column(
      children: [
        AppTextFormField.desktop(
          context: context,
          title: LocalizationHandler.of().enterMobileNumber,
          autoValidateMode: _registrationController.autoValidateModeWeb,
          prefix:
              const CustomSvgImageView(ImageLocalAssets.shareMobileNoIconSvg),
          hintText: LocalizationHandler.of().hintEnterMobileNumber,
          key: const Key(KeyConstant.mobileNumberField),
          textEditingController: _registrationController.mobileTexController,
          textInputType: TextInputType.number,
          maxLength: 10,
          validator: (String? value) {
            return Validator.validateMobileNumber(value);
          },
          onChanged: (value) {
            if (_registrationController.autoValidateModeWeb ==
                AutovalidateMode.disabled) {
              setState(() {
                _registrationController.autoValidateModeWeb =
                    AutovalidateMode.onUserInteraction;
              });
            }
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
                          RegistrationMethod.mobile;
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
