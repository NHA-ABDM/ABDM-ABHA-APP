import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberForgetAadhaarPhoneMobileView extends StatefulWidget {
  final VoidCallback isAadhaarValid;
  final VoidCallback isTermsConditionCheckForMobile;
  final String authType;
  final AbhaNumberController abhaNumberController;

  const AbhaNumberForgetAadhaarPhoneMobileView({
    required this.isAadhaarValid,
    required this.isTermsConditionCheckForMobile,
    required this.authType,
    required this.abhaNumberController,
    super.key,
  });

  @override
  AbhaNumberForgetAadhaarPhoneMobileViewState createState() =>
      AbhaNumberForgetAadhaarPhoneMobileViewState();
}

class AbhaNumberForgetAadhaarPhoneMobileViewState
    extends State<AbhaNumberForgetAadhaarPhoneMobileView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.abhaNumberController.stopSpeech();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _aadhaarFieldWidget())
        : _aadhaarFieldWidget();
  }

  Widget _aadhaarFieldWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.authType == AbhaNumberForgotOptionEnum.aadhaarNumber.name)
            Text(
              LocalizationHandler.of().aadhaar_number,
              style: CustomTextStyle.titleMedium(context)?.apply(),
            ).marginOnly(
              top: Dimen.d_30,
            )
          else
            Text(
              LocalizationHandler.of().mobileNumber,
              style: CustomTextStyle.titleMedium(context)?.apply(),
            ).marginOnly(
              top: Dimen.d_30,
            ),

          if (widget.authType == AbhaNumberForgotOptionEnum.aadhaarNumber.name)
            _adhaarNumberField()
          else
            _mobileNumberField(),

          Text(
            LocalizationHandler.of().terms,
            style: CustomTextStyle.titleMedium(context)?.apply(),
          ).marginOnly(
            top: Dimen.d_30,
          ),
          Container(
            decoration: abhaSingleton.getBorderDecoration
                .getRectangularBorder(size: Dimen.d_5),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Text(
                    widget.authType ==
                            AbhaNumberForgotOptionEnum.aadhaarNumber.name
                        ? LocalizationHandler.of()
                            .abhaNumberUserAgreementAadhaar
                        : LocalizationHandler.of()
                            .abhaNumberUserAgreementMobile,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorGreyDark,
                      heightDelta: 0.5,
                    ),
                    textAlign: TextAlign.justify,
                  ).paddingAll(Dimen.d_15),
                ).sizedBox(height: Dimen.d_280),
                Divider(
                  height: Dimen.d_1,
                  color: AppColors.colorGreyWildSand,
                ).paddingOnly(top: Dimen.d_0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: AppCheckBox(
                        color: AppColors.colorAppBlue,
                        value: widget
                            .abhaNumberController.aadhaarDecelerationCheckBox,
                        onChanged: (value) {
                          setState(() {
                            widget.abhaNumberController
                                .aadhaarDecelerationCheckBox = value ?? false;
                          });
                        },
                        title: Text(
                          LocalizationHandler.of().iAgree,
                          style: CustomTextStyle.bodySmall(context)?.apply(),
                          textAlign: TextAlign.justify,
                        ).marginOnly(top: Dimen.d_0),
                      ),
                    ),
                    textToSpeechWidget()
                  ],
                ).paddingAll(Dimen.d_15),
              ],
            ),
          ).marginOnly(
            top: Dimen.d_10,
          ),
          //Row
          ValueListenableBuilder<bool>(
            valueListenable: widget.abhaNumberController.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.mobile(
                key: const Key(KeyConstant.continueBtn),
                text: LocalizationHandler.of().next,
                isButtonEnable: isButtonEnable,
                onPressed: () {
                  if (isButtonEnable) {
                    if (widget.authType ==
                        AbhaNumberForgotOptionEnum.aadhaarNumber.name) {
                      widget.isAadhaarValid();
                    } else {
                      widget.isTermsConditionCheckForMobile();
                    }
                  }
                },
              ).marginOnly(top: Dimen.d_50);
            },
          )
        ],
      ).marginOnly(left: Dimen.d_17, right: Dimen.d_17),
    ).paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0);
  }

  /// This widget allows user to listen the audio of text mentioned in
  /// terms and condition section. This can be achieve by click the [SoundOn] and
  /// [SoundOF] Icons.
  Widget textToSpeechWidget() {
    return GetBuilder<AbhaNumberController>(
      builder: (_) {
        return GestureDetector(
          onTap: () {
            if (widget.abhaNumberController.isAudioPlaying) {
              //stop the text to speech
              widget.abhaNumberController.stopSpeech();
            } else {
              //start the text to speech
              widget.abhaNumberController
                  .startSpeech(LocalizationHandler.of().userAgreementDetails);
            }
            widget.abhaNumberController.functionHandler(
              isUpdateUi: true,
            );
          },
          child: CustomSvgImageView(
            widget.abhaNumberController.isAudioPlaying
                ? ImageLocalAssets.soundOnIcon
                : ImageLocalAssets.soundOffIcon,
            width: Dimen.d_30,
            height: Dimen.d_30,
          ),
        );
      },
    );
  }

  Widget _adhaarNumberField() {
    return AppTextFormField.mobile(
      key: const Key(KeyConstant.abhaNumberTextField),
      textEditingController:
          widget.abhaNumberController.aadhaarNumberTextController,
      textInputType: TextInputType.number,
      hintText: LocalizationHandler.of().hintEnterAadhaarNumber,
      fontSizeDelta: 4,
      fontWeightDelta: 2,
      onChanged: (value) {
        widget.abhaNumberController.aadhaarNumber = value;
        if (value.length == 14) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        if (value.length == 14) {
          widget.abhaNumberController.isButtonEnable.value = true;
        } else {
          widget.abhaNumberController.isButtonEnable.value = false;
        }
      },
      context: context,
    );
  }

  Widget _mobileNumberField() {
    return AppTextFormField.mobile(
      key: const Key(KeyConstant.mobileNumberField),
      context: context,
      textEditingController:
          widget.abhaNumberController.mobileNumberTextController,
      hintText: LocalizationHandler.of().hintEnterMobileNumber,
      textInputType: TextInputType.number,
      fontSizeDelta: 4,
      fontWeightDelta: 2,
      onChanged: (value) {
        widget.abhaNumberController.mobileNumber = value;
        if (value.length == 10) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
        if (value.length == 10) {
          widget.abhaNumberController.isButtonEnable.value = true;
        } else {
          widget.abhaNumberController.isButtonEnable.value = false;
        }
      },
    );
  }
}
