import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/typedef.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/view_details_card.dart';

class ConsentCardWidget extends StatelessWidget {
  final ConsentRequestModel request;
  final String requestType;
  final OnConsentClick onClick;
  final ConsentController controller;
  final bool isDeskTopView;

  const ConsentCardWidget({
    required this.request,
    required this.requestType,
    required this.onClick,
    required this.controller,
    super.key,
    this.isDeskTopView = false,
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
        onClick(request.id);
      },
      isDeskTopView: isDeskTopView,
      boxShadowColor: controller.getRequestTypeColor(requestType.allInCaps),
      borderColor: controller.getRequestTypeColor(requestType.allInCaps),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getTitleText(request.requester?.name ?? ''),
                  getValueText(LocalizationHandler.of().consentsRequestTitle),
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
          if (request.permission != null)
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getTitleText(LocalizationHandler.of().informationRequest),
                    getValueText(
                      '${LocalizationHandler.of().from} ${request.permission?.dateRange?.from?.formatDDMMMYYYY} ${LocalizationHandler.of().to} ${request.permission?.dateRange?.to?.formatDDMMMYYYY}',
                    ),
                  ],
                ),
              ],
            ).paddingSymmetric(horizontal: Dimen.d_15, vertical: Dimen.d_10),
        ],
      ),
    );
  }
}
