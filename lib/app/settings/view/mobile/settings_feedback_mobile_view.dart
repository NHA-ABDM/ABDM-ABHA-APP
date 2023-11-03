import 'package:abha/export_packages.dart';

class SettingsFeedBackMobileView extends StatefulWidget {
  final void Function(AppTextController, AppTextController, AppTextController)
      onFeedbackFormSubmission;
  const SettingsFeedBackMobileView({
    required this.onFeedbackFormSubmission,
    super.key,
  });

  @override
  SettingsFeedBackMobileViewState createState() =>
      SettingsFeedBackMobileViewState();
}

class SettingsFeedBackMobileViewState
    extends State<SettingsFeedBackMobileView> {
  /// instance variable of SettingsController
  /// instance variable of GlobalKey
  final _formKey = GlobalKey<FormState>();

  /// variable of type AppTextController
  late AppTextController controllerEmailText,
      controllerSubjectText,
      controllerFeedbackText;
  bool _isButtonEnable = false;
  late SettingsController _settingsController;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    /// initialize the instance of SettingsController
    /// call the method
    _settingsController = Get.find<SettingsController>();
    initTextEditingController();

    super.initState();
  }

  /// @Here is the method to initialize the variable of type AppTextController.
  void initTextEditingController() {
    controllerEmailText = AppTextController();
    controllerSubjectText = AppTextController();
    controllerFeedbackText = AppTextController();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _sendFeedbackWidget();
  }

  Widget _sendFeedbackWidget() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocalizationHandler.of().abhaAddress} ',
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorGreyDark1,
              fontWeightDelta: 2,
            ),
          ),
          Text(
            abhaSingleton.getAppData.getAbhaAddress(),
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorBlack,
            ),
          ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_30),
          AppTextFormField.mobile(
            context: context,
            key: const Key(KeyConstant.createPasswordTextField),
            textEditingController: controllerEmailText,
            isRequired: true,
            hintText: LocalizationHandler.of().hintEnterEmailAddress,
            title: LocalizationHandler.of().emailId,
            autoValidateMode: _autoValidateMode,
            onChanged: (value) {
              if (Validator.isEmailValid(value)) {
                _isButtonEnable = true;
              } else {
                _isButtonEnable = false;
              }
              _settingsController.update(
                [UpdateSettingsUiBuilderIds.updateContinueButton],
              );
            },
            validator: (value) {
              if (Validator.isNullOrEmpty(value)) {
                return LocalizationHandler.of().hintEnterYourEmailAddress;
              }
              if (!Validator.isEmailValid(value!)) {
                return LocalizationHandler.of().invalidEmailError;
              }
              return null;
            },
          ).marginOnly(bottom: Dimen.d_20),
          AppTextFormField.mobile(
            context: context,
            key: const Key(KeyConstant.subject),
            textEditingController: controllerSubjectText,
            isRequired: true,
            hintText: LocalizationHandler.of().enterSubject,
            title: LocalizationHandler.of().subject,
            autoValidateMode: _autoValidateMode,
            onChanged: (value) {},
            validator: (value) {
              if (Validator.isNullOrEmpty(value)) {
                return LocalizationHandler.of().enterSubject;
              }
              if (value!.length <= 2) {
                return LocalizationHandler.of().containsMinThreeChar;
              }
              return null;
            },
          ).marginOnly(bottom: Dimen.d_20),
          AppTextFormField.mobile(
            context: context,
            key: const Key(KeyConstant.feedback),
            textEditingController: controllerFeedbackText,
            title: LocalizationHandler.of().feedback,
            isRequired: true,
            hintText: LocalizationHandler.of().enterFeedback,
            maxLines: 5,
            minLines: 1,
            autoValidateMode: _autoValidateMode,
            onChanged: (value) {
              _settingsController.functionHandler(
                isUpdateUi: true,
              );
            },
            validator: (value) {
              if (Validator.isNullOrEmpty(value)) {
                return LocalizationHandler.of().enterFeedback;
              }
              return null;
            },
          ),
          GetBuilder<SettingsController>(
            id: UpdateSettingsUiBuilderIds.updateContinueButton,
            builder: (_) {
              return TextButtonOrange.mobile(
                isButtonEnable: _isButtonEnable,
                text: LocalizationHandler.of().continuee,
                onPressed: () {
                  if (_isButtonEnable) {
                    final isValid = _formKey.currentState?.validate();
                    if (isValid!) {
                      /// On tap of button call the onFeedbackFormSubmission() by passing the
                      /// email, subject, feedback value
                      widget.onFeedbackFormSubmission(
                        controllerEmailText,
                        controllerSubjectText,
                        controllerFeedbackText,
                      );
                    } else {
                      setState(() {
                        _autoValidateMode = AutovalidateMode.always;
                      });
                    }
                  }
                },
              );
            },
          ).marginOnly(top: Dimen.d_30)
        ],
      ),
    ).marginSymmetric(horizontal: Dimen.d_20, vertical: Dimen.d_20);
  }
}
