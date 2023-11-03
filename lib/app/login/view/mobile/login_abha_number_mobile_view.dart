import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/validate_using_option_view.dart';
import 'package:flutter/foundation.dart';

class LoginAbhaNumberMobileView extends StatefulWidget {
  final VoidCallback onAbhaNumberAuthInit;

  const LoginAbhaNumberMobileView({
    required this.onAbhaNumberAuthInit,
    super.key,
  });

  @override
  LoginAbhaNumberMobileViewState createState() =>
      LoginAbhaNumberMobileViewState();
}

class LoginAbhaNumberMobileViewState extends State<LoginAbhaNumberMobileView> {
  late LoginController _loginController;

  final borderDecoration = abhaSingleton.getBorderDecoration;
  late List<String> textAadhaarMobileOtpType;
  late List<String> iconsAadhaarMobileOtpType;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    _loginController = Get.find<LoginController>();
  }

  /// This method is used to check the validation type when clicked.
  ///
  /// It checks if the value contains Aadhaar OTP and sets the login method to [LoginMethod.verifyAadhaar] or [LoginMethod.verifyMobile] accordingly.
  /// It also updates the selected validation method and calls [_loginController.functionHandler] with [isUpdateUi] set to true and [updateUiBuilderIds] set to [LoginUpdateUiBuilderIds.abhaNumberValidator].
  ///
  /// @param value The value of the clicked validation type.
  void checkOnValidationTypeClick(value) {
    if (value == LoginMethod.verifyAadhaar) {
      _loginController.loginMethod = LoginMethod.verifyAadhaar;
    } else {
      _loginController.loginMethod = LoginMethod.verifyAbhaMobileOtp;
    }
    _loginController.selectedValidationMethod = value;
    _loginController.update([LoginUpdateUiBuilderIds.abhaNumberValidator]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _loginAbhaNumberWidget())
        : SingleChildScrollView(child: _loginAbhaNumberWidget());
  }

  Widget _loginAbhaNumberWidget() {
    return Column(
      children: [
        if (kIsWeb)
          Text(
            LocalizationHandler.of().loginAbhaNumber,
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).paddingSymmetric(
            vertical: Dimen.d_20,
            horizontal: Dimen.d_20,
          ),

        Column(
          children: [
            /// Form Field for Abha Number
            _formFieldForAbhaNumber().marginOnly(top: Dimen.d_20),

            /// forgot Abha Number Text Widget
            // _forgotAbhaNumber(),
            // Text(
            //   LocalizationHandler.of().year_of_birth,
            //   style: CustomTextStyle.titleMedium(context)?.apply(
            //     fontSizeDelta: -1,
            //     color: AppColors.colorGreyDark,
            //   ),
            // ).alignAtTopLeft().marginOnly(top: Dimen.d_30),
            //
            // /// Select the year from Picker
            // _selectTheYearOfBirth(),

            /// Validate Using Aadhaar Otp or Mobile Otp
            _validateUsingAadhaarOrMobileOtp(),
          ],
        ).marginSymmetric(horizontal: Dimen.d_20),

        /// button Continue
        _buttonContinue(),

        /// do not have account
        _doNotHavingAccount()
      ],
    );
  }

  Widget _formFieldForAbhaNumber() {
    return AppTextFormField.mobile(
      context: context,
      key: const Key(KeyConstant.abhaNumberTextField),
      title: LocalizationHandler.of().abhaNumber,
      hintText: LocalizationHandler.of().hintEnterAbhaNumber,
      textEditingController: _loginController.abhaNumberTEC,
      textInputType: TextInputType.number,
      onChanged: (value) {
        value = value.replaceAll('-', '');
        if (value.length == 14) {
          _loginController.isShowEnable = true;
          _loginController.functionHandler(
            isUpdateUi: true,
            updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
          );
        } else {
          _loginController.isShowEnable = false;
          _loginController.functionHandler(
            isUpdateUi: true,
            updateUiBuilderIds: [LoginUpdateUiBuilderIds.updateLoginButton],
          );
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
    );
  }

  Widget _validateUsingAadhaarOrMobileOtp() {
    return GetBuilder<LoginController>(
      id: LoginUpdateUiBuilderIds.abhaNumberValidator,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationHandler.of().validateUsing,
              style: InputFieldStyleMobile.labelTextStyle,
            ),

            /// Icons and Text of Aadhaar Otp and Mobile Otp in [Row] Widget
            rowAadhaarAndMobileOtpIcon(),
          ],
        );
      },
    ).marginOnly(top: Dimen.d_30);
  }

  /// Here is the widget to select  icon for adhaar and mobile otp type.
  /// It contains the Aadhaar otp and Mobile otp Icon and text Widget.
  Widget rowAadhaarAndMobileOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ValidateUsingOptionView(
            onClick: () {
              checkOnValidationTypeClick(
                LoginMethod.verifyAadhaar,
              );
            },
            selectedValidationMethod:
                _loginController.selectedValidationMethod ==
                    LoginMethod.verifyAadhaar,
            text: LocalizationHandler.of().aadhaarOtp,
            icon: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
          ),
        ),
        SizedBox(width: Dimen.d_10),
        Expanded(
          child: ValidateUsingOptionView(
            onClick: () {
              checkOnValidationTypeClick(
                LoginMethod.verifyAbhaMobileOtp,
              );
            },
            selectedValidationMethod:
                _loginController.selectedValidationMethod ==
                    LoginMethod.verifyAbhaMobileOtp,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginMobileNoIconSvg,
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
          ),
        ),
      ],
    ).marginOnly(top: Dimen.d_6);
  }

  void performClickForLoginOperation(int index) {
    if (index == 0) {
      context.navigatePush(RoutePath.routeLoginMobile);
    } else if (index == 1) {
      context.navigatePush(RoutePath.routeLoginAbhaAddress);
    }
  }

  // Widget _forgotAbhaNumber() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: [
  //       InkWell(
  //         key: const Key(KeyConstant.forgotABHANumberTxt),
  //         onTap: () {
  //           Map configData = abhaSingleton.getAppConfig.getConfigData();
  //           _loginController.launchURLService.openInAppWebView(
  //             context,
  //             title: configData[AppConfig.appName],
  //             url: '${configData[AppConfig.abhaIdUrl]}/login/recovery',
  //           );
  //         },
  //         child: Text(
  //           '${LocalizationHandler.of().forgotABHANumber} ?',
  //           style: CustomTextStyle.bodySmall(context)?.apply(
  //             color: AppColors.colorBlueDark1,
  //             fontSizeDelta: -2,
  //             fontWeightDelta: 1,
  //             decoration: TextDecoration.underline,
  //           ),
  //         ),
  //       ),
  //     ],
  //   ).marginOnly(right: Dimen.d_15, top: Dimen.d_10);
  // }

  Widget _buttonContinue() {
    return GetBuilder<LoginController>(
      id: LoginUpdateUiBuilderIds.updateLoginButton,
      builder: (_) {
        return TextButtonOrange.mobile(
          text: LocalizationHandler.of().continuee,
          isButtonEnable: _loginController.isShowEnable,
          onPressed: () {
            if (_loginController.isShowEnable) {
              widget.onAbhaNumberAuthInit();
            }
          },
        ).marginOnly(
          top: Dimen.d_50,
          left: Dimen.d_17,
          right: Dimen.d_17,
        );
      },
    );
  }

  /// Here is the widget for don't have an account
  Widget _doNotHavingAccount() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '( ${LocalizationHandler.of().dontHaveABHANumber} ',
          style: CustomTextStyle.bodyMedium(context)?.apply(
            color: AppColors.colorBlack6,
            fontSizeDelta: -2,
            fontWeightDelta: -1,
          ),
        ),
        InkWell(
          onTap: () {
            if (kIsWeb) {
              CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
            } else {
              context.navigatePush(RoutePath.routeAbhaNumber);
            }
          },
          child: Text(
            LocalizationHandler.of().createNow,
            style: CustomTextStyle.bodyMedium(context)?.apply(
              color: AppColors.colorAppOrange,
              decoration: TextDecoration.underline,
              fontWeightDelta: 2,
              fontSizeDelta: -2,
            ),
          ),
        ),
        Text(
          ')',
          style: CustomTextStyle.bodyMedium(context)?.apply(
            color: AppColors.colorBlack6,
            fontSizeDelta: -2,
            fontWeightDelta: -1,
          ),
        )
      ],
    ).marginOnly(
      top: Dimen.d_20,
      bottom: Dimen.d_20,
    );
  }
}
