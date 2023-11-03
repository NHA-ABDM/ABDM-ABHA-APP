import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/hover/hover_widget.dart';

class ContactUsWebView extends StatefulWidget {
  const ContactUsWebView({super.key});

  @override
  ContactUsWebViewState createState() => ContactUsWebViewState();
}

class ContactUsWebViewState extends State<ContactUsWebView> {
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  @override
  Widget build(BuildContext context) {
    return _contactUsWidget();
  }

  Widget _contactUsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textContactTitle(LocalizationHandler.of().contact),
        Text(
          LocalizationHandler.of().addres,
          style: CustomTextStyle.titleLarge(context)
              ?.apply(color: AppColors.colorWhite),
        ).marginOnly(top: Dimen.d_25),
        textContactValue(LocalizationHandler.of().detailAddress),
        Text(
          LocalizationHandler.of().emailId,
          style: CustomTextStyle.titleLarge(context)
              ?.apply(color: AppColors.colorWhite),
        ).marginOnly(top: Dimen.d_5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _launchURLService.launchInBrowserLink(
                  Uri(
                    scheme: 'mailto',
                    path: 'abdm@nha.gov.in',
                  ),
                );
              },
              child: HoverWidget(
                onHover: (event) {},
                hoverChild: Text(
                  'abdm[at]nha[dot]gov[dot]in',
                  style: CustomTextStyle.titleMedium(context)?.apply(
                    color: AppColors.colorWhite,
                    decoration: TextDecoration.underline,
                    // TEST: comment decorationThicknessDelta line for test case
                    decorationThicknessDelta: 1.0,
                  ),
                ),
                child: Text(
                  'abdm[at]nha[dot]gov[dot]in',
                  style: CustomTextStyle.titleMedium(context)?.apply(
                    color: AppColors.colorWhite,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            )
          ],
        ).marginOnly(bottom: Dimen.d_16, top: Dimen.d_5),
        Text(
          LocalizationHandler.of().tollFreeNo,
          style: CustomTextStyle.titleLarge(context)
              ?.apply(color: AppColors.colorWhite),
        ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '1800-11-4477 / 14477',
              style: CustomTextStyle.titleMedium(context)?.apply(
                color: AppColors.colorWhite,
              ),
            ),
          ],
        ).marginOnly(bottom: Dimen.d_16),
        Text(
          LocalizationHandler.of().socialMedia,
          style: CustomTextStyle.titleLarge(context)
              ?.apply(color: AppColors.colorWhite),
        ).marginOnly(top: Dimen.d_5, bottom: Dimen.d_5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            iconsSocialMedia(
              icons: ImageLocalAssets.facebookSvg,
              onClick: () {
                _launchURLService.launchInBrowserLink(
                  Uri.parse(StringConstants.facebookLink),
                );
              },
            ).marginOnly(right: Dimen.d_8),
            iconsSocialMedia(
              icons: ImageLocalAssets.youtubeSvg,
              onClick: () {
                _launchURLService.launchInBrowserLink(
                  Uri.parse(StringConstants.youtubeLink),
                );
              },
            ).marginOnly(right: Dimen.d_8),
            iconsSocialMedia(
              icons: ImageLocalAssets.twitterSvg,
              onClick: () {
                _launchURLService.launchInBrowserLink(
                  Uri.parse(StringConstants.twitterLink),
                );
              },
            ).marginOnly(right: Dimen.d_8),
            iconsSocialMedia(
              icons: ImageLocalAssets.instagramSvg,
              onClick: () {
                _launchURLService.launchInBrowserLink(
                  Uri.parse(StringConstants.instagramLink),
                );
              },
            ).marginOnly(right: Dimen.d_8),
          ],
        ).marginOnly(bottom: Dimen.d_16),
      ],
    );
  }

  /// @Here common widget to display the title text.
  /// Param [title] of type String.
  Widget textContactTitle(String title) {
    return Text(
      title,
      style: CustomTextStyle.headlineMedium(context)
          ?.apply(color: AppColors.colorWhite),
    );
  }

  /// @Here common widget to display the title text.
  /// Param [value] of type String.
  Widget textContactValue(String value) {
    return Text(
      value,
      style: CustomTextStyle.titleMedium(context)?.apply(
        color: AppColors.colorWhite,
        heightFactor: 1.5,
      ),
    ).marginOnly(bottom: Dimen.d_16);
  }

  Widget iconsSocialMedia({
    required String icons,
    required VoidCallback onClick,
  }) {
    return InkWell(
      onTap: onClick,
      child: Container(
        color: AppColors.colorWhite,
        child: CustomSvgImageView(
          width: Dimen.d_28,
          icons,
          color: AppColors.colorAppBlue1,
        ).paddingAll(Dimen.d_4),
      ),
    );
  }
}
