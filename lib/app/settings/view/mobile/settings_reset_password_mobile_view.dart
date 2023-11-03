import 'package:abha/export_packages.dart';

class SettingsResetPasswordMobileView extends StatefulWidget {
  final void Function(String) onAbhaFormSubmission;

  const SettingsResetPasswordMobileView({
    required this.onAbhaFormSubmission,
    super.key,
  });

  @override
  SettingsResetPasswordMobileViewState createState() =>
      SettingsResetPasswordMobileViewState();
}

class SettingsResetPasswordMobileViewState
    extends State<SettingsResetPasswordMobileView> {
  /// instance variable of SettingsController
  late SettingsController _settingsController;

  /// instance variable of GlobalKey
  final _formKey = GlobalKey<FormState>();

  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  /// variable of type AppTextController
  late AppTextController passwordTEC, confirmPasswordTEC;

  /// variable of type boolean initialize to false
  bool _passwordVisible = false;

  bool _confirmPasswordVisible = false;

  /// variable of type boolean initialize to false
  bool _passwordHintVisible = false;

  bool _isShowEnable = false;

  @override
  void initState() {
    super.initState();

    /// initialize the instance of SettingsController
    _settingsController = Get.find<SettingsController>();

    /// call the method
    initTextEditingController();
  }

  /// @Here is the method to initialize the variable of type AppTextController.
  void initTextEditingController() {
    passwordTEC = AppTextController();
    confirmPasswordTEC = AppTextController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _settingsResetPasswordWidget();
  }

  /// @Here is the _settingsResetPasswordWidget() return the [Form] Widget having [key] property
  /// and [child] property. Child property have the [ListView] widget in which further different
  /// widgets are defined in list.
  Widget _settingsResetPasswordWidget() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: ListView(
        shrinkWrap: true,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: Dimen.d_10,
                ),
                Text(
                  '${LocalizationHandler.of().abhaAddress} ',
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    color: AppColors.colorGreyDark1,
                    // fontWeightDelta: 2,
                  ),
                ).paddingOnly(top: Dimen.d_10),
                Text(
                  abhaSingleton.getAppData.getAbhaAddress(),
                  style: CustomTextStyle.bodyLarge(context)?.apply(
                    color: AppColors.colorBlack6,
                    fontWeightDelta: 2,
                  ),
                ).paddingOnly(top: Dimen.d_5, bottom: Dimen.d_24),
                AppTextFormField.mobile(
                  context: context,
                  title: LocalizationHandler.of().create_password,
                  key: const Key(KeyConstant.createPasswordTextField),
                  hintText: LocalizationHandler.of().enterPassword,
                  info: LocalizationHandler.of().password_validation_hint,
                  textEditingController: passwordTEC,
                  isPassword: !_passwordVisible,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                    icon: _passwordVisible
                        ? const Icon(IconAssets.closeEye)
                        : const Icon(IconAssets.openEye),
                  ),
                  onChanged: (value) {
                    _passwordHintVisible = (!Validator.isNullOrEmpty(value) &&
                            !Validator.isPassValid(value))
                        ? true
                        : false;
                    _settingsController.functionHandler(
                      isUpdateUi: true,
                      updateUiBuilderIds: [
                        UpdateSettingsUiBuilderIds.passwordValidationHint
                      ],
                    );

                    if (!Validator.isNullOrEmpty(value)) {
                      _isShowEnable = true;
                    } else {
                      _isShowEnable = false;
                    }
                    _settingsController.update(
                      [UpdateSettingsUiBuilderIds.updateContinueButton],
                    );
                  },
                  validator: (value) {
                    if (Validator.isNullOrEmpty(value)) {
                      return LocalizationHandler.of().enterPassword;
                    }
                    if (!Validator.isPassValid(value!)) {
                      return LocalizationHandler.of().invalidPass;
                    }
                    return null;
                  },
                ),
                AppTextFormField.mobile(
                  context: context,
                  title: LocalizationHandler.of().confirm_password,
                  key: const Key(KeyConstant.confirmPasswordTextField),
                  textEditingController: confirmPasswordTEC,
                  isPassword: !_confirmPasswordVisible,
                  hintText: LocalizationHandler.of().enterConfirmPass,
                  suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        _confirmPasswordVisible = !_confirmPasswordVisible;
                      });
                    },
                    icon: _confirmPasswordVisible
                        ? const Icon(IconAssets.closeEye)
                        : const Icon(IconAssets.openEye),
                  ),
                  validator: (value) {
                    if (Validator.isNullOrEmpty(value)) {
                      return LocalizationHandler.of().enterConfirmPass;
                    }
                    if (!Validator.isPassValid(value!)) {
                      return LocalizationHandler.of().invalidConfirmPassword;
                    }
                    if (value != passwordTEC.text) {
                      return LocalizationHandler.of().doNotMatchConfirmPassword;
                    }
                    return null;
                  },
                ).marginOnly(top: Dimen.d_20),
              ],
            ),
          ),
          GetBuilder<SettingsController>(
            id: UpdateSettingsUiBuilderIds.updateContinueButton,
            builder: (_) {
              return TextButtonOrange.mobile(
                key: const Key(KeyConstant.continueBtn),
                isButtonEnable: _isShowEnable,
                text: LocalizationHandler.of().continuee,
                onPressed: () {
                  if (_isShowEnable) {
                    final isValid = _formKey.currentState?.validate();
                    if (!isValid!) {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.always;
                      });
                      // return;
                    } else {
                      /// On tap of button call the onAbhaFormSubmission() by passing the
                      /// reset password
                      widget.onAbhaFormSubmission(passwordTEC.text);
                    }
                  }
                },
              ).marginOnly(top: Dimen.d_50, bottom: Dimen.d_25);
            },
          )
        ],
      ),
    ).marginSymmetric(horizontal: Dimen.d_20);
  }
}
