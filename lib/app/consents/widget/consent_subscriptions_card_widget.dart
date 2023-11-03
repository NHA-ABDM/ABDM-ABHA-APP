import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/typedef.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/view_details_card.dart';
import 'package:flutter/foundation.dart';

class ConsentSubscriptionCardWidget extends StatelessWidget {
  final ConsentSubscriptionRequestModel request;
  final String requestType;
  final OnConsentClick onClick;
  final bool isDesktopView;

  const ConsentSubscriptionCardWidget({
    required this.request,
    required this.requestType,
    required this.onClick,
    super.key,
    this.isDesktopView = false,
  });

  @override
  Widget build(BuildContext context) {
    ConsentController controller = Get.find();

    Widget getTitleText(String text, {Key? key}) {
      return Text(
        text,
        key: key,
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorGreyDark2,
          fontWeightDelta: 2,
        ),
      );
    }

    Widget getValueText(String text, {Key? key}) {
      return Text(
        text,
        key: key,
        style: CustomTextStyle.bodySmall(context)?.apply(
          color: AppColors.colorGreyDark7,
          fontSizeDelta: -2,
        ),
      ).paddingOnly(top: Dimen.d_5);
    }

    return ViewDetailsCard(
      onClick: () {
        onClick(request.subscriptionId);
      },
      isDeskTopView: isDesktopView,
      borderColor: controller.getRequestTypeColor(requestType.allInCaps),
      boxShadowColor: controller.getRequestTypeColor(requestType.allInCaps),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitleText(
                    request.hiu?.name ?? '',
                    key: const Key(KeyConstant.hiuName),
                  ),
                  getValueText(LocalizationHandler.of().subscriptionRequest),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        controller.getRequestTypeImage(requestType.allInCaps),
                      ),
                      Text(
                        requestType,
                        key: const Key(KeyConstant.requestStatus),
                        style: CustomTextStyle.titleSmall(context)?.apply(
                          color: controller
                              .getRequestTypeColor(requestType.allInCaps),
                        ),
                      ).marginOnly(left: Dimen.d_10, right: Dimen.d_10),
                    ],
                  ),
                  getValueText(request.lastUpdated.calculatePastTime()),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: Dimen.d_15, vertical: Dimen.d_15),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitleText(LocalizationHandler.of().purposeOfRequest),
                  getValueText(
                    request.purpose?.text ?? '',
                    key: const Key(KeyConstant.purposeOfRequest),
                  ),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: Dimen.d_15, vertical: Dimen.d_10),
          if (request.period != null && !kIsWeb)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTitleText(LocalizationHandler.of().informationRequest),
                    getValueText(
                      '${LocalizationHandler.of().from} ${request.period?.from?.formatDDMMMYYYY} ${LocalizationHandler.of().to} ${request.period?.to?.formatDDMMMYYYY}',
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: Dimen.d_15, vertical: Dimen.d_10),
          if (kIsWeb)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTitleText(
                      request.period != null
                          ? LocalizationHandler.of().informationRequest
                          : '',
                    ),
                    getValueText(
                      request.period != null
                          ? '${LocalizationHandler.of().from} ${request.period?.from?.formatDDMMMYYYY} ${LocalizationHandler.of().to} ${request.period?.to?.formatDDMMMYYYY}'
                          : '',
                    ),
                    // getValueText(
                    //   request.period != null
                    //       ? '${LocalizationHandler.of().from} ${request.period?.from?.formatDDMMMYYYY} ${LocalizationHandler.of().to} ${request.period?.to?.formatDDMMMYYYY}'
                    //       : '',
                    // ),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: Dimen.d_15, vertical: Dimen.d_10),
        ],
      ),
    );
  }
}
