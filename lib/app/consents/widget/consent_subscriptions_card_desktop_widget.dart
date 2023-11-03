import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/typedef.dart';
import 'package:abha/export_packages.dart';

class ConsentSubscriptionCardDesktopWidget extends StatelessWidget {
  final ConsentSubscriptionRequestModel request;
  final String requestType;
  final OnConsentClick onClick;
  final bool isDesktopView;
  final Color backgroundColor;

  const ConsentSubscriptionCardDesktopWidget({
    required this.request,
    required this.requestType,
    required this.onClick,
    required this.backgroundColor,
    super.key,
    this.isDesktopView = false,
  });

  @override
  Widget build(BuildContext context) {
    ConsentController controller = Get.find();
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        size: 0,
        borderColor: AppColors.colorTransparent,
        color: backgroundColor,
        isLow: true,
      ),
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: () {
            onClick(request.subscriptionId);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: getTitleText(
                  LocalizationHandler.of().subscription,
                  context,
                ),
              ),
              SizedBox(width: Dimen.d_20),
              Expanded(
                flex: 6,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: getTitleText(
                        request.hiu?.name ?? '',
                        context,
                        align: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: getTitleText(
                        request.purpose?.text ?? '',
                        context,
                        align: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: getTitleText(
                        '${request.period?.from?.formatDDMMMYYYY}',
                        context,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: getTitleText(
                        '${request.period?.to?.formatDDMMMYYYY}',
                        context,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration:
                      abhaSingleton.getBorderDecoration.getRectangularBorder(
                    color: controller.getRequestTypeBackgroundColor(
                      requestType.allInCaps,
                    ),
                    borderColor: AppColors.colorTransparent,
                    size: Dimen.d_30,
                    width: 0,
                  ),
                  child: Text(
                    controller.getLocalizedRequestType(requestType.allInCaps),
                    textAlign: TextAlign.center,
                    key: const Key(KeyConstant.requestStatus),
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color:
                          controller.getRequestTypeColor(requestType.allInCaps),
                      fontWeightDelta: 0,
                    ),
                  ).paddingSymmetric(
                    vertical: Dimen.d_6,
                    horizontal: Dimen.d_6,
                  ),
                ).marginOnly(right: Dimen.d_10),
              ),
              Expanded(
                child: getTitleText(
                  request.lastUpdated.calculatePastTime(),
                  context,
                  align: TextAlign.start,
                ),
              ),
            ],
          ).paddingSymmetric(vertical: Dimen.d_16, horizontal: Dimen.d_14),
        ),
      ),
    );
  }

  Widget getTitleText(String text, BuildContext context, {TextAlign? align}) {
    return Text(
      text,
      textAlign: align,
      style: CustomTextStyle.bodySmall(context)?.apply(
        color: AppColors.colorBlack,
        fontWeightDelta: -1,
      ),
    );
  }
}
