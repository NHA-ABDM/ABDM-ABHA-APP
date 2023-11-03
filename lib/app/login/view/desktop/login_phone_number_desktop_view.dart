import 'package:abha/export_packages.dart';

class LoginPhoneNumberDesktopView extends StatefulWidget {
  final VoidCallback onMobileLoginInit;
  final ValueNotifier<bool> isButtonEnable;

  const LoginPhoneNumberDesktopView({
    required this.onMobileLoginInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginPhoneNumberDesktopViewState createState() =>
      LoginPhoneNumberDesktopViewState();
}

class LoginPhoneNumberDesktopViewState
    extends State<LoginPhoneNumberDesktopView> {
  late LoginController _loginController;

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithMobileImg,
      title: LocalizationHandler.of().loginWithMobileNumber.toTitleCase(),
      child: _loginMobileWidget(),
    );
  }

  Widget _loginMobileWidget() {
    return Column(
      children: [
        Form(
          key: const Key(KeyConstant.form),
          child: Column(
            children: [
              AppTextFormField.desktop(
                context: context,
                autoValidateMode: _loginController.webAutoValidateMode,
                title: LocalizationHandler.of().enterMobileNumber,
                prefix: SvgPicture.asset(ImageLocalAssets.shareMobileNoIconSvg),
                key: const Key(KeyConstant.mobileNumberField),
                textEditingController: _loginController.mobileTextController,
                hintText: LocalizationHandler.of().hintEnterMobileNumber,
                textInputType: TextInputType.number,
                maxLength: 10,
                validator: (String? value) {
                  return Validator.validateMobileNumber(value);
                },
                onChanged: (value) {
                  if (_loginController.webAutoValidateMode ==
                      AutovalidateMode.disabled) {
                    setState(() {
                      _loginController.webAutoValidateMode =
                          AutovalidateMode.onUserInteraction;
                    });
                  }
                  if (value.length == 10) {
                    widget.isButtonEnable.value = true;
                    _loginController.functionHandler(
                      isUpdateUi: true,
                      updateUiBuilderIds: [
                        LoginUpdateUiBuilderIds.updateLoginButton
                      ],
                    );
                  } else {
                    widget.isButtonEnable.value = false;
                    _loginController.functionHandler(
                      isUpdateUi: true,
                      updateUiBuilderIds: [
                        LoginUpdateUiBuilderIds.updateLoginButton
                      ],
                    );
                  }
                },
              ).marginOnly(top: Dimen.d_10),
            ],
          ),
        ),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: widget.isButtonEnable,
              builder: (context, isButtonEnable, _) {
                return TextButtonOrange.desktop(
                  text: LocalizationHandler.of().continuee,
                  isButtonEnable: isButtonEnable,
                  onPressed: () {
                    if (widget.isButtonEnable.value) {
                      _loginController.loginMethod = LoginMethod.mobile;
                      widget.onMobileLoginInit();
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
            ),
          ],
        ).marginOnly(top: Dimen.d_30)
      ],
    );
  }
}
