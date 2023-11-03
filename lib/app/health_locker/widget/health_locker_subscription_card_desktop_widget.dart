import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/table/table_row_view.dart';

class HealthLockerSubscriptionCardDesktopWidget extends StatelessWidget {
  final Subscription subscriptionRequest;
  final String requestType;
  final HealthLockerController controller = Get.find<HealthLockerController>();
  final Color backgroundColor;
  final VoidCallback onClick;

  HealthLockerSubscriptionCardDesktopWidget({
    required this.subscriptionRequest,
    required this.requestType,
    required this.backgroundColor,
    required this.onClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget getTitleText(String text, {TextAlign? align}) {
      return Text(
        text,
        textAlign: align,
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorBlack,
          fontWeightDelta: -1,
        ),
      );
    }

    return TableRowView(
      onClick: () => onClick(),
      backgroundColor: backgroundColor,
      children: [
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: getTitleText(
                  subscriptionRequest.requester?.name ?? '',
                  align: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 2,
                child: getTitleText(
                  subscriptionRequest.purpose?.text ?? '',
                  align: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 1,
                child: getTitleText(
                  '${subscriptionRequest.dateGranted?.formatDDMMMMYYYY}',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
              color: controller.getRequestTypeBackgroundColor(
                subscriptionRequest.status!.allInCaps,
              ),
              borderColor: AppColors.colorTransparent,
              size: Dimen.d_30,
              width: 0,
            ),
            child: Text(
              subscriptionRequest.status ?? '',
              textAlign: TextAlign.center,
              key: const Key(KeyConstant.requestStatus),
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: controller
                    .getRequestTypeColor(subscriptionRequest.status!.allInCaps),
                fontWeightDelta: 0,
              ),
            ).paddingSymmetric(vertical: Dimen.d_6, horizontal: Dimen.d_4),
          ),
        ),
      ],
    );
  }
}
