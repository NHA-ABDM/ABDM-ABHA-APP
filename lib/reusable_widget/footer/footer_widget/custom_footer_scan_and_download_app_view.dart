import 'package:abha/export_packages.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';

class CustomFooterScanAndDownloadAppView extends StatelessWidget {
  final LaunchURLService launchURLService;

  const CustomFooterScanAndDownloadAppView({
    required this.launchURLService,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textContactTitle(
          LocalizationHandler.of().abhaApplication,
          context,
        ).paddingOnly(bottom: Dimen.d_24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  ImageLocalAssets.nhaAndroidAppQrCode,
                  height: Dimen.d_110,
                  width: Dimen.d_110,
                ).paddingOnly(bottom: Dimen.d_12),
                InkWell(
                  onTap: () {
                    launchURLService.launchInBrowserLink(
                      Uri.parse(AbdmUrlConstant.getPlayStoreUrl()),
                    );
                  },
                  child: SvgPicture.asset(
                    ImageLocalAssets.buttonPlayStoreSvg,
                    width: Dimen.d_110,
                  ),
                ),
              ],
            ).marginOnly(right: Dimen.d_16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  ImageLocalAssets.nhaIosAppQrCode,
                  height: Dimen.d_110,
                  width: Dimen.d_110,
                ).paddingOnly(bottom: Dimen.d_12),
                InkWell(
                  onTap: () {
                    launchURLService.launchInBrowserLink(
                      Uri.parse(AbdmUrlConstant.getAppStoreUrl()),
                    );
                  },
                  child: SvgPicture.asset(
                    ImageLocalAssets.buttonAppStoreSvg,
                    width: Dimen.d_110,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget textContactTitle(String title, BuildContext context) {
    return Text(
      title,
      softWrap: true,
      maxLines: 2,
      style: CustomTextStyle.headlineMedium(context)
          ?.apply(color: AppColors.colorWhite),
    );
  }
}
