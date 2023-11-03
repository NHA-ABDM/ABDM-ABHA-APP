import 'package:abha/app/contact_us/contact_us_web_view.dart';
import 'package:abha/export_packages.dart';

class CustomFooterDesktopView extends StatelessWidget {
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  CustomFooterDesktopView({super.key});

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
              horizontal: context.width * 0.10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactAddressAndPoliciesWidget(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorBlueDark1,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: WidgetUtility.spreadWidgets(
              [
                const ContactUsWebView(), // Contact detail
                CustomFooterFaqView(
                  launchURLService: _launchURLService,
                ), // Faqs
                CustomFooterPoliciesView(
                  launchURLService: _launchURLService,
                ), // Policies
                CustomFooterScanAndDownloadAppView(
                  launchURLService: _launchURLService,
                ) // Download App And Scan
              ],
            ),
          )
              .paddingSymmetric(horizontal: context.width * 0.10)
              .paddingOnly(top: Dimen.d_40),
          Divider(thickness: Dimen.d_1_5),
          const CustomFooterDisclaimerView()
              .paddingSymmetric(
                horizontal: context.width * 0.10,
                vertical: Dimen.d_10,
              )
              .marginOnly(bottom: Dimen.d_10) // Disclaimer
        ],
      ),
    );
  }
}
