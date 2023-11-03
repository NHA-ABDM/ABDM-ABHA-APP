import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LinkAbhaNumberMobileView extends StatefulWidget {
  final VoidCallback onAbhaNumberAuthInit;
  final void Function(LinkUnlinkMethod value) onClickRadioButton;
  final LinkUnlinkController linkUnlinkController;
  final ValueNotifier<bool> isButtonEnable;

  const LinkAbhaNumberMobileView({
    required this.onAbhaNumberAuthInit,
    required this.onClickRadioButton,
    required this.linkUnlinkController,
    required this.isButtonEnable,
    super.key,
  });

  @override
  LinkAbhaNumberMobileViewState createState() =>
      LinkAbhaNumberMobileViewState();
}

class LinkAbhaNumberMobileViewState extends State<LinkAbhaNumberMobileView> {
  late LinkUnlinkController _linkUnlinkController;

  @override
  void initState() {
    _linkUnlinkController = widget.linkUnlinkController;
    _linkUnlinkController.actionType = StringConstants.link;
    _linkUnlinkController.update([LinkUnlinkUpdateUiBuilderIds.radioToggle]);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _checkAndEnableButton() {
    String? value = _linkUnlinkController.abhaNumberTEC.text.trim();
    value = value.replaceAll('-', '');
    if (value.length == 14 &&
        !Validator.isNullOrEmpty(_linkUnlinkController.selectedRadioButton)) {
      widget.isButtonEnable.value = true;
    } else {
      widget.isButtonEnable.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _loginAbhaNumberWidget())
        : _loginAbhaNumberWidget();
  }

  Widget _loginAbhaNumberWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for Mobile Web browser (if KIsWeb is True)
        if (kIsWeb)
          Container(
            padding: EdgeInsets.symmetric(
              vertical: Dimen.d_20,
              horizontal: Dimen.d_20,
            ),
            child: Text(
              LocalizationHandler.of().linkAbhaNumber,
              style: CustomTextStyle.titleLarge(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 2,
              ),
            ),
          ).alignAtCenter(),

        /// Anant suggested to show the text one after another and not below each other
        Wrap(
          children: [
            Text(
              LocalizationHandler.of().linkAbhaNumberMsg,
              style: CustomTextStyle.bodyMedium(context)
                  ?.apply(color: AppColors.colorBlack6, fontWeightDelta: 2),
            ).marginOnly(right: Dimen.d_5),
            Text(
              '"${abhaSingleton.getAppData.getAbhaAddress()}"',
              style: CustomTextStyle.bodyMedium(context)?.apply(),
            ).marginOnly(right: Dimen.d_5),
          ],
        ),
        Text(
          LocalizationHandler.of().abhaNumber,
          style: CustomTextStyle.labelMedium(context)?.apply(
            color: AppColors.colorGrey3,
            fontWeightDelta: 2,
          ),
        ).marginOnly(top: Dimen.d_20),
        AppTextFormField.mobile(
          context: context,
          hintText: LocalizationHandler.of().hintEnterAbhaNumber,
          key: const Key(KeyConstant.abhaNumberTextField),
          textEditingController: _linkUnlinkController.abhaNumberTEC,
          textInputType: TextInputType.number,
          onChanged: (value) {
            _checkAndEnableButton();
          },
          autoValidateMode: kIsWeb
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          validator: (value) {
            if (Validator.isNullOrEmpty(value)) {
              return LocalizationHandler.of().errorEnterAbhaNumber;
            }
            if (!Validator.isAbhaNumberWithDashValid(value!)) {
              return LocalizationHandler.of().invalidAbhaNumber;
            }
            return null;
          },
        ),
        GetBuilder<LinkUnlinkController>(
          id: LinkUnlinkUpdateUiBuilderIds.radioToggle,
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocalizationHandler.of().validateUsing,
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    fontWeightDelta: 2,
                    color: AppColors.colorAppBlue,
                  ),
                ).marginOnly(top: Dimen.d_50),
                rowAbhaNumberOrAdhaarOtpIcon(),
              ],
            );
          },
        ),
        ValueListenableBuilder<bool>(
          valueListenable: widget.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              key: const Key(KeyConstant.continueBtn),
              text: LocalizationHandler.of().continuee,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                widget.onAbhaNumberAuthInit();
              },
            ).marginOnly(top: Dimen.d_50, bottom: Dimen.d_16);
          },
        ),
      ],
    ).marginAll(Dimen.d_16);
  }

  Widget rowAbhaNumberOrAdhaarOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              // setState(() {
              _linkUnlinkController.selectedRadioButton =
                  LinkUnlinkMethod.verifyAadhaar;
              widget.onClickRadioButton(
                _linkUnlinkController.selectedRadioButton!,
              );
              _checkAndEnableButton();
              // });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _linkUnlinkController.selectedRadioButton ==
                LinkUnlinkMethod.verifyAadhaar,
            text: LocalizationHandler.of().aadhaarOtp,
            icon: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
          ),
        ),
        SizedBox(width: Dimen.d_10),
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              // setState(() {
              _linkUnlinkController.selectedRadioButton =
                  LinkUnlinkMethod.verifyMobile;
              widget.onClickRadioButton(
                _linkUnlinkController.selectedRadioButton!,
              );
              _checkAndEnableButton();
              // });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _linkUnlinkController.selectedRadioButton ==
                LinkUnlinkMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginAbhaAddressIconSvg,
          ).marginOnly(left: Dimen.d_3, right: Dimen.d_3),
        ),
      ],
    ).marginOnly(top: Dimen.d_20);
  }
}
