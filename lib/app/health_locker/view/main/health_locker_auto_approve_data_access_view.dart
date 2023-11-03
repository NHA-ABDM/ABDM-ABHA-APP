import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/app/health_locker/view/desktop/health_locker_auto_approve_data_access_desktop_view.dart';
import 'package:abha/app/health_locker/view/mobile/health_locker_auto_approve_data_access_mobile_view.dart';
import 'package:abha/export_packages.dart';

class HealthLockerAutoApproveDataAccessView extends StatefulWidget {
  final Map arguments;

  const HealthLockerAutoApproveDataAccessView({
    required this.arguments,
    super.key,
  });

  @override
  HealthLockerAutoApproveDataAccessViewState createState() =>
      HealthLockerAutoApproveDataAccessViewState();
}

class HealthLockerAutoApproveDataAccessViewState
    extends State<HealthLockerAutoApproveDataAccessView> {
  late HealthLockerController healthLockerController;

  @override
  void initState() {
    healthLockerController = Get.find<HealthLockerController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: HealthLockerAutoApproveDataAccessView,
      isTopSafeArea: true,
      title: LocalizationHandler.of().auto_approve_data.toTitleCase(),
      bodyMobile: HealthLockerAutoApproveDataAccessMobileView(
        arguments: widget.arguments,
        updateAutoApproveOnButtonClick: updateAutoApproveOnButtonClick,
      ),
      bodyDesktop: HealthLockerAutoApproveDataAccessDesktopView(
        arguments: widget.arguments,
        updateAutoApproveOnButtonClick: updateAutoApproveOnButtonClick,
      ),
    );
  }

  Widget getApproveDataWidget() {
    var approveAccessData = widget.arguments[IntentConstant.data];
    var consents = widget.arguments[IntentConstant.approveId];
    return Column(
      children: [
        _autoApproveTitleAndMessage(approveAccessData),
        TextButtonOrange.mobile(
          text: approveAccessData == true
              ? LocalizationHandler.of().disable_auto_approval
              : LocalizationHandler.of().yes_approve,
          onPressed: () {
            updateAutoApproveOnButtonClick(consents, approveAccessData);
          },
        ).alignAtBottomCenter().marginOnly(bottom: Dimen.d_35),
      ],
    ).paddingAll(Dimen.d_15);
  }

  Widget _autoApproveTitleAndMessage(approveAccessData) {
    return Expanded(
      child: Column(
        children: [
          Text(
            LocalizationHandler.of().auto_approved_to_access_data,
            style: CustomTextStyle.bodySmall(context)
                ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 2),
          ).marginOnly(bottom: Dimen.d_20),
          DecoratedBox(
            decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
              borderColor: AppColors.colorGreyDark2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
            ).paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20),
          )
        ],
      ),
    );
  }

  /// @Here function to update auto approve when click on Button.
  Future<void> updateAutoApproveOnButtonClick(
    var consents,
    var approveAccessData,
  ) async {
    String? requestId;
    if (consents[0] is AutoApproval) {
      AutoApproval autoApproval = consents[0];
      requestId = autoApproval.autoApprovalId;
    }

    /// if approveAccessData is false i:e, User allow to approve
    if (approveAccessData == false) {
      await healthLockerController.functionHandler(
        function: () => healthLockerController.getChangeAutoApprovePolicy(
          requestId!,
          true,
        ),
        isLoaderReq: true,
      );
    } else {
      /// user allow to disable
      await healthLockerController.functionHandler(
        function: () => healthLockerController.getChangeAutoApprovePolicy(
          requestId!,
          false,
        ),
        isLoaderReq: true,
      );
    }
    if (healthLockerController.responseHandler.status == Status.success) {
      navigate();
    }
  }

  /// navigate back screen
  void navigate() {
    context.navigateBack();
  }
}
