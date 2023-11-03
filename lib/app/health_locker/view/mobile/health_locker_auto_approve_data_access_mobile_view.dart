import 'package:abha/export_packages.dart';

class HealthLockerAutoApproveDataAccessMobileView extends StatefulWidget {
  final Map arguments;
  final Function(dynamic consents, dynamic approveAccessData)
      updateAutoApproveOnButtonClick;

  const HealthLockerAutoApproveDataAccessMobileView({
    required this.arguments,
    required this.updateAutoApproveOnButtonClick,
    super.key,
  });

  @override
  HealthLockerAutoApproveDataAccessMobileViewState createState() =>
      HealthLockerAutoApproveDataAccessMobileViewState();
}

class HealthLockerAutoApproveDataAccessMobileViewState
    extends State<HealthLockerAutoApproveDataAccessMobileView> {
  late HealthLockerController healthLockerController;

  @override
  void initState() {
    healthLockerController = Get.find<HealthLockerController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getApproveDataWidget();
  }

  Widget getApproveDataWidget() {
    var approveAccessData = widget.arguments[IntentConstant.data];
    var consents = widget.arguments[IntentConstant.approveId];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _autoApproveTitleAndMessage(approveAccessData),
        TextButtonOrange.mobile(
          text: approveAccessData == true
              ? LocalizationHandler.of().disable_auto_approval
              : LocalizationHandler.of().yes_approve,
          onPressed: () {
            widget.updateAutoApproveOnButtonClick(consents, approveAccessData);
          },
        ).marginOnly(bottom: context.bottomPadding),
      ],
    );
  }

  Widget _autoApproveTitleAndMessage(approveAccessData) {
    return Column(
      children: [
        Text(
          LocalizationHandler.of().auto_approved_to_access_data,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
        ).marginOnly(bottom: Dimen.d_20),
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            borderColor: AppColors.colorGreyDark2,
            size: Dimen.d_8,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      //Validator.isNullOrEmpty(approveAccessData)
                      approveAccessData == true
                          ? LocalizationHandler.of().auto_approved_message
                          : LocalizationHandler.of().auto_approved_skip_message,
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorGreyDark1,
                        fontSizeDelta: -2,
                        fontWeightDelta: 2,
                      ),
                    ),
                    Text(
                      LocalizationHandler.of()
                          .auto_approved_changefromLocker_message,
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorGreyDark1,
                        fontSizeDelta: -2,
                        fontWeightDelta: 2,
                      ),
                    ).marginOnly(top: Dimen.d_20)
                  ],
                ).paddingAll(Dimen.d_15),
              ),
            ],
          ),
        )
      ],
    );
  }
}
