import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/hover/hover_widget.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';

class CustomFooterFaqView extends StatelessWidget {
  final LaunchURLService launchURLService;

  const CustomFooterFaqView({required this.launchURLService, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textContactTitle(LocalizationHandler.of().importantLinks, context)
            .marginOnly(bottom: Dimen.d_25),
        textLink(LocalizationHandler.of().mohfw, context, () {
          launchURLService.openInAppWebView(
            context,
            title: LocalizationHandler.of().mohfw,
            url: AbdmUrlConstant.getMinistryOfHealthAndFamilyWelfareUrl(),
          );
        }),
        textLink(LocalizationHandler.of().ayushmanBharatDigitalMission, context,
            () {
          launchURLService.openInAppWebView(
            context,
            title: LocalizationHandler.of().ayushmanBharatDigitalMission,
            url: AbdmUrlConstant.getABDMUrl(),
          );
        }),
        textLink(LocalizationHandler.of().grievancePortal, context, () {
          launchURLService.openInAppWebView(
            context,
            title: LocalizationHandler.of().grievancePortal.toTitleCase(),
            url: AbdmUrlConstant.getGrievancePortal(),
          );
        }),
        textLink(LocalizationHandler.of().faqs, context, () {
          launchURLService.openInAppWebView(
            context,
            title: LocalizationHandler.of().drawer_faq,
            url: AbdmUrlConstant.faqUrl,
          );
        })
      ],
    );
  }

  Widget textContactTitle(String title, BuildContext context) {
    return Text(
      title,
      style: CustomTextStyle.headlineMedium(context)
          ?.apply(color: AppColors.colorWhite),
    );
  }

  Widget textLink(String value, BuildContext context, VoidCallback onClick) {
    return InkWell(
      onTap: onClick,
      child: HoverWidget(
        hoverChild: RichText(
          text: TextSpan(
            style:
                CustomTextStyle.titleSmall(context)?.apply(fontWeightDelta: -1),
            children: [
              TextSpan(
                text: '\u23FA ',
                style: CustomTextStyle.titleMedium(context)?.apply(
                  color: AppColors.colorWhite,
                  fontSizeDelta: -2,
                ),
              ),
              TextSpan(
                text: value,
                style: CustomTextStyle.titleMedium(context)?.apply(
                  color: AppColors.colorWhite,
                  decoration: TextDecoration.underline,
                  decorationThicknessDelta: 1.0,
                ),
              ),
            ],
          ),
        ),
        onHover: (PointerEnterEvent event) {},
        child: RichText(
          text: TextSpan(
            style:
                CustomTextStyle.titleSmall(context)?.apply(fontWeightDelta: -1),
            children: [
              TextSpan(
                text: '\u23FA ',
                style: CustomTextStyle.titleMedium(context)?.apply(
                  color: AppColors.colorWhite,
                  fontSizeDelta: -2,
                ),
              ),
              TextSpan(
                text: value,
                style: CustomTextStyle.titleMedium(context)?.apply(
                  color: AppColors.colorWhite,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ).marginOnly(bottom: Dimen.d_16),
    );
  }
}
