import 'package:abha/app/profile/view/main/profile_otp_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';

class ProfileEmailUpdateView extends StatefulWidget {
  final bool isDesktopView;

  const ProfileEmailUpdateView({super.key, this.isDesktopView = false});

  @override
  ProfileEmailUpdateViewState createState() => ProfileEmailUpdateViewState();
}

class ProfileEmailUpdateViewState extends State<ProfileEmailUpdateView> {
  late ProfileController _profileController;
  final _emailTEC = AppTextController();

  @override
  void initState() {
    _profileController = Get.find<ProfileController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// This method is used to update the user's email id.
  /// It first checks if the email is valid using [Validator.isEmailValid]
  /// and then calls below func to update the user's email id.
  /// If the response from below func is successful,
  /// it navigates to [ProfileOtpView] passing arguments like data, fromScreen and sessionId.
  /// If the email is not valid, it shows a toast message using [MessageBar.showToastDialog].
  Future<void> onUpdateEmailClick() async {
    final emailText = _emailTEC.text;

    if (Validator.isEmailValid(emailText)) {
      await _profileController.functionHandler(
        function: () => _profileController.getEmailMobileOtpGen(
          emailText,
          isUpdateEmail: true,
        ),
        isLoaderReq: true,
      );
      if (_profileController.responseHandler.status == Status.success) {
        final arguments = {
          IntentConstant.data: emailText,
          IntentConstant.fromScreen: StringConstants.profileEmailUpdate,
        };
        if (!mounted) return;
        context.navigateBack();
        CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
          mContext: context,
          title: LocalizationHandler.of().updateEmail,
          child: ProfileOtpView(
            arguments: arguments,
            isDesktopView: widget.isDesktopView,
          ),
          height: widget.isDesktopView ? Dimen.d_260 : null,
        );
      }
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: updateEmailWidget(),
    );
  }

  Widget updateEmailWidget() {
    return (widget.isDesktopView)
        ? Column(
            children: [
              Form(
                child: AppTextFormField.desktop(
                  context: context,
                  title: LocalizationHandler.of().enterEmail,
                  hintText: LocalizationHandler.of().hintEnterEmailAddress,
                  key: const Key(KeyConstant.emailIdField),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  textEditingController: _emailTEC,
                  textInputType: TextInputType.emailAddress,
                ),
              ).marginOnly(
                top: Dimen.d_10,
                left: Dimen.d_15,
                right: Dimen.d_15,
              ),
              TextButtonOrange.desktop(
                key: const Key('continueBtn'),
                text: LocalizationHandler.of().continuee,
                onPressed: () {
                  onUpdateEmailClick();
                },
              ).alignAtBottomRight().marginOnly(
                    top: Dimen.d_20,
                    left: Dimen.d_15,
                    right: Dimen.d_15,
                  ),
            ],
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  child: AppTextFormField.mobile(
                    context: context,
                    title: LocalizationHandler.of().enterEmail,
                    hintText: LocalizationHandler.of().hintEnterEmailAddress,
                    key: const Key(KeyConstant.emailIdField),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    textEditingController: _emailTEC,
                    textInputType: TextInputType.emailAddress,
                  ),
                ).marginOnly(
                  top: Dimen.d_20,
                  left: Dimen.d_15,
                  right: Dimen.d_15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButtonOrange.mobile(
                        key: const Key('continueBtn'),
                        text: LocalizationHandler.of().continuee,
                        onPressed: () {
                          onUpdateEmailClick();
                        },
                      ).marginOnly(
                        top: Dimen.d_30,
                        bottom: Dimen.d_30,
                        left: Dimen.d_15,
                        right: Dimen.d_15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}
