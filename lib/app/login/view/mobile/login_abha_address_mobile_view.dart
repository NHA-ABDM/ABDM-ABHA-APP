import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dialog/registration_option_dialog.dart';
import 'package:flutter/foundation.dart';

class LoginAbhaAddressMobileView extends StatefulWidget {
  final VoidCallback onAbhaAddressLogin;
  final VoidCallback onAbhaAddressEmailMobileOtpLogin;
  final ValueNotifier<bool> isButtonEnable;

  const LoginAbhaAddressMobileView({
    required this.onAbhaAddressLogin,
    required this.onAbhaAddressEmailMobileOtpLogin,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginAbhaAddressMobileViewState createState() =>
      LoginAbhaAddressMobileViewState();
}

class LoginAbhaAddressMobileViewState
    extends State<LoginAbhaAddressMobileView> {
  late LoginController _loginController;

  ABHAValidationMethod get _selectedValidationMethod =>
      _loginController.selectedABHAValidationMethod;

  Map configData = abhaSingleton.getAppConfig.getConfigData();

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
    return kIsWeb
        ? MobileWebCardWidget(child: _loginAbhaAddressWidget())
        : SingleChildScrollView(child: _loginAbhaAddressWidget());
  }

  /// @Here is the function updates the UI,
  /// according to selection of authentication modes for otp.
  ///
  /// Param [value] is assign to another variable [_selectedValidationMethod]
  void _checkOnValidationTypeClick(value) {
    _loginController.selectedABHAValidationMethod = value;
    _loginController.selectedValidationMethod = null;
    _loginController.abhaPasswordTEC.text = '';
    widget.isButtonEnable.value = false;
    _loginController.update([
      LoginUpdateUiBuilderIds.updateLoginButton,
      LoginUpdateUiBuilderIds.radioToggle,
      LoginUpdateUiBuilderIds.loginMethodToggle
    ]);
  }

  void _updateContinueButtonState() {
    /// If the [_loginController.selectedValidationMethod] is blank or null irt means user has
    /// selected password as login method
    if (Validator.isNullOrEmpty(_loginController.selectedValidationMethod)) {
      if (Validator.isNullOrEmpty(_loginController.abhaAddressTEC.text) ||
          _loginController.abhaAddressTEC.text.trim().length < 8 ||
          Validator.isDotCriteriaMatches(
            _loginController.abhaAddressTEC.text.trim(),
          ) ||
          !Validator.isValidAbhaAddressPattern(
            _loginController.abhaAddressTEC.text.trim(),
          ) ||
          Validator.isNullOrEmpty(_loginController.abhaPasswordTEC.text) ||
          !Validator.isPassValid(_loginController.abhaPasswordTEC.text)) {
        widget.isButtonEnable.value = false;
      } else {
        widget.isButtonEnable.value = true;
      }
      _loginController.update([LoginUpdateUiBuilderIds.updateLoginButton]);
    } else {
      _loginController.abhaPasswordTEC.text = '';
      // widget.isButtonEnable.value = true;
      if (Validator.isNullOrEmpty(_loginController.abhaAddressTEC.text) ||
          _loginController.abhaAddressTEC.text.trim().length < 8 ||
          Validator.isDotCriteriaMatches(
            _loginController.abhaAddressTEC.text.trim(),
          ) ||
          !Validator.isValidAbhaAddressPattern(
            _loginController.abhaAddressTEC.text.trim(),
          )) {
        widget.isButtonEnable.value = false;
      } else {
        widget.isButtonEnable.value = true;
      }
      _loginController.update([LoginUpdateUiBuilderIds.updateLoginButton]);
    }
  }

  Widget _loginAbhaAddressWidget() {
    return Form(
      key: _loginController.loginFormKey,
      autovalidateMode: _loginController.autoValidateMode,
      child: Column(
        children: [
          if (kIsWeb)
            Text(
              LocalizationHandler.of().loginAbhaAddress,
              style: CustomTextStyle.titleLarge(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 2,
              ),
            ).paddingSymmetric(
              vertical: Dimen.d_20,
              horizontal: Dimen.d_20,
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField.mobile(
                context: context,
                title: LocalizationHandler.of().abhaAddress,
                key: const Key(KeyConstant.abhaAddressTextField),
                textEditingController: _loginController.abhaAddressTEC,
                hintText: LocalizationHandler.of().hintEnterAbhaAddress,
                suffix: Text(
                  configData[AppConfig.abhaAddressSuffix],
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    color: AppColors.colorAppBlue,
                  ),
                ),
                onChanged: (_) {
                  _updateContinueButtonState();
                },
                validator: (value) {
                  if (Validator.isNullOrEmpty(value?.trim())) {
                    return LocalizationHandler.of().errorEnterAbhaAddress;
                  }
                  // if (value!.trim().length < 8) {
                  //   return LocalizationHandler.of().invalidAbhaAddress;
                  // }
                  // if (Validator.isDotCriteriaMatches(value)) {
                  //   return LocalizationHandler.of().invalidAbhaAddress;
                  // }
                  // if (!Validator.isValidAbhaAddressPattern(value)) {
                  //   return LocalizationHandler.of().invalidAbhaAddress;
                  // }
                  return null;
                },
              ).marginOnly(top: Dimen.d_20),
              Text(
                LocalizationHandler.of().loginAbhaAddressMethod,
                style: InputFieldStyleMobile.labelTextStyle,
              ).marginOnly(top: Dimen.d_30, bottom: Dimen.d_4),
              GetBuilder<LoginController>(
                id: LoginUpdateUiBuilderIds.radioToggle,
                builder: (_) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _checkOnValidationTypeClick(
                            ABHAValidationMethod.password,
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<ABHAValidationMethod>(
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              key: const Key(KeyConstant.radio1),
                              value: ABHAValidationMethod.password,
                              groupValue: _selectedValidationMethod,
                              onChanged: _checkOnValidationTypeClick,
                            ),
                            Text(
                              LocalizationHandler.of()
                                  .password
                                  .capitalizeFirstLetter,
                              style:
                                  CustomTextStyle.bodyMedium(context)?.apply(),
                            ).marginOnly(left: Dimen.d_4),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          _checkOnValidationTypeClick(ABHAValidationMethod.otp);
                        },
                        child: Row(
                          children: [
                            Radio<ABHAValidationMethod>(
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              key: const Key(KeyConstant.radio2),
                              value: ABHAValidationMethod.otp,
                              groupValue: _selectedValidationMethod,
                              onChanged: _checkOnValidationTypeClick,
                            ),
                            Text(
                              LocalizationHandler.of().otp,
                              style:
                                  CustomTextStyle.bodyMedium(context)?.apply(),
                            ).marginOnly(left: Dimen.d_4),
                          ],
                        ),
                      ).marginOnly(left: Dimen.d_40),
                    ],
                  ).marginOnly(top: Dimen.d_10);
                },
              ),
              GetBuilder<LoginController>(
                id: LoginUpdateUiBuilderIds.loginMethodToggle,
                builder: (_) {
                  return (_selectedValidationMethod ==
                          ABHAValidationMethod.password)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextFormField.mobile(
                              context: context,
                              key: const Key(KeyConstant.abhaPasswordTextField),
                              title: LocalizationHandler.of()
                                  .password
                                  .capitalizeFirstLetter,
                              textEditingController:
                                  _loginController.abhaPasswordTEC,
                              isPassword: _loginController.obscurePassword,
                              hintText: LocalizationHandler.of().enterPassword,
                              onChanged: (_) {
                                _loginController.selectedValidationMethod =
                                    null;
                                _updateContinueButtonState();
                              },
                              validator: (value) {
                                if (Validator.isNullOrEmpty(value)) {
                                  return LocalizationHandler.of()
                                      .errorEnterYourPassword;
                                }
                                if (!Validator.isPassValid(value!)) {
                                  return LocalizationHandler.of()
                                      .enterValidPassword;
                                }
                                return null;
                              },
                              suffix: GestureDetector(
                                key: const Key(KeyConstant.showHideIconButton),
                                onTap: () {
                                  setState(() {
                                    _loginController.obscurePassword =
                                        !_loginController.obscurePassword;
                                  });
                                },
                                child: Icon(
                                  _loginController.obscurePassword
                                      ? IconAssets.openEye
                                      : IconAssets.closeEye,
                                ),
                              ),
                            ).marginOnly(top: Dimen.d_30),
                          ],
                        )
                      : Container();
                },
              ),
              GetBuilder<LoginController>(
                id: LoginUpdateUiBuilderIds.loginMethodToggle,
                builder: (_) {
                  return (_selectedValidationMethod == ABHAValidationMethod.otp)
                      ? _validateUsingMobileOrEmailOtp()
                      : Container();
                },
              ),
            ],
          ).marginSymmetric(horizontal: Dimen.d_20),

          ValueListenableBuilder<bool>(
            valueListenable: widget.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.mobile(
                text: LocalizationHandler.of().continuee,
                isButtonEnable: isButtonEnable,
                onPressed: () {
                  if (isButtonEnable) {
                    if (_loginController.loginFormKey.currentState!
                        .validate()) {
                      if (Validator.isNullOrEmpty(
                        _loginController.selectedValidationMethod,
                      )) {
                        _loginController.loginMethod = LoginMethod.address;
                        widget.onAbhaAddressLogin();
                      } else {
                        if (_loginController.selectedValidationMethod ==
                            LoginMethod.verifyMobile) {
                          _loginController.loginMethod =
                              LoginMethod.verifyMobile;
                        } else {
                          _loginController.loginMethod =
                              LoginMethod.verifyEmail;
                        }
                        widget.onAbhaAddressEmailMobileOtpLogin();
                      }
                    } else {
                      setState(() {
                        _loginController.autoValidateMode =
                            AutovalidateMode.always;
                      });
                    }
                  }
                },
              ).marginOnly(
                top: Dimen.d_30,
                left: Dimen.d_17,
                right: Dimen.d_17,
              );
            },
          ),

          /// Not having Abha Address text
          _dontHaveAbhaAddress()
        ],
      ),
    ).marginOnly(bottom: Dimen.d_16);
  }

  /// @Here widget to login via Mobile Otp or Email Otp
  Widget _validateUsingMobileOrEmailOtp() {
    return GetBuilder<LoginController>(
      id: LoginUpdateUiBuilderIds.abhaNumberValidator,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationHandler.of().validateUsing,
              style: InputFieldStyleMobile.labelTextStyle,
            ).marginOnly(bottom: Dimen.d_6),

            /// Icons and Text of Aadhaar Otp and Mobile Otp in [Row] Widget
            rowMobileAndEmailOtpIcon()
          ],
        ).visibilityGone(visible: true);
      },
    ).marginOnly(top: Dimen.d_30);
  }

  /// @Here widget to display Icon and text related to Mobile otp and Email otp.
  Widget rowMobileAndEmailOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              setState(() {
                // _loginController.loginMethod = LoginMethod.address;
                _loginController.selectedValidationMethod =
                    LoginMethod.verifyMobile;
                _loginController.abhaPasswordTEC.text = '';
              });
              _updateContinueButtonState();
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _loginController.selectedValidationMethod ==
                LoginMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginMobileNoIconSvg,
          ),
        ),
        SizedBox(
          width: Dimen.d_10,
        ),
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              setState(() {
                _loginController.selectedValidationMethod =
                    LoginMethod.verifyEmail;
                _loginController.abhaPasswordTEC.text = '';
              });
              _updateContinueButtonState();
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _loginController.selectedValidationMethod ==
                LoginMethod.verifyEmail,
            text: LocalizationHandler.of().emailOTP,
            icon: ImageLocalAssets.loginEmailIconSvg,
          ).marginOnly(left: Dimen.d_3, right: Dimen.d_3),
        ),
      ],
    ).marginOnly(top: Dimen.d_0);
  }

  /// Here is the widget for showing text 'don't have Abha Address'.
  /// Also Their is text [Register]
  Widget _dontHaveAbhaAddress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${LocalizationHandler.of().dontHaveABHAAddress} ',
          style: CustomTextStyle.bodyMedium(context)?.apply(
            color: AppColors.colorBlack6,
            fontSizeDelta: -2,
            fontWeightDelta: -1,
          ),
        ),
        InkWell(
          onTap: () {
            if (kIsWeb) {
              context.navigateGo(RoutePath.routeRegistration);
            } else {
              context.navigateBack();
              RegistrationOptionDialog.open(context);
            }
          },
          child: Text(
            LocalizationHandler.of().register,
            style: CustomTextStyle.bodyMedium(context)?.apply(
              color: AppColors.colorAppOrange,
              decoration: TextDecoration.underline,
              fontWeightDelta: 2,
              fontSizeDelta: -2,
            ),
          ),
        ),
      ],
    ).marginOnly(top: Dimen.d_20);
  }
}
