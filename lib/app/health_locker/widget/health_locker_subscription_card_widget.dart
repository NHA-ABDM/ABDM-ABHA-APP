import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/view_details_card.dart';

class HealthLockerSubscriptionCardWidget extends StatelessWidget {
  final Subscription subscriptionRequest;
  final String requestType;
  final HealthLockerController controller = Get.find<HealthLockerController>();

  HealthLockerSubscriptionCardWidget({
    required this.subscriptionRequest,
    required this.requestType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget getTitleText(String text, {Key? key}) {
      return Text(
        text,
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorGreyDark2,
          fontWeightDelta: 2,
        ),
      );
    }

    Widget getValueText(String text, {Key? key}) {
      return Text(
        text,
        style: CustomTextStyle.labelMedium(context)?.apply(
          color: AppColors.colorGreyDark7,
          fontWeightDelta: -1,
        ),
      ).paddingOnly(top: Dimen.d_10);
    }

    return ViewDetailsCard(
      borderColor: controller
          .getRequestTypeColor(subscriptionRequest.status!.toUpperCase()),
      boxShadowColor: controller
          .getRequestTypeColor(subscriptionRequest.status!.toUpperCase()),
      onClick: () {
        var arguments = {
          IntentConstant.subscriptionID: subscriptionRequest.subscriptionId
        };
        context.navigatePush(
          RoutePath.routeHealthLockerEditSubscription,
          arguments: arguments,
        );
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitleText(
                    subscriptionRequest.requester?.name ?? '',
                    key: const Key(KeyConstant.requester),
                  ),
                  getValueText(LocalizationHandler.of().lockerRequest),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      CustomSvgImageView(
                        controller.getRequestTypeImage(
                          subscriptionRequest.status?.toUpperCase() ?? '',
                        ),
                      ),
                      Text(
                        subscriptionRequest.status ?? '',
                        textAlign: TextAlign.end,
                        style: CustomTextStyle.titleSmall(context)?.apply(
                          color: controller.getRequestTypeColor(
                            subscriptionRequest.status?.toUpperCase() ?? '',
                          ),
                        ),
                      ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
                    ],
                  ),
                  getValueText(
                    subscriptionRequest.dateGranted?.formatDDMMMYYYY ?? '',
                  ),
                ],
              ),
            ],
          ).paddingOnly(left: Dimen.d_20, right: Dimen.d_20, top: Dimen.d_15),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitleText(LocalizationHandler.of().purposeOfRequest),
                  getValueText(
                    subscriptionRequest.purpose?.text ?? '',
                    key: const Key(KeyConstant.purposeOfRequest),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: Dimen.d_20, vertical: Dimen.d_15),
        ],
      ),
    );
  }
}
