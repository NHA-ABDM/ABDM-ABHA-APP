import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberForgetAadhaarPhoneDesktopView extends StatefulWidget {
  final VoidCallback isAadhaarValid;
  final VoidCallback isTermsConditionCheckForMobile;
  final String authType;
  final AbhaNumberController abhaNumberController;

  const AbhaNumberForgetAadhaarPhoneDesktopView({
    required this.isAadhaarValid,
    required this.isTermsConditionCheckForMobile,
    required this.authType,
    required this.abhaNumberController,
    super.key,
  });

  @override
  AbhaNumberForgetAadhaarPhoneDesktopViewState createState() =>
      AbhaNumberForgetAadhaarPhoneDesktopViewState();
}

class AbhaNumberForgetAadhaarPhoneDesktopViewState
    extends State<AbhaNumberForgetAadhaarPhoneDesktopView> {
  //late AbhaNumberController _abhaNumberController;

  @override
  void initState() {
    //_abhaNumberController = Get.find<AbhaNumberController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return aadhaarFieldWidget();
  }

  Widget aadhaarFieldWidget() {
    return SingleChildScrollView(
      //padding: kIsWeb ? EdgeInsets.all(Dimen.d_18) : EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.authType == AbhaNumberForgotOptionEnum.aadhaarNumber.name)
            Text(
              LocalizationHandler.of().aadhaar_number,
              style: CustomTextStyle.titleMedium(context)?.apply(),
            ).marginOnly(top: Dimen.d_30, left: Dimen.d_17, right: Dimen.d_17)
          else
            Text(
              LocalizationHandler.of().mobileNumber,
              style: CustomTextStyle.titleMedium(context)?.apply(),
            ).marginOnly(top: Dimen.d_30, left: Dimen.d_17, right: Dimen.d_17),

          if (widget.authType == AbhaNumberForgotOptionEnum.aadhaarNumber.name)
            _adhaarNumberField()
          else
            _mobileNumberField(),

          Text(
            LocalizationHandler.of().terms,
            style: CustomTextStyle.titleMedium(context)?.apply(),
          ).marginOnly(
            top: Dimen.d_30,
            left: Dimen.d_17,
            right: Dimen.d_17,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AppCheckBox(
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
                    )
                  ], //<Widget>[]
                ).paddingAll(Dimen.d_15),
              ],
            ),
          ).marginOnly(top: Dimen.d_10, left: Dimen.d_17, right: Dimen.d_17),
          //Row
          ValueListenableBuilder<bool>(
            valueListenable: widget.abhaNumberController.isButtonEnable,
            builder: (context, isButtonEnable, _) {
              return TextButtonOrange.desktop(
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
              )
                  .marginOnly(top: Dimen.d_50, right: Dimen.d_17)
                  .alignAtTopRight();
            },
          )
        ],
      ),
    ).paddingAll(kIsWeb ? Dimen.d_18 : Dimen.d_0);
  }

  Widget _adhaarNumberField() {
    return SizedBox(
      width: context.width * 0.2,
      child: AppTextField(
        key: const Key(KeyConstant.abhaNumberTextField),
        textEditingController:
            widget.abhaNumberController.aadhaarNumberTextController,
        textInputType: TextInputType.number,
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
      ).marginOnly(left: Dimen.d_17, right: Dimen.d_17),
    );
  }

  Widget _mobileNumberField() {
    return SizedBox(
      width: context.width * 0.2,
      child: AppTextField(
        key: const Key(KeyConstant.mobileNumberField),
        textEditingController:
            widget.abhaNumberController.mobileNumberTextController,
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
            widget.abhaNumberController.functionHandler(
              isUpdateUi: true,
              updateUiBuilderIds: [AbhaNumberOptionEnum.updateNextButton],
            );
          } else {
            widget.abhaNumberController.isButtonEnable.value = false;
            widget.abhaNumberController.functionHandler(
              isUpdateUi: true,
              updateUiBuilderIds: [AbhaNumberOptionEnum.updateNextButton],
            );
          }
        },
      ).marginOnly(left: Dimen.d_17, right: Dimen.d_17),
    );
  }
}
