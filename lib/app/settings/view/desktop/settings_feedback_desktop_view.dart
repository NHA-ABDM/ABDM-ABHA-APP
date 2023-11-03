import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class SettingsFeedBackDesktopView extends StatefulWidget {
  final void Function(AppTextController, AppTextController, AppTextController)
      onFeedbackFormSubmission;

  const SettingsFeedBackDesktopView({
    required this.onFeedbackFormSubmission,
    super.key,
  });

  @override
  SettingsFeedBackDesktopViewState createState() =>
      SettingsFeedBackDesktopViewState();
}

class SettingsFeedBackDesktopViewState
    extends State<SettingsFeedBackDesktopView> {
  /// instance variable of SettingsController
  late SettingsController _settingsController;

  /// instance variable of GlobalKey
  final _formKey = GlobalKey<FormState>();

  /// variable of type AppTextController
  late AppTextController controllerEmailText,
      controllerSubjectText,
      controllerFeedbackText;

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
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().setting_submit_feeback.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          CommonBackgroundCard(child: _sendFeedbackWidget()),
        ],
      ).marginAll(Dimen.d_20),
      showBackOption: false,
    );
  }

  Widget _sendFeedbackWidget() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().abhaAddress,
            style:InputFieldStyleDesktop.labelTextStyle,
          ),
          Text(
            abhaSingleton.getAppData.getAbhaAddress(),
            style: InputFieldStyleDesktop.inputFieldStyle,
          ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_20),
          AppTextFormField.desktop(
            context: context,
            key: const Key(KeyConstant.createPasswordTextField),
            textEditingController: controllerEmailText,
            isRequired: true,
            hintText: LocalizationHandler.of().hintEnterEmailAddress,
            title: LocalizationHandler.of().emailId,
            onChanged: (value) {
              if (Validator.isEmailValid(value)) {
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
                return LocalizationHandler.of().errorEnterEmailAddress;
              }
              if (!Validator.isEmailValid(value!)) {
                return LocalizationHandler.of().invalidEmailError;
              }
              return null;
            },
          ).marginOnly(bottom: Dimen.d_20),
          AppTextFormField.desktop(
            context: context,
            key: const Key(KeyConstant.subject),
            textEditingController: controllerSubjectText,
            isRequired: true,
            hintText: LocalizationHandler.of().enterSubject,
            title: LocalizationHandler.of().subject,
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
          AppTextFormField.desktop(
            context: context,
            key: const Key(KeyConstant.feedback),
            textEditingController: controllerFeedbackText,
            title: LocalizationHandler.of().feedback,
            isRequired: true,
            hintText: LocalizationHandler.of().enterFeedback,
            // textInputAction: TextInputAction.newline,
            maxLines: 5,
            minLines: 1,
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
                          return;
                        }

                        /// On tap of button call the onFeedbackFormSubmission() by passing the
                        /// email, subject, feedback value
                        widget.onFeedbackFormSubmission(
                          controllerEmailText,
                          controllerSubjectText,
                          controllerFeedbackText,
                        );
                      }
                    },
                  ).marginOnly(right: Dimen.d_16),
                  TextButtonPurple.desktop(
                    text: LocalizationHandler.of().cancel,
                    onPressed: () {
                      context.navigateBack();
                    },
                  ),
                ],
              );
            },
          ).marginOnly(top: Dimen.d_30)
        ],
      ),
    );
  }
}
