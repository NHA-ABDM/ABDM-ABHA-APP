import 'package:abha/export_packages.dart';

class ContactUsMobileView extends StatefulWidget {
  const ContactUsMobileView({super.key});

  @override
  ContactUsMobileViewState createState() => ContactUsMobileViewState();
}

class ContactUsMobileViewState extends State<ContactUsMobileView> {
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  @override
  Widget build(BuildContext context) {
    return BaseView(
      type: ContactUsMobileView,
      title: LocalizationHandler.of().contactUs.toTitleCase(),
      bodyMobile: SafeArea(
        child: _contactUsWidget(),
      ),
    );
  }

  Widget _contactUsWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textContactTitle(LocalizationHandler.of().addres),
        textContactValue(LocalizationHandler.of().detailAddress),
        textContactTitle(LocalizationHandler.of().tollFreeNo),
        textContactValue(LocalizationHandler.of().tollFreeNoWeb),
        textContactTitle(LocalizationHandler.of().emailId),
        textContactValue(LocalizationHandler.of().contactEmail),
        textContactTitle(LocalizationHandler.of().socialMedia),
        contactThroughSocialMedia().marginOnly(top: Dimen.d_20)
      ],
    );
  }

  /// @Here common widget to display the title text.
  /// Param [title] of type String.
  Widget textContactTitle(String title) {
    return Text(
      title,
      style: CustomTextStyle.bodyLarge(context)
          ?.apply(color: AppColors.colorGrey3, fontWeightDelta: 1),
    ).marginOnly(left: Dimen.d_10, right: Dimen.d_10, top: Dimen.d_20);
  }

  /// @Here common widget to display the title text.
  /// Param [value] of type String.
  Widget textContactValue(String value) {
    return Text(
      value,
      style: CustomTextStyle.bodySmall(context)?.apply(
        color: AppColors.colorAppBlue,
      ),
    ).marginOnly(left: Dimen.d_10, right: Dimen.d_10, top: Dimen.d_10);
  }

  /// @Here Widget displays the social media icons in Row.
  Widget contactThroughSocialMedia() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        iconsSocialMedia(
          icons: ImageLocalAssets.facebookSvg,
          onClick: () {
            _launchURLService
                .launchInBrowserLink(Uri.parse(StringConstants.facebookLink));
          },
        ).marginOnly(left: Dimen.d_10),
        iconsSocialMedia(
          icons: ImageLocalAssets.youtubeSvg,
          onClick: () {
            _launchURLService
                .launchInBrowserLink(Uri.parse(StringConstants.youtubeLink));
          },
        ).marginOnly(left: Dimen.d_20),
        iconsSocialMedia(
          icons: ImageLocalAssets.twitterSvg,
          onClick: () {
            _launchURLService
                .launchInBrowserLink(Uri.parse(StringConstants.twitterLink));
          },
        ).marginOnly(left: Dimen.d_20),
        iconsSocialMedia(
          icons: ImageLocalAssets.instagramSvg,
          onClick: () {
            _launchURLService.launchInBrowserLink(
              Uri.parse(StringConstants.instagramLink),
            );
          },
        ).marginOnly(left: Dimen.d_20),
      ],
    );
  }

  /// @Here common widget to show icon of Social Media
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
