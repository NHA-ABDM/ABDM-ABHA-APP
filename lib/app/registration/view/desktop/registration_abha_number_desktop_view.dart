import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/validate_using_option_view.dart';

class RegistrationAbhaNumberDesktopView extends StatefulWidget {
  final VoidCallback onRegistrationContinueInit;
  final Function(RegistrationMethod value) checkOnValidationTypeClick;
  final ValueNotifier<bool> isButtonEnable;

  const RegistrationAbhaNumberDesktopView({
    required this.onRegistrationContinueInit,
    required this.checkOnValidationTypeClick,
    required this.isButtonEnable,
    super.key,
  });

  @override
  RegistrationAbhaNumberDesktopViewState createState() =>
      RegistrationAbhaNumberDesktopViewState();
}

class RegistrationAbhaNumberDesktopViewState
    extends State<RegistrationAbhaNumberDesktopView> {
  late RegistrationController _registrationController;

  @override
  void initState() {
    super.initState();
    _registrationController = Get.find<RegistrationController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkAndEnableButton() {
    String? value =
        _registrationController.abhaNumberTextController.text.trim();
    value = value.replaceAll('-', '');
    if (value.length == 14 &&
        !Validator.isNullOrEmpty(
          _registrationController.selectedValidationMethod,
        )) {
      widget.isButtonEnable.value = true;
    } else {
      widget.isButtonEnable.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DesktopCommonScreenWidget(
      image: ImageLocalAssets.loginWithEmailImg,
      title: LocalizationHandler.of().registrationWithABHANUmber,
      child: _registrationAbhaWidget(),
    );
  }

  Widget _registrationAbhaWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// form widget to register with abha number
        _formWidgetToRegisterWithAbhaNumber(),

        /// forgot abha number text
        _forgotAbhaNumber(),

        /// validate using widget
        _validateUsingAadhaarOrMobileOtp(),
        _actionWidgets(),
      ],
    );
  }

  Widget _formWidgetToRegisterWithAbhaNumber() {
    return AppTextFormField.desktop(
      context: context,
      title: LocalizationHandler.of().abhaNumber,
      key: const Key(KeyConstant.abhaNumberTextField),
      textEditingController: _registrationController.abhaNumberTextController,
      hintText: LocalizationHandler.of().hintEnterAbhaNumber,
      fontSizeDelta: 4,
      textInputType: TextInputType.number,
      onChanged: (value) {
        if (_registrationController.autoValidateModeWeb ==
            AutovalidateMode.disabled) {
          setState(() {
            _registrationController.autoValidateModeWeb =
                AutovalidateMode.onUserInteraction;
          });
        }
        _checkAndEnableButton();
      },
      autoValidateMode: _registrationController.autoValidateModeWeb,
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

  Widget _forgotAbhaNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          key: const Key(KeyConstant.forgotABHANumberTxt),
          onTap: () {
            // Redirect to the Web url after the click on forget abha number
            _registrationController.forgetAbhaNumberViaWebUrl(context);
            //context.navigatePush(RoutePath.routeAbhaNumberForget,);
          },
          child: Text(
            '${LocalizationHandler.of().forgotABHANumber}?',
            style: CustomTextStyle.titleMedium(context)?.apply(
              color: AppColors.colorAppOrange,
              decoration: TextDecoration.underline,
              fontWeightDelta: 2,
              fontSizeDelta: -2,
            ),
          ),
        ),
      ],
    ).marginOnly(top: Dimen.d_10);
  }

  Widget _validateUsingAadhaarOrMobileOtp() {
    return GetBuilder<RegistrationController>(
      id: RegistrationUpdateUiBuilderIds.abhaNumberValidator,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationHandler.of().validateUsing,
              style: InputFieldStyleDesktop.labelTextStyle,
            ),

            /// Icons and Text of Adhaar Otp and Mobile Otp in [Row] Widget
            _rowAadhaarAndMobileOtpIcon()
          ],
        ).marginOnly(top: Dimen.d_10);
      },
    );
  }

  Widget _actionWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.desktop(
              // width: context.width * 0.15,
              key: const Key(KeyConstant.continueBtn),
              text: LocalizationHandler.of().continuee,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (isButtonEnable) {
                  widget.onRegistrationContinueInit();
                }
              },
            );
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
    ).marginOnly(top: Dimen.d_26);
  }

  /// Here is the widget to select  icon for validating with adhaar and mobile otp type.
  /// It contains the Adhaar otp and Mobile otp Icon and text Widget.
  Widget _rowAadhaarAndMobileOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValidateUsingOptionView(
          onClick: () {
            widget.checkOnValidationTypeClick(RegistrationMethod.verifyAadhaar);
            _checkAndEnableButton();
          },
          selectedValidationMethod:
              _registrationController.selectedValidationMethod ==
                  RegistrationMethod.verifyAadhaar,
          text: LocalizationHandler.of().aadhaarOtp,
          icon: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
          iconWidth: Dimen.d_90,
          iconHeight: Dimen.d_90,
        ).marginOnly(right: Dimen.d_10).expand(),
        ValidateUsingOptionView(
          onClick: () {
            widget.checkOnValidationTypeClick(RegistrationMethod.verifyMobile);
            _checkAndEnableButton();
          },
          selectedValidationMethod:
              _registrationController.selectedValidationMethod ==
                  RegistrationMethod.verifyMobile,
          text: LocalizationHandler.of().mobileOtp,
          icon: ImageLocalAssets.loginMobileNoIconSvg,
          iconWidth: Dimen.d_90,
          iconHeight: Dimen.d_90,
        ).marginOnly(left: Dimen.d_10).expand(),
      ],
    ).marginOnly(top: Dimen.d_4);
  }
}
