import 'package:abha/export_packages.dart';

class LoginEmailDesktopView extends StatefulWidget {
  final VoidCallback onEmailLoginInit;
  final ValueNotifier<bool> isButtonEnable;

  const LoginEmailDesktopView({
    required this.onEmailLoginInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginEmailDesktopViewState createState() => LoginEmailDesktopViewState();
}

class LoginEmailDesktopViewState extends State<LoginEmailDesktopView> {
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

  void refreshContinueButtonOnChange() {
    _loginController.update([LoginUpdateUiBuilderIds.updateLoginButton]);
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithEmailImg,
      title: LocalizationHandler.of().loginEmailId.toTitleCase(),
      child: _loginEmailWidget(),
    );
  }

  Widget _loginEmailWidget() {
    return Column(
      children: [
        Column(
          children: [
            AppTextFormField.desktop(
              context: context,
              title: LocalizationHandler.of().emailId.toTitleCase(),
              prefix: CustomSvgImageView(
                ImageLocalAssets.shareEmailIconSvg,
                height: Dimen.d_20,
              ),
              textEditingController: _loginController.emailTextController,
              hintText: LocalizationHandler.of().hintEnterEmailAddress,
              onChanged: (value) {
                if (_loginController.webAutoValidateMode ==
                    AutovalidateMode.disabled) {
                  setState(() {
                    _loginController.webAutoValidateMode =
                        AutovalidateMode.onUserInteraction;
                  });
                }
                if (Validator.isEmailValid(value)) {
                  widget.isButtonEnable.value = true;
                  refreshContinueButtonOnChange();
                } else {
                  widget.isButtonEnable.value = false;
                  refreshContinueButtonOnChange();
                }
              },
              autoValidateMode: _loginController.webAutoValidateMode,
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
          ],
        ),
        bottomView()
      ],
    );
  }

  Widget bottomView() {
    return Row(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.desktop(
              text: LocalizationHandler.of().continuee,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                if (widget.isButtonEnable.value) {
                  _loginController.loginMethod = LoginMethod.email;
                  widget.onEmailLoginInit();
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
    ).marginOnly(top: Dimen.d_30);
  }
}
