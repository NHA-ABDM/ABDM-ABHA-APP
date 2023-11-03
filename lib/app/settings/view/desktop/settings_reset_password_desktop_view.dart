import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class SettingsResetPasswordDesktopView extends StatefulWidget {
  final void Function(String) onAbhaFormSubmission;

  const SettingsResetPasswordDesktopView({
    required this.onAbhaFormSubmission,
    super.key,
  });

  @override
  SettingsResetPasswordDesktopViewState createState() => SettingsResetPasswordDesktopViewState();
}

class SettingsResetPasswordDesktopViewState extends State<SettingsResetPasswordDesktopView> {
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
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().setting_reset_password.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          CommonBackgroundCard(child: _settingsResetPasswordWidget()),
        ],
      ).marginAll(Dimen.d_20),
      showBackOption: false,
    );
  }

  /// @Here is the _settingsResetPasswordWidget() return the [Form] Widget having [key] property
  /// and [child] property. Child property have the [ListView] widget in which further different
  /// widgets are defined in list.
  Widget _settingsResetPasswordWidget() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().abhaAddress,
            style: InputFieldStyleDesktop.labelTextStyle,
          ),
          Text(
            abhaSingleton.getAppData.getAbhaAddress(),
            style: InputFieldStyleDesktop.inputFieldStyle,
          ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_20),
          AppTextFormField.desktop(
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
              icon: _passwordVisible ? const Icon(IconAssets.closeEye) : const Icon(IconAssets.openEye),
            ),
            onChanged: (value) {
              _settingsController.functionHandler(
                isUpdateUi: true,
                updateUiBuilderIds: [UpdateSettingsUiBuilderIds.passwordValidationHint],
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
          AppTextFormField.desktop(
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
              icon: _confirmPasswordVisible ? const Icon(IconAssets.closeEye) : const Icon(IconAssets.openEye),
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
          ).marginOnly(top: Dimen.d_25),
          GetBuilder<SettingsController>(
            id: UpdateSettingsUiBuilderIds.updateContinueButton,
            builder: (_) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButtonOrange.desktop(
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
                        } else {
                          /// On tap of button call the onAbhaFormSubmission() by passing the
                          /// reset password
                          widget.onAbhaFormSubmission(passwordTEC.text);
                        }
                      }
                    },
                  ).marginOnly(right: Dimen.d_16),
                  TextButtonPurple.desktop(
                    text: LocalizationHandler.of().cancel,
                    onPressed: () {
                      context.navigateBack();
                    },
                  ).marginOnly(right: Dimen.d_16),
                ],
              );
            },
          ).marginOnly(top: Dimen.d_30)
        ],
      ),
    );
  }
}
