import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

/// Here Widget [_noFacilityLinkedView] will be shown if there is no
/// any facility linked to the users account.
///
/// You can click on button  " Linked New Facility " to link the records.
class DashboardNoFacilityLinkedView extends StatelessWidget {
  final VoidCallback onLinkFacilityClick;

  const DashboardNoFacilityLinkedView({
    required this.onLinkFacilityClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? webView(context) : mobileView(context);
  }

  Widget mobileView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          ImageLocalAssets.noFacilityLinkAcountImage,
          height: context.height * 0.16,
        ).marginOnly(top: Dimen.d_20),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: CustomTextStyle.bodySmall(context)
                ?.apply(color: AppColors.colorBlack6, fontWeightDelta: -1),
            children: <TextSpan>[
              TextSpan(
                text: LocalizationHandler.of().noFacilityLinked,
              ),
              TextSpan(
                text: '${LocalizationHandler.of().linkNewFacility} ',
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorBlack6, fontWeightDelta: 3),
              ),
              TextSpan(
                text: LocalizationHandler.of().btnToLinkFacility,
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorBlack6, fontWeightDelta: -1),
              ),
            ],
          ),
        )
            .marginOnly(top: Dimen.d_15, bottom: Dimen.d_20)
            .paddingOnly(left: Dimen.d_30, right: Dimen.d_30),
      ],
    ).centerWidget.sizedBox(height: context.height / 2.5).paddingAll(Dimen.d_2);
  }

  Widget webView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          ImageLocalAssets.noFacilityLinkAcountImage,
          height: context.height * 0.30,
        ).marginOnly(top: Dimen.d_20, bottom: Dimen.d_16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: CustomTextStyle.bodySmall(context)?.apply(
              color: AppColors.colorBlack6,
              fontWeightDelta: -1,
              heightDelta: 0.2,
            ),
            children: <TextSpan>[
              TextSpan(
                text: LocalizationHandler.of().noFacilityLinked,
              ),
              TextSpan(
                text: '${LocalizationHandler.of().linkNewFacility} ',
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorBlack6, fontWeightDelta: 3),
              ),
              TextSpan(
                text: LocalizationHandler.of().btnToLinkFacility,
                style: CustomTextStyle.bodySmall(context)
                    ?.apply(color: AppColors.colorBlack6, fontWeightDelta: -1),
              ),
            ],
          ),
        )
            .marginOnly(top: Dimen.d_15, bottom: Dimen.d_20)
            .paddingOnly(left: Dimen.d_30, right: Dimen.d_30),
        TextButtonOrange.desktop(
          text: LocalizationHandler.of().linkNewFacility,
          leading: ImageLocalAssets.linkedFacilityChainIconSvg,
          onPressed: onLinkFacilityClick,
        )
      ],
    )
        .centerWidget
        .marginOnly(bottom: Dimen.d_30); //.sizedBox(height: context.height);
  }
}
