import 'package:abha/app/consents/model/export_modules.dart';
import 'package:abha/app/consents/typedef.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/table/table_row_view.dart';

class ConsentCardDesktopWidget extends StatelessWidget {
  final ConsentRequestModel request;
  final String requestType;
  final OnConsentClick onClick;
  final ConsentController controller;
  final bool isDeskTopView;
  final Color backgroundColor;

  const ConsentCardDesktopWidget({
    required this.request,
    required this.requestType,
    required this.onClick,
    required this.controller,
    required this.backgroundColor,
    super.key,
    this.isDeskTopView = false,
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
      onClick: () {
        onClick(request.id);
      },
      backgroundColor: backgroundColor,
      children: [
        Expanded(child: getTitleText(LocalizationHandler.of().consent)),
        SizedBox(width: Dimen.d_20),
        Expanded(
          flex: 6,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: getTitleText(
                  request.requester?.name ?? '',
                  align: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 2,
                child: getTitleText(
                  request.purpose?.text ?? '',
                  align: TextAlign.left,
                ),
              ),
              Expanded(
                flex: 1,
                child: getTitleText(
                  '${request.permission?.dateRange?.from?.formatDDMMMYYYY}',
                ),
              ),
              Expanded(
                flex: 1,
                child: getTitleText(
                  '${request.permission?.dateRange?.to?.formatDDMMMYYYY}',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: DecoratedBox(
            decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
              color: controller
                  .getRequestTypeBackgroundColor(requestType.allInCaps),
              borderColor: AppColors.colorTransparent,
              size: Dimen.d_30,
              width: 0,
            ),
            child: Text(
              controller.getLocalizedRequestType(requestType.allInCaps),
              textAlign: TextAlign.center,
              key: const Key(KeyConstant.requestStatus),
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: controller.getRequestTypeColor(requestType.allInCaps),
                fontWeightDelta: 0,
              ),
            ).paddingSymmetric(vertical: Dimen.d_6, horizontal: Dimen.d_6),
          ).marginOnly(right: Dimen.d_10),
        ),
        Expanded(
          child: getTitleText(
            request.lastUpdated.calculatePastTime(),
            align: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
