import 'package:abha/app/contact_us/contact_us_web_view.dart';
import 'package:abha/export_packages.dart';

class CustomFooterMobileView extends StatelessWidget {
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  CustomFooterMobileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _nhaImagesAndBackToTopButtonWidget(
          context,
        ), // NHA Images and Back To Top Button Widget
        _contactAddressAndPoliciesWidget(
          context,
        ), // Address,Contact,Faqs,Policies and App Scan
      ],
    );
  }

  Widget _nhaImagesAndBackToTopButtonWidget(BuildContext context) {
    return Container(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        isLow: true,
        size: 0,
        borderColor: AppColors.colorGreyWildSand,
        color: AppColors.colorWhite,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomFooterNhaImagesView().paddingSymmetric(
              vertical: Dimen.d_16,
              horizontal: context.width * 0.06,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactAddressAndPoliciesWidget(BuildContext context) {
    return ColoredBox(
      //color: context.themeData.primaryColor,
      color: AppColors.colorBlueDark1,
      child: Column(
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              // spacing: 25.0,
              // runSpacing: 15.0,
              children: WidgetUtility.spreadWidgets(
                [
                  const ContactUsWebView().marginOnly(
                    top: Dimen.d_24,
                  ), // Contact detail and Address
                  CustomFooterFaqView(
                    launchURLService: _launchURLService,
                  ).marginOnly(top: Dimen.d_25), // Faqs
                  CustomFooterPoliciesView(
                    launchURLService: _launchURLService,
                  ).marginOnly(top: Dimen.d_20), // Policies
                  CustomFooterScanAndDownloadAppView(
                    launchURLService: _launchURLService,
                  ).marginOnly(top: Dimen.d_20), // Download app And Scan
                ],
                interItemSpace: Dimen.d_8,
              ),
            ).paddingSymmetric(horizontal: context.width * 0.06),
          ).paddingOnly(bottom: Dimen.d_40),
          Divider(thickness: Dimen.d_1_5),
          const CustomFooterDisclaimerView().paddingSymmetric(
            horizontal: context.width * 0.06,
            vertical: Dimen.d_10,
          ) // Disclaimer
        ],
      ),
    );
  }
}
