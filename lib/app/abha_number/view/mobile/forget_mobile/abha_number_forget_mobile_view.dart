import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/radio_tile/custom_radio_tile.dart';
import 'package:flutter/foundation.dart';

class AbhaNumberForgetMobileView extends StatefulWidget {
  final AbhaNumberController abhaNumberController;

  const AbhaNumberForgetMobileView({
    required this.abhaNumberController,
    super.key,
  });

  @override
  AbhaNumberForgetMobileViewState createState() =>
      AbhaNumberForgetMobileViewState();
}

class AbhaNumberForgetMobileViewState
    extends State<AbhaNumberForgetMobileView> {
  late AbhaNumberController _abhaNumberController;

  @override
  void initState() {
    _abhaNumberController = widget.abhaNumberController;
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteAbhaNumber();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? MobileWebCardWidget(child: _widgetRecoveryOption())
        : _widgetRecoveryOption();
  }

  Widget _widgetRecoveryOption() {
    return GetBuilder<AbhaNumberController>(
      builder: (_) {
        return Column(
          children: [
            Text(
              LocalizationHandler.of().abhaNumberRetrievalMessage,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorGreyDark,
                heightDelta: 0.5,
              ),
              textAlign: TextAlign.justify,
            ).marginOnly(
              left: Dimen.d_17,
              top: Dimen.d_30,
              right: Dimen.d_17,
              bottom: Dimen.d_20,
            ),
            CustomRadioTile(
              title: LocalizationHandler.of().aadhaar_number,
              radioValue: AbhaNumberForgotOptionEnum.aadhaarNumber,
              radioGroupValue: _abhaNumberController.abhaNumberForgotOptionEnum,
              onChanged: (value) {
                _abhaNumberController.abhaNumberForgotOptionEnum =
                    AbhaNumberForgotOptionEnum.aadhaarNumber;
                _abhaNumberController.functionHandler(isUpdateUi: true);
              },
            ),
            CustomRadioTile(
              title: LocalizationHandler.of().mobileNumber,
              radioValue: AbhaNumberForgotOptionEnum.mobileNumber,
              radioGroupValue: _abhaNumberController.abhaNumberForgotOptionEnum,
              onChanged: (value) {
                _abhaNumberController.abhaNumberForgotOptionEnum =
                    AbhaNumberForgotOptionEnum.mobileNumber;
                _abhaNumberController.functionHandler(isUpdateUi: true);
              },
            ),
            TextButtonOrange.mobile(
              key: const Key(KeyConstant.continueBtn),
              text: LocalizationHandler.of().continuee,
              onPressed: () async {
                if (_abhaNumberController.abhaNumberForgotOptionEnum ==
                    AbhaNumberForgotOptionEnum.aadhaarNumber) {
                  var argument = {
                    IntentConstant.sourceType:
                        AbhaNumberForgotOptionEnum.aadhaarNumber.name
                  };
                  context.navigatePush(
                    RoutePath.routeAbhaNumberForgetViaAadhaarMobile,
                    arguments: argument,
                  );
                } else {
                  var argument = {
                    IntentConstant.sourceType:
                        AbhaNumberForgotOptionEnum.mobileNumber.name
                  };
                  context.navigatePush(
                    RoutePath.routeAbhaNumberForgetViaAadhaarMobile,
                    arguments: argument,
                  );
                }
              },
            ).marginOnly(
              top: Dimen.d_50,
              bottom: Dimen.d_30,
              left: Dimen.d_17,
              right: Dimen.d_17,
            )
          ],
        );
      },
    );
  }
}
