import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/hover/hover_widget.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';

class CustomFooterPoliciesView extends StatelessWidget {
  final LaunchURLService launchURLService;

  const CustomFooterPoliciesView({required this.launchURLService, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textContactTitle(LocalizationHandler.of().policies, context)
            .marginOnly(bottom: Dimen.d_25),
        textLink(LocalizationHandler.of().healthDataManagementPolicy, context,
            () {
          launchURLService.openInAppWebView(
            context,
            title: LocalizationHandler.of().healthDataManagementPolicy,
            url: AbdmUrlConstant.getHealthDataPolicy(),
          );
        }),
        textLink(
          LocalizationHandler.of().dataPrivacyPolicy,
          context,
          () {
            launchURLService.openInAppWebView(
              context,
              title: LocalizationHandler.of().dataPrivacyPolicy,
              url: AbdmUrlConstant.getDataPrivacyPolicy(),
            );
          },
        ),
        textLink(LocalizationHandler.of().drawer_privacy_policy.toTitleCase(), context, () {
          launchURLService.openInAppWebView(
            context,
            title: LocalizationHandler.of().drawer_privacy_policy.toTitleCase(),
            url: AbdmUrlConstant.getPrivacyNoticeUrl(),
          );
        }),
        textLink(LocalizationHandler.of().termsOfUse, context,
            () {
          launchURLService.openInAppWebView(
            context,
            title: LocalizationHandler.of()
                .drawer_terms_and_condition
                .toTitleCase(),
            url: AbdmUrlConstant.getTermsConditionsUrl(),
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
