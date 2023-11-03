import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LoginEmailMobileView extends StatefulWidget {
  final VoidCallback onEmailLoginInit;
  final ValueNotifier<bool> isButtonEnable;

  const LoginEmailMobileView({
    required this.onEmailLoginInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginEmailMobileViewState createState() => LoginEmailMobileViewState();
}

class LoginEmailMobileViewState extends State<LoginEmailMobileView> {
  late LoginController _loginController;

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    super.initState();
  }

  void refreshContinueButtonOnChange() {
    _loginController.update([LoginUpdateUiBuilderIds.updateLoginButton]);
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _loginEmailWidget())
        : SingleChildScrollView(child: _loginEmailWidget());
  }

  Widget _loginEmailWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (kIsWeb)
            Text(
              LocalizationHandler.of().loginEmailId,
              style: CustomTextStyle.titleLarge(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 2,
              ),
            ).paddingSymmetric(
              vertical: Dimen.d_20,
              horizontal: Dimen.d_20,
            ),
          CustomImageView(
            image: ImageLocalAssets.loginWithEmailImg,
            height: context.height * 0.25,
          ).marginOnly(top: Dimen.d_30).centerWidget,
          Form(
            key: const Key(KeyConstant.form),
            child: Column(
              children: [
                AppTextFormField.mobile(
                  context: context,
                  title: LocalizationHandler.of().emailId,
                  prefix: const CustomSvgImageView(
                    ImageLocalAssets.shareEmailIconSvg,
                  ),
                  textEditingController: _loginController.emailTextController,
                  hintText: LocalizationHandler.of().hintEnterEmailAddress,
                  onChanged: (value) {
                    if (Validator.isEmailValid(value)) {
                      widget.isButtonEnable.value = true;
                      refreshContinueButtonOnChange();
                    } else {
                      widget.isButtonEnable.value = false;
                      refreshContinueButtonOnChange();
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
            ),
          ).marginOnly(
            left: Dimen.d_20,
            right: Dimen.d_20,
          ),
          ValueListenableBuilder<bool>(
            valueListenable: widget.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.mobile(
                text: LocalizationHandler.of().continuee,
                isButtonEnable: isButtonEnable,
                onPressed: () {
                  if (widget.isButtonEnable.value) {
                    _loginController.loginMethod = LoginMethod.email;
                    widget.onEmailLoginInit();
                  }
                },
              ).marginOnly(
                top: Dimen.d_30,
                left: Dimen.d_17,
                right: Dimen.d_17,
              );
            },
          )
        ],
      ),
    ).marginOnly(bottom: Dimen.d_16);
  }
}
