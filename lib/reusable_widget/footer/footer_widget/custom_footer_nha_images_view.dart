import 'package:abha/export_packages.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';

class CustomFooterNhaImagesView extends StatelessWidget {
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  CustomFooterNhaImagesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: Dimen.d_12,
      spacing: Dimen.d_12,
      alignment: WrapAlignment.spaceBetween,
      runAlignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: WidgetUtility.spreadWidgets(
        [
          InkWell(
            onTap: () {
              _launchURLService.launchInBrowserLink(
                Uri.parse(AbdmUrlConstant.getNationalHealthAuthorityUrl()),
              );
            },
            child: CustomSvgImageView(
              ImageLocalAssets.nhaLogo,
              height: Dimen.d_65,
            ),
          ),
          _customNhaImages(
            image: ImageLocalAssets.healthAndFamilyWalefareLogo,
            onClick: () {
              _launchURLService.launchInBrowserLink(
                Uri.parse(
                  AbdmUrlConstant.getMinistryOfHealthAndFamilyWelfareUrl(),
                ),
              );
            },
          ),
          _customNhaImages(
            image: ImageLocalAssets.ministryOfElectronicsITLogo,
            onClick: () {
              _launchURLService.launchInBrowserLink(
                Uri.parse(
                  AbdmUrlConstant.getMinistryOfElectronicAndITUrl(),
                ),
              );
            },
          ),
          _customNhaImages(
            image: ImageLocalAssets.indiaGovInLogo,
            onClick: () {
              _launchURLService.launchInBrowserLink(
                Uri.parse(AbdmUrlConstant.getIndiaGovernmentUrl()),
              );
            },
          ),
          _customNhaImages(
            image: ImageLocalAssets.digitalIndiaLogo,
            onClick: () {
              _launchURLService.launchInBrowserLink(
                Uri.parse(AbdmUrlConstant.getDigitalIndiaGovtUrl()),
              );
            },
          ),
        ],
        interItemSpace: Dimen.d_10,
      ),
    );
  }

  Widget _customNhaImages({
    required VoidCallback onClick,
    required String image,
    double height = 65.0,
  }) {
    return InkWell(
      onTap: onClick,
      child: Image.asset(
        image,
        height: height,
      ),
    );
  }
}
