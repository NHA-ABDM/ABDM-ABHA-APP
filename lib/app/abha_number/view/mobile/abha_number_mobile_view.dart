import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberMobileView extends StatefulWidget {
  final VoidCallback isAadhaarValid;

  const AbhaNumberMobileView({
    required this.isAadhaarValid,
    super.key,
  });

  @override
  AbhaNumberMobileViewState createState() => AbhaNumberMobileViewState();
}

class AbhaNumberMobileViewState extends State<AbhaNumberMobileView> {
  late AbhaNumberController _abhaNumberController;

  String _aadhaarNumber = '';

  @override
  void initState() {
    _abhaNumberController = Get.find();
    super.initState();
  }

  @override
  void dispose() {
    _abhaNumberController.stopSpeech();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? MobileWebCardWidget(child: mainWidget()) : mainWidget();
  }

  Widget mainWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (kIsWeb)
            Text(
              LocalizationHandler.of().createAbhaNumber,
              style: CustomTextStyle.titleMedium(context)?.apply(
                color: AppColors.colorAppBlue,
                fontWeightDelta: 2,
              ),
            ).alignAtCenter().paddingSymmetric(
                  vertical: Dimen.d_20,
                  horizontal: Dimen.d_20,
                ),

          AppTextFormField.mobile(
            context: context,
            key: const Key(KeyConstant.abhaNumberTextField),
            textEditingController:
                _abhaNumberController.aadhaarNumberTextController,
            hintText: LocalizationHandler.of().hintEnterAadhaarNumber,
            title: LocalizationHandler.of().aadhaar_number,
            textInputType: TextInputType.number,
            onChanged: (value) {
              _aadhaarNumber = value;
              if (_aadhaarNumber.length == 14) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
              if (value.length == 14) {
                _abhaNumberController.isButtonEnable.value = true;
              } else {
                _abhaNumberController.isButtonEnable.value = false;
              }
            },
          ).marginOnly(top: Dimen.d_30),
          Text(
            LocalizationHandler.of().terms,
            style: InputFieldStyleMobile.labelTextStyle,
          ).marginOnly(top: Dimen.d_30),

          Container(
            decoration: abhaSingleton.getBorderDecoration
                .getRectangularBorder(size: Dimen.d_5),
            child: Column(
              children: [
                SingleChildScrollView(
                  child: Text(
                    LocalizationHandler.of().userAgreementDetails,
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
                        value:
                            _abhaNumberController.aadhaarDecelerationCheckBox,
                        onChanged: (value) {
                          setState(() {
                            _abhaNumberController.aadhaarDecelerationCheckBox =
                                value ?? false;
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
                  ], //<Widget>[]
                ).paddingAll(Dimen.d_15),
              ],
            ),
          ).marginOnly(top: Dimen.d_10),
          //Row
          ValueListenableBuilder<bool>(
            valueListenable: _abhaNumberController.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.mobile(
                text: LocalizationHandler.of().next,
                isButtonEnable: isButtonEnable,
                onPressed: () {
                  if (isButtonEnable) {
                    widget.isAadhaarValid();
                  }
                },
              ).marginOnly(top: Dimen.d_50);
            },
          )
        ],
      )
          .marginOnly(left: Dimen.d_17, right: Dimen.d_17)
          .paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0),
    );
  }

  /// This widget allows user to listen the audio of text mentioned in
  /// terms and condition section. This can be achieve by click the [SoundOn] and
  /// [SoundOF] Icons.
  Widget textToSpeechWidget() {
    return GetBuilder<AbhaNumberController>(
      builder: (_) {
        return GestureDetector(
          onTap: () {
            if (_abhaNumberController.isAudioPlaying) {
              //stop the text to speech
              _abhaNumberController.stopSpeech();
            } else {
              //start the text to speech
              _abhaNumberController
                  .startSpeech(LocalizationHandler.of().userAgreementDetails);
            }
            _abhaNumberController.functionHandler(
              isUpdateUi: true,
            );
          },
          child: CustomSvgImageView(
            _abhaNumberController.isAudioPlaying
                ? ImageLocalAssets.soundOnIcon
                : ImageLocalAssets.soundOffIcon,
            width: Dimen.d_30,
            height: Dimen.d_30,
          ),
        );
      },
    );
  }

  Widget termAndConditionWidget() {
    return Container(
      decoration: abhaSingleton.getBorderDecoration
          .getRectangularBorder(size: Dimen.d_5),
      child: Column(
        children: [
          SingleChildScrollView(
            child: Text(
              LocalizationHandler.of().userAgreementDetails,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorGreyDark,
                heightDelta: 0.5,
              ),
              textAlign: TextAlign.justify,
            ).paddingAll(Dimen.d_15),
          ).sizedBox(height: Dimen.d_280),
          Divider(
            thickness: Dimen.d_1,
            color: AppColors.colorGreyWildSand,
          ).marginOnly(top: Dimen.d_10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: AppCheckBox(
                  color: AppColors.colorAppBlue,
                  value: _abhaNumberController.aadhaarDecelerationCheckBox,
                  onChanged: (value) {
                    setState(() {
                      _abhaNumberController.aadhaarDecelerationCheckBox =
                          value ?? false;
                    });
                  },
                  title: Text(
                    LocalizationHandler.of().iAgree,
                    style: CustomTextStyle.bodySmall(context)?.apply(),
                    textAlign: TextAlign.justify,
                  ).marginOnly(top: Dimen.d_3),
                ),
              )
            ], //<Widget>[]
          ).paddingAll(Dimen.d_15),
        ],
      ),
    ).marginOnly(top: Dimen.d_10, left: Dimen.d_17, right: Dimen.d_17);
  }
}
