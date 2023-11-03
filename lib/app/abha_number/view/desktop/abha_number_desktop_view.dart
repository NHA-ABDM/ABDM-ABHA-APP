import 'package:abha/export_packages.dart';

class AbhaNumberDesktopView extends StatefulWidget {
  final VoidCallback isAadhaarValid;

  const AbhaNumberDesktopView({required this.isAadhaarValid, super.key});

  @override
  AbhaNumberDesktopViewState createState() => AbhaNumberDesktopViewState();
}

class AbhaNumberDesktopViewState extends State<AbhaNumberDesktopView> {
  late AbhaNumberController _abhaNumberController;

  String _aadhaarNumber = '';

  @override
  void initState() {
    _abhaNumberController = Get.find<AbhaNumberController>();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mainWidget();
  }

  Widget mainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationHandler.of().aadhaar_number,
          style: CustomTextStyle.titleSmall(context)
              ?.apply(color: AppColors.colorGrey3, fontWeightDelta: 1),
        ),
        SizedBox(
          width: context.width * 0.15,
          child: AppTextField(
            key: const Key(KeyConstant.abhaNumberTextField),
            textEditingController:
                _abhaNumberController.aadhaarNumberTextController,
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
          ).paddingAll(Dimen.d_5),
        ).marginOnly(top: Dimen.d_10),
        //),
        Text(
          LocalizationHandler.of().terms,
          style: CustomTextStyle.titleLarge(context)?.apply(),
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
                  LocalizationHandler.of().userAgreementDetails,
                  style: CustomTextStyle.bodySmall(context)?.apply(
                    color: AppColors.colorGreyDark,
                    heightDelta: 0.5,
                  ),
                  textAlign: TextAlign.justify,
                ).paddingAll(Dimen.d_15),
              ).sizedBox(
                height: Dimen.d_200,
              ),
              Divider(
                thickness: Dimen.d_1,
                color: AppColors.colorGreyWildSand,
              ).marginOnly(top: Dimen.d_10),
              Row(
                children: [
                  AppCheckBox(
                    color: AppColors.colorAppBlue,
                    value: _abhaNumberController.aadhaarDecelerationCheckBox,
                    onChanged: (value) {
                      setState(() {
                        _abhaNumberController.aadhaarDecelerationCheckBox =
                            value ?? false;
                      });
                    },
                    title: RichText(
                      text: TextSpan(
                        style: CustomTextStyle.titleSmall(context)
                            ?.apply(fontWeightDelta: -1),
                        children: [
                          TextSpan(
                            text: LocalizationHandler.of().iAgree,
                          ),
                          TextSpan(
                            text: LocalizationHandler.of().terms,
                            style: CustomTextStyle.titleSmall(context)?.apply(
                              color: AppColors.colorAppOrange,
                              fontWeightDelta: -1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ], //<Widget>[]
              ).paddingAll(Dimen.d_15),
            ],
          ),
        ).marginOnly(
          top: Dimen.d_10,
          bottom: Dimen.d_10,
        ),
        ValueListenableBuilder<bool>(
          valueListenable: _abhaNumberController.isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.desktop(
              isButtonEnable: isButtonEnable,
              text: LocalizationHandler.of().next,
              onPressed: () {
                if (isButtonEnable) {
                  widget.isAadhaarValid();
                }
              },
            ).alignAtTopRight().marginOnly(top: Dimen.d_20);
          },
        )
      ],
    ).paddingAll(Dimen.d_18);
  }
}
