import 'package:abha/app/profile/view/main/profile_otp_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';

class ProfileMobileUpdateView extends StatefulWidget {
  final bool isDesktopView;

  const ProfileMobileUpdateView({super.key, this.isDesktopView = false});

  @override
  ProfileMobileUpdateViewState createState() => ProfileMobileUpdateViewState();
}

class ProfileMobileUpdateViewState extends State<ProfileMobileUpdateView> {
  late ProfileController _profileController;
  String mobileNumber = '';
  final _mobileTEC = AppTextController();

  @override
  void initState() {
    super.initState();
    _profileController = Get.find<ProfileController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onRegistrationContinueInit() async {
    mobileNumber = _mobileTEC.text;
    if (Validator.isMobileValid(mobileNumber)) {
      await _profileController.functionHandler(
        function: () => _profileController.getEmailMobileOtpGen(mobileNumber),
        isLoaderReq: true,
      );
      if (_profileController.responseHandler.status == Status.success) {
        final arguments = {
          IntentConstant.data: mobileNumber,
          IntentConstant.fromScreen: StringConstants.profileMobileUpdate,
        };
        if (!mounted) return;
        context.navigateBack();
        CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
          mContext: context,
          title: LocalizationHandler.of().updateMobile,
          child: ProfileOtpView(
            arguments: arguments,
            isDesktopView: widget.isDesktopView,
          ),
          height: widget.isDesktopView ? Dimen.d_240 : null,
        );
      }
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidMobile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: loginMobileWidget(),
    );
  }

  Widget loginMobileWidget() {
    return (widget.isDesktopView)
        ? Column(
            children: [
              Form(
                child: AppTextFormField.desktop(
                  context: context,
                  title: LocalizationHandler.of().enterMobileNumber,
                  hintText: LocalizationHandler.of().hintEnterMobileNumber,
                  key: const Key(KeyConstant.mobileNumberField),
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  fontSizeDelta: 5,
                  textEditingController: _mobileTEC,
                  textInputType: TextInputType.number,
                  maxLength: 10,
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
                  onRegistrationContinueInit();
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
                    title: LocalizationHandler.of().enterMobileNumber,
                    hintText: LocalizationHandler.of().hintEnterMobileNumber,
                    key: const Key(KeyConstant.mobileNumberField),
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    fontSizeDelta: 5,
                    textEditingController: _mobileTEC,
                    textInputType: TextInputType.number,
                    maxLength: 10,
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
                          onRegistrationContinueInit();
                        },
                      ).marginOnly(
                        top: Dimen.d_20,
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
