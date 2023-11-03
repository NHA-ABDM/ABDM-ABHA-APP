import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class HealthLockerAutoApproveDataAccessDesktopView extends StatefulWidget {
  final Map arguments;
  final Function(dynamic consents, dynamic approveAccessData)
      updateAutoApproveOnButtonClick;

  const HealthLockerAutoApproveDataAccessDesktopView({
    required this.arguments,
    required this.updateAutoApproveOnButtonClick,
    super.key,
  });

  @override
  HealthLockerAutoApproveDataAccessDesktopViewState createState() =>
      HealthLockerAutoApproveDataAccessDesktopViewState();
}

class HealthLockerAutoApproveDataAccessDesktopViewState
    extends State<HealthLockerAutoApproveDataAccessDesktopView> {
  late HealthLockerController healthLockerController;

  @override
  void initState() {
    healthLockerController = Get.find<HealthLockerController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().auto_approve_data.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          CommonBackgroundCard(child: getApproveDataWidget())
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget getApproveDataWidget() {
    var approveAccessData = widget.arguments[IntentConstant.data];
    var consents = widget.arguments[IntentConstant.approveId];
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _autoApproveTitleAndMessage(approveAccessData),
        Row(
          children: [
            TextButtonOrange.desktop(
              text: approveAccessData == true
                  ? LocalizationHandler.of().disable_auto_approval
                  : LocalizationHandler.of().yes_approve,
              onPressed: () {
                widget.updateAutoApproveOnButtonClick(
                  consents,
                  approveAccessData,
                );
              },
            ),
            TextButtonPurple(
              text: LocalizationHandler.of().cancel,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(left: Dimen.d_16),
          ],
        ).marginOnly(top: Dimen.d_30),
      ],
    );
  }

  Widget _autoApproveTitleAndMessage(approveAccessData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocalizationHandler.of().auto_approved_to_access_data,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorGreyDark2, fontWeightDelta: 0),
        ).marginOnly(bottom: Dimen.d_16),
        Text(
          approveAccessData == true
              ? LocalizationHandler.of().auto_approved_message
              : LocalizationHandler.of().auto_approved_skip_message,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorGreyDark1,
            fontSizeDelta: -2,
            fontWeightDelta: 0,
          ),
        ),
        Text(
          LocalizationHandler.of().auto_approved_changefromLocker_message,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorGreyDark1,
            fontSizeDelta: -2,
            fontWeightDelta: 0,
          ),
        )
      ],
    );
  }
}
