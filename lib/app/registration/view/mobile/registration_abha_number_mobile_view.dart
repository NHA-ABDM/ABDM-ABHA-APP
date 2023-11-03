import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/validate_using_option_view.dart';
import 'package:flutter/foundation.dart';

class RegistrationAbhaNumberMobileView extends StatefulWidget {
  final VoidCallback onRegistrationContinueInit;
  final Function(RegistrationMethod value) checkOnValidationTypeClick;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationAbhaNumberMobileView({
    required this.onRegistrationContinueInit,
    required this.checkOnValidationTypeClick,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationAbhaNumberMobileViewState createState() =>
      RegistrationAbhaNumberMobileViewState();
}

class RegistrationAbhaNumberMobileViewState
    extends State<RegistrationAbhaNumberMobileView> {
  late RegistrationController _registrationController;

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: kIsWeb
          ? MobileWebCardWidget(child: registrationAbhaWidget())
          : SingleChildScrollView(child: registrationAbhaWidget()),
    );
  }

  Widget registrationAbhaWidget() {
    return GetBuilder<RegistrationController>(
      builder: (_) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  /// form widget to register with abha number
                  _formWidgetToRegisterWithAbhaNumber().marginOnly(
                    top: Dimen.d_30,
                  ),

                  /// forgot abha number text
                  _forgotAbhaNumber(),

                  /// validate using widget
                  _validateUsingAdhaarOrMobileOtp(),
                ],
              ).marginSymmetric(horizontal: Dimen.d_20),
              _buttonContinue(),
              _donotHavignAccount(),
            ],
          ),
        );
      },
    );
  }

  Widget _buttonContinue() {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isButtonEnable,
      builder: (context, isButtonEnable, _) {
        return TextButtonOrange.mobile(
          key: const Key(KeyConstant.continueBtn),
          text: LocalizationHandler.of().continuee,
          isButtonEnable: isButtonEnable,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (isButtonEnable) {
              /*if (_registrationController.isAuthModeFetched) {
                    widget.onRegistrationContinueInit();
                  } else {
                    _registrationController.registrationMethod =
                        RegistrationMethod.abhaNumber;
                    widget.onAbhaSearchAuthMode();
                  }*/
              widget.onRegistrationContinueInit();
            }
          },
        ).marginOnly(
          top: Dimen.d_30,
          left: Dimen.d_17,
          right: Dimen.d_17,
        );
      },
    );
  }

  Widget _validateUsingAdhaarOrMobileOtp() {
    return GetBuilder<RegistrationController>(
      id: RegistrationUpdateUiBuilderIds.abhaNumberValidator,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationHandler.of().validateUsing,
              style: InputFieldStyleMobile.labelTextStyle,
            ),

            /// Icons and Text of Adhaar Otp and Mobile Otp in [Row] Widget
            rowAdhaarAndMobileOtpIcon()
          ],
        ).marginOnly(top: Dimen.d_40);
      },
    );
  }

  /// Here is the widget to select  icon for validating with adhaar and mobile otp type.
  /// It contains the Adhaar otp and Mobile otp Icon and text Widget.
  Widget rowAdhaarAndMobileOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ValidateUsingOptionView(
            onClick: () {
              widget
                  .checkOnValidationTypeClick(RegistrationMethod.verifyAadhaar);
              checkAndEnableButton();
            },
            selectedValidationMethod:
                _registrationController.selectedValidationMethod ==
                    RegistrationMethod.verifyAadhaar,
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
          child: ValidateUsingOptionView(
            onClick: () {
              widget
                  .checkOnValidationTypeClick(RegistrationMethod.verifyMobile);
              checkAndEnableButton();
            },
            selectedValidationMethod:
                _registrationController.selectedValidationMethod ==
                    RegistrationMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginMobileNoIconSvg,
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
          ),
        ),
      ],
    ).marginOnly(top: Dimen.d_6);
  }

  Widget _forgotAbhaNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          key: const Key(KeyConstant.forgotABHANumberTxt),
          onTap: () {
            if (kIsWeb) {
              // Redirect to the Web url after the click on forget abha number
              _registrationController.forgetAbhaNumberViaWebUrl(context);
            } else {
              context.navigatePush(
                RoutePath.routeAbhaNumberForget,
              );
            }
          },
          child: Text(
            '${LocalizationHandler.of().forgotABHANumber}?',
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorAppOrange,
              decoration: TextDecoration.underline,
              fontFamily: 'Roboto_Medium',
              fontWeightDelta: 1,
            ),
          ),
        ),
      ],
    ).marginOnly(top: Dimen.d_20);
  }

  Widget _formWidgetToRegisterWithAbhaNumber() {
    return AppTextFormField.mobile(
      context: context,
      title: LocalizationHandler.of().abhaNumber,
      key: const Key(KeyConstant.abhaNumberTextField),
      textEditingController: _registrationController.abhaNumberTextController,
      hintText: LocalizationHandler.of().hintEnterAbhaNumber,
      fontSizeDelta: 4,
      textInputType: TextInputType.number,
      onChanged: (value) {
        checkAndEnableButton();
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

  /// Here is the widget for don't have an account
  Widget _donotHavignAccount() {
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
    ).marginOnly(top: Dimen.d_20, bottom: Dimen.d_30);
  }

  void checkAndEnableButton() {
    String? value =
        _registrationController.abhaNumberTextController.text.trim();
    value = value.replaceAll('-', '');

    if (value.length == 14 &&
        !Validator.isNullOrEmpty(
          _registrationController.selectedValidationMethod,
        )) {
      widget.isButtonEnable.value = true;
      _registrationController.functionHandler(
        isUpdateUi: true,
        updateUiBuilderIds: [UpdateAddressSelectUiBuilderIds.updateLoginButton],
      );
    } else {
      widget.isButtonEnable.value = false;
      _registrationController.functionHandler(
        isUpdateUi: true,
        updateUiBuilderIds: [UpdateAddressSelectUiBuilderIds.updateLoginButton],
      );
    }
  }
}
