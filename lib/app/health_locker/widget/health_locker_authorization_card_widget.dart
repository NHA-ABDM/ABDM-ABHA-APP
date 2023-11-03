import 'package:abha/app/health_locker/model/health_locker_info_model.dart';
import 'package:abha/export_packages.dart';

class HealthLockerAuthorizationCardWidget extends StatelessWidget {
  final Authorization authorizationRequest;
  final String requestType;
  final HealthLockerController controller = Get.find<HealthLockerController>();

  HealthLockerAuthorizationCardWidget({
    required this.authorizationRequest,
    required this.requestType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Widget getTitleText(String text) {
      return Text(
        text,
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorGreyDark2,
          fontWeightDelta: 2,
        ),
      );
    }

    Widget getValueText(String text) {
      return Text(
        text,
        style: CustomTextStyle.labelMedium(context)?.apply(
          color: AppColors.colorGreyDark7,
          fontWeightDelta: -1,
        ),
      ).paddingOnly(top: Dimen.d_10);
    }

    return Column(
      children: [
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getElevation(
            isLow: true,
            size: Dimen.d_15,
            color: AppColors.colorWhite,
            borderColor: controller
                .getRequestTypeColor(authorizationRequest.status ?? ''),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTitleText(authorizationRequest.requester?.name ?? ''),
                      getValueText(LocalizationHandler.of().lockerRequest),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          CustomSvgImageView(
                            controller.getRequestTypeImage(
                              authorizationRequest.status ?? '',
                            ),
                          ),
                          Text(
                            requestType,
                            textAlign: TextAlign.end,
                            style: CustomTextStyle.titleSmall(context)?.apply(
                              color: controller.getRequestTypeColor(
                                authorizationRequest.status ?? '',
                              ),
                            ),
                          ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
                        ],
                      ),
                      getValueText(
                        authorizationRequest.createdAt?.formatDDMMMMYYYY ?? '',
                      ),
                    ],
                  ),
                ],
              ).paddingSymmetric(horizontal: Dimen.d_20, vertical: Dimen.d_15),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getTitleText(
                        LocalizationHandler.of().purposeOfRequest,
                      ),
                      getValueText(
                        authorizationRequest.purpose?.text ?? '',
                      ),
                    ],
                  ),
                ],
              ).paddingSymmetric(horizontal: Dimen.d_20, vertical: Dimen.d_10),
              const Divider(
                thickness: 2,
                color: AppColors.colorGrey2,
              ),
              InkWell(
                onTap: () {
                  var arguments = {
                    IntentConstant.authorizationRequestId:
                        authorizationRequest.requestId
                  };
                  context.navigatePush(
                    RoutePath.routeHealthLockerAuthorizationRequest,
                    arguments: arguments,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      IconAssets.openEye,
                      color: AppColors.colorBlueDark1,
                    ).marginOnly(right: Dimen.d_10),
                    Text(
                      LocalizationHandler.of().viewDetails,
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorGreyDark9,
                      ),
                    ).marginOnly(left: Dimen.d_10, right: Dimen.d_10),
                  ],
                ).paddingSymmetric(
                  horizontal: Dimen.d_20,
                  vertical: Dimen.d_10,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
