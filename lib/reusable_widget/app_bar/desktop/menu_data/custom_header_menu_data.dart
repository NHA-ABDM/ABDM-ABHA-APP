import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/utils/constants/abdm_url_constant.dart';

class CustomHeaderMenuData {
  String title;
  IconData? iconName;
  String? iconImage;
  VoidCallback onClick;

  CustomHeaderMenuData({
    required this.title,
    required this.onClick,
    this.iconName,
    this.iconImage,
  });

  static List<CustomHeaderMenuData> getAboutABDMData(
    BuildContext context,
    LaunchURLService launchURLService,
  ) {
    return [
      CustomHeaderMenuData(
        title: LocalizationHandler.of().abdm,
        iconName: IconAssets.unCheckedRounded,
        onClick: () {
          launchURLService.launchInBrowserLink(
            Uri.parse(AbdmUrlConstant.getAboutABDMUrl()),
          );
        },
      ),
      CustomHeaderMenuData(
        title: LocalizationHandler.of().nha,
        iconName: IconAssets.unCheckedRounded,
        onClick: () {
          launchURLService
              .launchInBrowserLink(Uri.parse(AbdmUrlConstant.getAboutNHAUrl()));
        },
      ),
    ];
  }

  static List<CustomHeaderMenuData> getSupportData(
    BuildContext context,
    LaunchURLService launchURLService,
  ) {
    return [
      CustomHeaderMenuData(
        title: LocalizationHandler.of().grievancePortal.toTitleCase(),
        iconName: IconAssets.unCheckedRounded,
        onClick: () {
          launchURLService.launchInBrowserLink(
            Uri.parse(AbdmUrlConstant.getGrievancePortal()),
          );
        },
      ),
      CustomHeaderMenuData(
        title: LocalizationHandler.of().contactUs.toTitleCase(),
        iconName: IconAssets.unCheckedRounded,
        onClick: () {
          context.navigatePush(RoutePath.routeSupport);
        },
      ),
    ];
  }

  static List<CustomHeaderMenuData> getResourceCenterData(
    BuildContext context,
    LaunchURLService launchURLService,
  ) {
    return [
      CustomHeaderMenuData(
        title: LocalizationHandler.of().healthDataManagementPolicy,
        iconName: IconAssets.unCheckedRounded,
        onClick: () {
          launchURLService.launchInBrowserLink(
            Uri.parse(AbdmUrlConstant.getHealthDataManagementUrl()),
          );
        },
      ),
      CustomHeaderMenuData(
        title: LocalizationHandler.of().newsAndMedia,
        iconName: IconAssets.unCheckedRounded,
        onClick: () {
          launchURLService.launchInBrowserLink(
            Uri.parse(AbdmUrlConstant.getHealthDataManagementUrl()),
          );
        },
      ),
    ];
  }

  static List<CustomHeaderMenuData> getCustomHeaderProfileMenuData(
    BuildContext context,
    bool isWebMobile,
  ) {
    return [
      CustomHeaderMenuData(
        title: LocalizationHandler.of().my_profile,
        iconName: IconAssets.unCheckedRounded,
        iconImage: ImageLocalAssets.profile,
        onClick: () {
          context.navigatePush(RoutePath.routeProfileView);
        },
      ),
      CustomHeaderMenuData(
        title: LocalizationHandler.of().switchAccount,
        iconImage: ImageLocalAssets.switchAccountIconOrangeSvg,
        onClick: () {
          ProfileController profileController = Get.find<ProfileController>();
          profileController.mappedPhrAddress = [];
          profileController
              .functionHandler(
            function: () => profileController.getSwitchAccountUsers(),
            isLoaderReq: true,
          )
              .whenComplete(() {
            profileController.mappedPhrAddress = [];
            Map data = profileController.responseHandler.data;
            if (data.isNotEmpty) {
              for (Map<String, dynamic> jsonMap
                  in data[ApiKeys.responseKeys.users]) {
                profileController.mappedPhrAddress
                    .add(ProfileModel.fromMappedUserMap(jsonMap));
              }
              profileController.abhaAddressSelectedValue =
                  profileController.profileModel?.abhaAddress ?? '';
              profileController.showUserList(context, isWebMobile: isWebMobile);
            }
          });
        },
      ),
      CustomHeaderMenuData(
        title: LocalizationHandler.of().drawer_logout,
        iconImage: ImageLocalAssets.logout,
        onClick: () {
          Get.find<DashboardController>().showLogoutPopup(context);
        },
      ),
    ];
  }
}
