import 'package:abha/export_packages.dart';

class LoginAbhaNumberDesktopView extends StatefulWidget {
  final VoidCallback onAbhaNumberAuthInit;

  const LoginAbhaNumberDesktopView({
    required this.onAbhaNumberAuthInit,
    super.key,
  });

  @override
  LoginAbhaNumberDesktopViewState createState() =>
      LoginAbhaNumberDesktopViewState();
}

class LoginAbhaNumberDesktopViewState
    extends State<LoginAbhaNumberDesktopView> {
  late LoginController _loginController;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() {
    _loginController = Get.find<LoginController>();
    _loginController.abhaNumberTEC.text = '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// This method is used to check the validation type when clicked.
  ///
  /// It checks if the value contains Aadhaar OTP and sets the login method to [LoginMethod.verifyAadhaar] or [LoginMethod.verifyMobile] accordingly.
  /// It also updates the selected validation method and calls [_loginController.functionHandler] with [isUpdateUi] set to true and [updateUiBuilderIds] set to [LoginUpdateUiBuilderIds.abhaNumberValidator].
  ///
  /// @param value The value of the clicked validation type.
  void checkOnValidationTypeClick(value) {
    if (value.toString().contains(LoginMethod.verifyAadhaar.name)) {
      _loginController.loginMethod = LoginMethod.verifyAadhaar;
    } else {
      _loginController.loginMethod = LoginMethod.verifyAbhaMobileOtp;
    }
    _loginController.selectedValidationMethod = value;
    setState(() {

    });
    // _loginController.update([LoginUpdateUiBuilderIds.abhaNumberValidator]);
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithAbhaNoImg,
      title: LocalizationHandler.of().loginAbhaNumber,
      child: loginAbhaNumberWidget(),
    );
  }

  Widget loginAbhaNumberWidget() {

    return GetBuilder<LoginController>(
      // id: LoginUpdateUiBuilderIds.abhaNumberValidator,
      builder: (_) {
        return Column(
          children: [
            _formFieldForAbhaNumber(),
            _validateUsingAadhaarOrMobileOtp(),
            _actionWidgets()
          ],
        );
      },
    );

  }

  Widget _formFieldForAbhaNumber() {
    return AppTextFormField.desktop(
      context: context,
      key: const Key(KeyConstant.abhaNumberTextField),
      title: LocalizationHandler.of().abhaNumber,
      hintText: LocalizationHandler.of().hintEnterAbhaNumber,
      autoValidateMode: _loginController.webAutoValidateMode,
      textEditingController: _loginController.abhaNumberTEC,
      textInputType: TextInputType.number,
      onChanged: (value) {
        if (_loginController.webAutoValidateMode == AutovalidateMode.disabled) {
          setState(() {
            _loginController.webAutoValidateMode =
                AutovalidateMode.onUserInteraction;
          });
        }
        value = value.replaceAll('-', '');
        if (value.length == 14) {
          _loginController.isShowEnable = true;
          if(mounted){
            setState(() {

            });
          }
          // _loginController.functionHandler(
          //   isUpdateUi: true,
          //   // updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
          // );
        } else {
          _loginController.isShowEnable = false;
          if(mounted){
            setState(() {

            });
          }
          // _loginController.functionHandler(
          //   isUpdateUi: true,
          //   // updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
          // );
        }
      },
      validator: (value) {
        if (Validator.isNullOrEmpty(value)) {
          return LocalizationHandler.of().errorEnterAbhaNumber;
        }
        if (!Validator.isAbhaNumberWithDashValid(value!)) {
          return LocalizationHandler.of().invalidAbhaNumber;
        }
        return null;
      },
    ).alignAtTopLeft();
  }

  Widget _validateUsingAadhaarOrMobileOtp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationHandler.of().validateUsing,
          style: InputFieldStyleDesktop.labelTextStyle,
        ),

        /// Icons and Text of Adhaar Otp and Mobile Otp in [Row] Widget
        rowAadhaarAndMobileOtpIcon(),
      ],
    ).marginOnly(top: Dimen.d_20);
  }

  /// Here is the widget to select  icon for aadhaar and mobile otp type.
  /// It contains the Aadhaar otp and Mobile otp Icon and text Widget.
  Widget rowAadhaarAndMobileOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              checkOnValidationTypeClick(
                LoginMethod.verifyAadhaar,
              );
            },
            isSelected: _loginController.selectedValidationMethod ==
                LoginMethod.verifyAadhaar,
            text: LocalizationHandler.of().aadhaarOtp,
            icon: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
          ),
        ),
        SizedBox(
          width: Dimen.d_10,
        ),
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              checkOnValidationTypeClick(
                LoginMethod.verifyMobile,
              );
            },
            isSelected: _loginController.selectedValidationMethod ==
                LoginMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginMobileNoIconSvg,
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
          ),
        ),
      ],
    ).marginOnly(top: Dimen.d_4);
  }

  Widget _actionWidgets() {
    return Row(
      children: [
        TextButtonOrange.desktop(
          text: LocalizationHandler.of().continuee,
          isButtonEnable: _loginController.isShowEnable,
          onPressed: () {
            if (_loginController.isShowEnable) {
              widget.onAbhaNumberAuthInit();
            }
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
                '${LocalizationHandler.of().dontHaveABHANumber} ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack6,
                  fontSizeDelta: -2,
                  fontWeightDelta: -1,
                ),
              ),
              InkWell(
                onTap: () {
                  CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
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
    ).marginOnly(top: Dimen.d_20);
  }
}
