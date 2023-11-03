import 'dart:io';

import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberOptionMobileView extends StatefulWidget {
  final VoidCallback generateOtp;

  const AbhaNumberOptionMobileView({
    required this.generateOtp,
    super.key,
  });

  @override
  AbhaNumberOptionMobileViewState createState() =>
      AbhaNumberOptionMobileViewState();
}

class AbhaNumberOptionMobileViewState
    extends State<AbhaNumberOptionMobileView> {
  final AbhaNumberController _abhaNumberController =
      Get.find<AbhaNumberController>();
  bool isAndroid = false;

  @override
  void initState() {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        isAndroid = true;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _abhaNumberOptionWidget())
        : _abhaNumberOptionWidget();
  }

  Widget _abhaNumberOptionWidget() {
    return Column(
      children: [
        if (kIsWeb)
          abhaNumberWidget()
        else
          Expanded(
            child: abhaNumberWidget(),
          ),
        TextButtonOrange.mobile(
          key: const Key(KeyConstant.continueBtn),
          text: LocalizationHandler.of().next,
          onPressed: () async {
            if (_abhaNumberController.abhaVerificationOptionValue ==
                AbhaNumberOptionEnum.otpVerifyAadhaar) {
              widget.generateOtp();
            } else {}
          },
        ).marginOnly(
          bottom: context.bottomPadding + Dimen.d_16,
          left: Dimen.d_16,
          right: Dimen.d_16,
        ),
      ],
    );
  }

  Widget abhaNumberWidget() {
    return GetBuilder<AbhaNumberController>(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationHandler.of().validateUsing,
              style: InputFieldStyleMobile.labelTextStyle,
            ).marginOnly(
              left: Dimen.d_17,
              top: Dimen.d_20,
              right: Dimen.d_17,
              bottom: Dimen.d_20,
            ),
            CustomRadioTile(
              title: LocalizationHandler.of().otpVerifyAadhaar,
              radioValue: AbhaNumberOptionEnum.otpVerifyAadhaar,
              radioGroupValue:
                  _abhaNumberController.abhaVerificationOptionValue,
              onChanged: (value) {
                _abhaNumberController.abhaVerificationOptionValue =
                    AbhaNumberOptionEnum.otpVerifyAadhaar;
                _abhaNumberController.update();
              },
            ),
            if (isAndroid)
              CustomRadioTile(
                title: LocalizationHandler.of().faceAuth,
                radioValue: AbhaNumberOptionEnum.faceAuth,
                radioGroupValue:
                    _abhaNumberController.abhaVerificationOptionValue,
                onChanged: (value) {
                  _abhaNumberController.abhaVerificationOptionValue =
                      AbhaNumberOptionEnum.faceAuth;
                  _abhaNumberController.update();
                },
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
