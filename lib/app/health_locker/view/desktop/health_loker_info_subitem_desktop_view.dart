import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class HealthLockerInfoSubItemDesktopView extends StatefulWidget {
  final Map arguments;
  final Function(String lockerId) onFetchLockerInfo;

  const HealthLockerInfoSubItemDesktopView({
    required this.arguments,
    required this.onFetchLockerInfo,
    super.key,
  });

  @override
  HealthLockerInfoSubItemDesktopViewState createState() =>
      HealthLockerInfoSubItemDesktopViewState();
}

class HealthLockerInfoSubItemDesktopViewState
    extends State<HealthLockerInfoSubItemDesktopView> {
  late HealthLockerController _healthLockerController;
  late String lockerId;
  late String lockerType;

  @override
  void initState() {
    _healthLockerController = Get.find<HealthLockerController>();
    lockerId = widget.arguments[IntentConstant.lockerId];
    lockerType = widget.arguments[IntentConstant.lockerName];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lockerType,
            style: CustomTextStyle.titleLarge(context)
                ?.apply(color: AppColors.colorAppBlue, fontWeightDelta: 2),
          ).marginOnly(bottom: Dimen.d_20),
          getLockerSubInfoView(),
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget getLockerSubInfoView() {
    return GetBuilder<HealthLockerController>(
      id: UpdateLockerBuilderIds.healthLockerInfoSubItem,
      builder: (_) {
        var data = _healthLockerController.healthLockerInfoModel;
        HealthLockerInfoModel tempConnectedLockers =
            data is HealthLockerInfoModel ? data : HealthLockerInfoModel();
        return _lockerInfoWidget(tempConnectedLockers);
      },
    );
  }

  Widget _lockerInfoWidget(HealthLockerInfoModel healthLockerInfoModel) {
    /// Get subscription result from model into the list, having status granted.
    var subscriptionsResult = healthLockerInfoModel.subscriptions
        ?.where(
          (i) => i.status?.toLowerCase() == ConsentStatus.granted.toLowerCase(),
        )
        .toList();
    bool isAutoApprove = false;

    /// Get AutoApprove status as boolean from model.
    if (!Validator.isNullOrEmpty(healthLockerInfoModel.autoApprovals)) {
      if (healthLockerInfoModel.autoApprovals![0].active!) {
        isAutoApprove = healthLockerInfoModel.autoApprovals![0].active!;
      } else {
        isAutoApprove = healthLockerInfoModel.autoApprovals![0].active!;
      }
    }

    return CommonBackgroundCard(
      child: Row(
        children: WidgetUtility.spreadWidgets(
          [
            Expanded(
              child: _lockerInfoListTitleWidget(
                title: LocalizationHandler.of().subscription,
                subTitle: Validator.isNullOrEmpty(subscriptionsResult)
                    ? LocalizationHandler.of().not_approved
                    : LocalizationHandler.of().approved,
                icon: ImageLocalAssets.lokerSubscriptionIconSvg,
                onClick: () {
                  if (!Validator.isNullOrEmpty(subscriptionsResult)) {
                    var arguments = {
                      IntentConstant.fromScreen:
                          StringConstants.forSubscription,
                      IntentConstant.data: healthLockerInfoModel.subscriptions,
                    };
                    context.navigatePush(
                      RoutePath.routeHealthLockerInfo,
                      arguments: arguments,
                    );
                  }
                },
                color: Validator.isNullOrEmpty(subscriptionsResult)
                    ? AppColors.colorGrey
                    : AppColors.colorGreenLight3,
              ),
            ),
            Expanded(
              child: _lockerInfoListTitleWidget(
                title: LocalizationHandler.of().auto_approval,
                subTitle: isAutoApprove
                    ? LocalizationHandler.of().approved
                    : LocalizationHandler.of().not_approved,
                icon: ImageLocalAssets.lokerApproveIconSvg,
                onClick: () {
                  if (Validator.isNullOrEmpty(
                    healthLockerInfoModel.autoApprovals,
                  )) {
                    MessageBar.showToastDialog(
                      LocalizationHandler.of().unableToCompleteRequest,
                    );
                    return;
                  }

                  CustomDialog.showPopupDialog(
                    '${isAutoApprove == true ? LocalizationHandler.of().auto_approved_message : LocalizationHandler.of().auto_approved_skip_message}\n${LocalizationHandler.of().auto_approved_changefromLocker_message}',
                    title:
                        LocalizationHandler.of().auto_approved_to_access_data,
                    onPositiveButtonPressed: () {
                      updateAutoApproveOnButtonClick(
                        healthLockerInfoModel.autoApprovals,
                        isAutoApprove,
                      );
                    },
                    positiveButtonTitle: isAutoApprove == true
                        ? LocalizationHandler.of().disable_auto_approval
                        : LocalizationHandler.of().yes_approve,
                    backDismissible: false,
                    negativeButtonTitle: LocalizationHandler.of().cancel,
                    onNegativeButtonPressed: () {
                      context.navigateBack();
                    },
                  );
                },
                color: isAutoApprove
                    ? AppColors.colorGreenLight3
                    : AppColors.colorRed,
              ),
            )
          ],
          interItemSpace: Dimen.d_20,
        ),
      ),
    );
  }

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
      await _healthLockerController.functionHandler(
        function: () => _healthLockerController.getChangeAutoApprovePolicy(
          requestId!,
          true,
        ),
        isLoaderReq: true,
      );
    } else {
      /// user allow to disable
      await _healthLockerController.functionHandler(
        function: () => _healthLockerController.getChangeAutoApprovePolicy(
          requestId!,
          false,
        ),
        isLoaderReq: true,
      );
    }
    if (_healthLockerController.responseHandler.status == Status.success) {
      context.navigateBack();
      _reloadThePage();
    }
  }

  /// @Here reload the page to get updated status.
  void _reloadThePage() {
    String? lockerId = _healthLockerController.healthLockerInfoModel?.lockerId;
    if (!Validator.isNullOrEmpty(lockerId)) {
      widget.onFetchLockerInfo(lockerId!);
    }
  }

  /// @Here is common widget to display the title as name and subtitle as status with
  /// specific icon. There is VoidCallback to perform click operation on item. Params are used :-
  ///     [title] of type String to display Name.
  ///     [subTitle] of type String to display Status.
  ///     [icon] of type String to display Image.
  ///     [onClick] of type VoidCallback to perform click operation.
  ///     [color] of type Color to display status color.

  Widget _lockerInfoListTitleWidget({
    required String title,
    required String subTitle,
    required String icon,
    required VoidCallback onClick,
    required Color color,
  }) {
    return Material(
      color: AppColors.colorWhite,
      borderRadius: BorderRadius.circular(Dimen.d_5),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onClick,
        child: DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            borderColor: AppColors.colorPurple4,
            color: AppColors.colorTransparent,
            size: Dimen.d_5,
          ),
          child: Row(
            children: [
              CustomSvgImageView(icon, width: Dimen.d_40, height: Dimen.d_40)
                  .sizedBox(
                    width: Dimen.d_40,
                    height: Dimen.d_40,
                  )
                  .marginOnly(right: Dimen.d_12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorBlack6,
                        fontSizeDelta: -2,
                        fontWeightDelta: 2,
                      ),
                    ).marginOnly(bottom: Dimen.d_4),
                    Text(
                      subTitle,
                      style: CustomTextStyle.bodySmall(context)
                          ?.apply(color: color, fontSizeDelta: -3),
                    )
                  ],
                ),
              )
            ],
          ).paddingAll(Dimen.d_12),
        ),
      ),
    );
  }
}
