import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LoginPhoneNumberMobileView extends StatefulWidget {
  final VoidCallback onMobileLoginInit;
  final ValueNotifier<bool> isButtonEnable;

  const LoginPhoneNumberMobileView({
    required this.onMobileLoginInit,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginPhoneNumberMobileViewState createState() =>
      LoginPhoneNumberMobileViewState();
}

class LoginPhoneNumberMobileViewState
    extends State<LoginPhoneNumberMobileView> {
  late LoginController _loginController;

  @override
  void initState() {
    _loginController = Get.find<LoginController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _loginMobileWidget())
        : SingleChildScrollView(child: _loginMobileWidget());
  }

  Widget _loginMobileWidget() {
    return Column(
      children: [
        if (kIsWeb)
          Text(
            LocalizationHandler.of().loginWithMobileNumber.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20),
        CustomImageView(
          image: ImageLocalAssets.loginWithMobileImg,
          height: context.height * 0.25,
        ).marginOnly(top: Dimen.d_30).centerWidget,
        Form(
          key: const Key(KeyConstant.form),
          child: Column(
            children: [
              AppTextFormField.mobile(
                context: context,
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
              ).marginOnly(top: Dimen.d_30),
            ],
          ),
        ).marginOnly(left: Dimen.d_17, right: Dimen.d_17),
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              text: LocalizationHandler.of().continuee,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                if (widget.isButtonEnable.value) {
                  _loginController.loginMethod = LoginMethod.mobile;
                  widget.onMobileLoginInit();
                }
              },
            ).marginOnly(
              top: Dimen.d_50,
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
