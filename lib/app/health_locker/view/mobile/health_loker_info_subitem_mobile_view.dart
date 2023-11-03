import 'package:abha/app/consents/consent_constants.dart';
import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';

class HealthLockerInfoSubItemMobileView extends StatefulWidget {
  final Map arguments;
  final Function(String lockerId) onFetchLockerInfo;

  const HealthLockerInfoSubItemMobileView({
    required this.arguments,
    required this.onFetchLockerInfo,
    super.key,
  });

  @override
  HealthLockerInfoSubItemMobileViewState createState() =>
      HealthLockerInfoSubItemMobileViewState();
}

class HealthLockerInfoSubItemMobileViewState
    extends State<HealthLockerInfoSubItemMobileView> {
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
    return getLockerSubInfoView();
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

    return Column(
      children: [
        Text(
          lockerType,
          style: CustomTextStyle.titleSmall(context)?.apply(
            color: AppColors.colorBlack6,
            fontWeightDelta: 2,
            fontSizeDelta: 5,
          ),
        ).marginOnly(bottom: Dimen.d_15).alignAtTopLeft(),

        /// Display card of Subscription with status
        _lockerInfoListTitleWidget(
          title: LocalizationHandler.of().subscription,
          subTitle: Validator.isNullOrEmpty(subscriptionsResult)
              ? LocalizationHandler.of().not_approved
              : LocalizationHandler.of().approved,
          icon: ImageLocalAssets.lokerSubscriptionIconSvg,
          onClick: () {
            if (!Validator.isNullOrEmpty(subscriptionsResult)) {
              var arguments = {
                IntentConstant.fromScreen: StringConstants.forSubscription,
                IntentConstant.data: healthLockerInfoModel.subscriptions
              };
              context.navigatePush(
                RoutePath.routeHealthLockerInfo,
                arguments: arguments,
              );
            }
          },
          color: Validator.isNullOrEmpty(subscriptionsResult)
              ? AppColors.colorGrey
              : AppColors.colorGreen,
        ).marginOnly(bottom: Dimen.d_15),

        /// Display Auto Approve with status
        _lockerInfoListTitleWidget(
          title: LocalizationHandler.of().auto_approval,
          subTitle: //Validator.isNullOrEmpty(autoApprovalsresult)
              isAutoApprove
                  ? LocalizationHandler.of().approved
                  : LocalizationHandler.of().not_approved,
          icon: ImageLocalAssets.lokerApproveIconSvg,
          onClick: () {
            if (Validator.isNullOrEmpty(healthLockerInfoModel.autoApprovals)) {
              MessageBar.showToastDialog(
                LocalizationHandler.of().unableToCompleteRequest,
              );
              return;
            }
            var arguments = {
              //IntentConstant.data: autoApprovalsresult,
              IntentConstant.data: isAutoApprove,
              IntentConstant.approveId: healthLockerInfoModel.autoApprovals,
            };
            context
                .navigatePush(
                  RoutePath.routeHealthLockerAutoAccessData,
                  arguments: arguments,
                )
                .then(
                  (value) => {_reloadThePage()},
                );
          },
          color: //Validator.isNullOrEmpty(autoApprovalsresult)
              isAutoApprove ? AppColors.colorGreen : AppColors.colorRed,
        ),
      ],
    );
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
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        color: AppColors.colorWhite,
        borderColor: AppColors.colorWhite,
        isLow: true,
        size: Dimen.d_8,
      ),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(Dimen.d_8)),
        clipBehavior: Clip.hardEdge,
        child: ListTile(
          onTap: onClick,
          leading: CustomSvgImageView(
            icon,
            width: Dimen.d_40,
            height: Dimen.d_40,
          ),
          title: Text(
            title,
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorBlack6,
              fontSizeDelta: -2,
              fontWeightDelta: 2,
            ),
          ),
          subtitle: Text(
            subTitle,
            style: CustomTextStyle.bodySmall(context)
                ?.apply(color: color, fontSizeDelta: -3),
          ),
          trailing: Icon(
            IconAssets.navigateNext,
            size: Dimen.d_20,
          ),
        ),
      ),
    );
  }
}
