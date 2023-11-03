import 'package:abha/export_packages.dart';

class LoginAbhaAddressDesktopView extends StatefulWidget {
  final VoidCallback onAbhaAddressLogin;
  final VoidCallback onAbhaAddressEmailMobileOtpLogin;
  final ValueNotifier<bool> isButtonEnable;

  const LoginAbhaAddressDesktopView({
    required this.onAbhaAddressLogin,
    required this.onAbhaAddressEmailMobileOtpLogin,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LoginAbhaAddressDesktopViewState createState() => LoginAbhaAddressDesktopViewState();
}

class LoginAbhaAddressDesktopViewState extends State<LoginAbhaAddressDesktopView> {
  late LoginController _loginController;
  Map configData = abhaSingleton.getAppConfig.getConfigData();

  ABHAValidationMethod get _selectedABHAValidationMethod => _loginController.selectedABHAValidationMethod;

  var key = GlobalKey<FormState>();

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
      title: LocalizationHandler.of().loginAbhaAddress,
      child: _loginAbhaAddressWidget(),
    );
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
    _loginController.update([LoginUpdateUiBuilderIds.updateLoginButton, LoginUpdateUiBuilderIds.radioToggle, LoginUpdateUiBuilderIds.loginMethodToggle]);
  }

  Widget _loginAbhaAddressWidget() {
    return Form(
      key: key,
      autovalidateMode: _loginController.autoValidateMode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextFormField.desktop(
                context: context,
                title: LocalizationHandler.of().abhaAddress,
                key: const Key(KeyConstant.abhaAddressTextField),
                textEditingController: _loginController.abhaAddressTEC,
                autoValidateMode: _loginController.webAutoValidateMode,
                hintText: LocalizationHandler.of().hintEnterAbhaAddress,
                suffix: Text(
                  configData[AppConfig.abhaAddressSuffix],
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    color: AppColors.colorAppBlue,
                  ),
                ),
                onChanged: (_) {
                  if (_loginController.webAutoValidateMode == AutovalidateMode.disabled) {
                    setState(() {
                      _loginController.webAutoValidateMode = AutovalidateMode.onUserInteraction;
                    });
                  }
                  _updateContinueButtonState();
                },
                validator: (value) {
                  if (Validator.isNullOrEmpty(value?.trim())) {
                    return LocalizationHandler.of().errorEnterAbhaAddress;
                  }
                  if (value!.trim().length < 8) {
                    return LocalizationHandler.of().invalidAbhaAddress;
                  }
                  if (Validator.isDotCriteriaMatches(value)) {
                    return LocalizationHandler.of().invalidAbhaAddress;
                  }
                  if (!Validator.isValidAbhaAddressPattern(value)) {
                    return LocalizationHandler.of().invalidAbhaAddress;
                  }
                  return null;
                },
              ),

              Text(
                LocalizationHandler.of().loginAbhaAddressMethod,
                style: InputFieldStyleDesktop.labelTextStyle,
              ).marginOnly(top: Dimen.d_20),

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
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              key: const Key(KeyConstant.radio1),
                              value: ABHAValidationMethod.password,
                              groupValue: _selectedABHAValidationMethod,
                              onChanged: _checkOnValidationTypeClick,
                            ),
                            Text(
                              LocalizationHandler.of().password.capitalizeFirstLetter,
                              style: CustomTextStyle.bodySmall(context)?.apply(),
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
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              key: const Key(KeyConstant.radio2),
                              value: ABHAValidationMethod.otp,
                              groupValue: _selectedABHAValidationMethod,
                              onChanged: _checkOnValidationTypeClick,
                            ),
                            Text(
                              LocalizationHandler.of().otp,
                              style: CustomTextStyle.bodySmall(context)?.apply(),
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
                  return (_selectedABHAValidationMethod == ABHAValidationMethod.password)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextFormField.desktop(
                              context: context,
                              key: const Key(KeyConstant.abhaPasswordTextField),
                              title: LocalizationHandler.of().password.capitalizeFirstLetter,
                              textEditingController: _loginController.abhaPasswordTEC,
                              isPassword: _loginController.obscurePassword,
                              hintText: LocalizationHandler.of().enterPassword,
                              autoValidateMode: _loginController.webAutoValidateMode,
                              onChanged: (_) {
                                if (_loginController.webAutoValidateMode == AutovalidateMode.disabled) {
                                  setState(() {
                                    _loginController.webAutoValidateMode = AutovalidateMode.onUserInteraction;
                                  });
                                }
                                _loginController.selectedValidationMethod = null;
                                _updateContinueButtonState();
                              },
                              validator: (value) {
                                if (Validator.isNullOrEmpty(value)) {
                                  return LocalizationHandler.of().errorEnterYourPassword;
                                }
                                if (!Validator.isPassValid(value!)) {
                                  return LocalizationHandler.of().enterValidPassword;
                                }
                                return null;
                              },
                              suffix: GestureDetector(
                                key: const Key(KeyConstant.showHideIconButton),
                                onTap: () {
                                  setState(() {
                                    _loginController.obscurePassword = !_loginController.obscurePassword;
                                  });
                                },
                                child: Icon(
                                  _loginController.obscurePassword ? IconAssets.openEye : IconAssets.closeEye,
                                ),
                              ),
                            ).marginOnly(top: Dimen.d_20),
                          ],
                        )
                      : Container();
                },
              ),

              /// TO-IMPLEMENT: as this feature is currently not in the app so hiding it for now
              // _rememberMeWidget().alignAtTopLeft(),
              // Text(
              //   LocalizationHandler.of().or.toUpperCase(),
              //   style: CustomTextStyle.bodyMedium(context)
              //       ?.apply(color: AppColors.colorGreyDark2),
              // ).marginOnly(top: Dimen.d_20).centerWidget,

              GetBuilder<LoginController>(
                id: LoginUpdateUiBuilderIds.loginMethodToggle,
                builder: (_) {
                  return (_selectedABHAValidationMethod == ABHAValidationMethod.otp) ? _validateUsingMobileOrEmailOtp() : Container();
                },
              ),
            ],
          ).marginSymmetric(horizontal: Dimen.d_0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: widget.isButtonEnable,
                builder: (context, isButtonEnable, _) {
                  return TextButtonOrange.desktop(
                    text: LocalizationHandler.of().continuee,
                    isButtonEnable: isButtonEnable,
                    onPressed: () {
                      if (isButtonEnable) {
                        if (key.currentState!.validate()) {
                          if (Validator.isNullOrEmpty(
                            _loginController.selectedValidationMethod,
                          )) {
                            _loginController.loginMethod = LoginMethod.address;
                            widget.onAbhaAddressLogin();
                          } else {
                            if (_loginController.selectedValidationMethod == LoginMethod.verifyMobile) {
                              _loginController.loginMethod = LoginMethod.verifyMobile;
                            } else {
                              _loginController.loginMethod = LoginMethod.verifyEmail;
                            }
                            widget.onAbhaAddressEmailMobileOtpLogin();
                          }
                        } else {
                          setState(() {
                            _loginController.autoValidateMode = AutovalidateMode.always;
                          });
                        }
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
              Expanded(
                child: Wrap(
                  children: [
                    Text(
                      '${LocalizationHandler.of().dontHaveABHAAddress} ',
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorBlack6,
                        fontSizeDelta: -2,
                        fontWeightDelta: -1,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.navigateGo(RoutePath.routeRegistration);
                      },
                      child: Text(
                        LocalizationHandler.of().createNow,
                        style: CustomTextStyle.bodySmall(context)?.apply(
                          color: AppColors.colorAppOrange,
                          decoration: TextDecoration.underline,
                          fontWeightDelta: 2,
                          fontSizeDelta: -2,
                        ),
                      ),
                    ),
                  ],
                ).alignAtCenterRight(),
              )
            ],
          ).marginOnly(top: Dimen.d_40),
        ],
      ),
    );
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
              style: InputFieldStyleDesktop.labelTextStyle,
            ),

            /// Icons and Text of Aadhaar Otp and Mobile Otp in [Row] Widget
            rowMobileAndEmailOtpIcon()
          ],
        ).visibilityGone(
          visible: true,
        );
      },
    ).marginOnly(top: Dimen.d_20);
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
                _loginController.selectedValidationMethod = LoginMethod.verifyMobile;
                _loginController.abhaPasswordTEC.text = '';
                _updateContinueButtonState();
              });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _loginController.selectedValidationMethod == LoginMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginMobileNoIconSvg,
          ),
        ),
        Container(
          width: Dimen.d_18,
        ),
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              setState(() {
                _loginController.selectedValidationMethod = LoginMethod.verifyEmail;
                _loginController.abhaPasswordTEC.text = '';
                _updateContinueButtonState();
              });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _loginController.selectedValidationMethod == LoginMethod.verifyEmail,
            text: LocalizationHandler.of().emailOTP,
            icon: ImageLocalAssets.loginEmailIconSvg,
          ).marginOnly(left: Dimen.d_12, right: Dimen.d_3),
        ),
      ],
    ).marginOnly(top: Dimen.d_4);
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
      _loginController.functionHandler(
        isUpdateUi: true,
        updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
      );
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
      _loginController.functionHandler(
        isUpdateUi: true,
        updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
      );
    }
  }
}
