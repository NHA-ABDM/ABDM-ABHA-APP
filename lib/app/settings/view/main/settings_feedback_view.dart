import 'package:abha/app/settings/view/desktop/settings_feedback_desktop_view.dart';
import 'package:abha/app/settings/view/mobile/settings_feedback_mobile_view.dart';
import 'package:abha/export_packages.dart';

class SettingsFeedBackView extends StatefulWidget {
  const SettingsFeedBackView({super.key});

  @override
  SettingsFeedBackViewState createState() => SettingsFeedBackViewState();
}

class SettingsFeedBackViewState extends State<SettingsFeedBackView> {
  late SettingsController _settingsController;

  @override
  void initState() {
    Get.put(SettingsController(SettingsRepoImpl()));

    _settingsController = Get.find<SettingsController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _onFeedbackFormSubmission(
    AppTextController controllerEmailText,
    AppTextController controllerSubjectText,
    AppTextController controllerFeedbackText,
  ) async {
    _settingsController
        .functionHandler(
      function: () => _settingsController.callSendFeedback(
        controllerEmailText.text,
        controllerSubjectText.text,
        controllerFeedbackText.text,
      ),
      successMessage: LocalizationHandler.of().feedback_success_message,
      isLoaderReq: true,
    )
        .then((value) {
      /// if response status is success
      if (_settingsController.responseHandler.status == Status.success) {
        /// Navigate back
        context.navigateBack();
      }
    });
  }

  void closeDialog() {
    CustomDialog.dismissDialog(mContext: context);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().setting_submit_feeback.toTitleCase(),
      // isCenterTitle: false,
      type: SettingsFeedBackView,
      bodyMobile: SettingsFeedBackMobileView(
        onFeedbackFormSubmission: _onFeedbackFormSubmission,
      ),
      bodyDesktop: SettingsFeedBackDesktopView(
        onFeedbackFormSubmission: _onFeedbackFormSubmission,
      ),
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
    );
  }
}
