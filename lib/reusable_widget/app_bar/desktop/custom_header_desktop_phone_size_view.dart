import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/localization/localization_view.dart';
import 'package:abha/reusable_widget/app_bar/desktop/menu_data/custom_header_menu_data.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_phone_size_view.dart';
import 'package:abha/reusable_widget/popup/custom_popup_button_view.dart';

class CustomHeaderDesktopPhoneSizeView extends StatelessWidget {
  const CustomHeaderDesktopPhoneSizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerLanguageWidget(context),
        _headerLogoWidget(context),
        Container(height: Dimen.d_1, color: AppColors.colorBlueLight5),
      ],
    );
  }

  Widget _headerLanguageWidget(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorPurple4,
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [LocalizationView()],
      ).paddingSymmetric(vertical: Dimen.d_12, horizontal: Dimen.d_16),
    );
  }

  Widget _headerLogoWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: WidgetUtility.spreadWidgets(
            [
              InkWell(
                onTap: () {
                  context.navigateToScreen(
                    CustomDrawerDesktopPhoneSizeView(),
                  );
                },
                child: const CustomSvgImageView(
                  ImageLocalAssets.menu,
                  color: AppColors.colorAppBlue,
                ),
              ).marginOnly(right: Dimen.d_10),
              CustomSvgImageView(
                ImageLocalAssets.nhaLogo,
                height: Dimen.d_50,
              ),
              CustomSvgImageView(
                ImageLocalAssets.abdmLogo,
                height: Dimen.d_50,
              ),
            ],
            interItemSpace: Dimen.d_10,
          ),
        ),
        if (abhaSingleton.getAppData.getLogin() &&
            Get.isRegistered<ProfileController>())
          GetBuilder<DashboardController>(
            builder: (controller) {
              ProfileController profileController =
                  Get.find<ProfileController>();
              ProfileModel? profileModel = profileController.profileModel;
              return CustomPopUpMenuButtonView(
                shapeSize: Dimen.d_5,
                titleColor: AppColors.colorAppBlue1,
                bgColor: AppColors.colorWhite,
                itemBuilder: (BuildContext context) {
                  return CustomHeaderMenuData.getCustomHeaderProfileMenuData(
                    context,
                    false,
                  ).map((CustomHeaderMenuData data) {
                    return PopupMenuItem(
                      value: data,
                      height: Dimen.d_0,
                      padding: EdgeInsets.zero,
                      child: InkWell(
                        onTap: () {
                          context.navigateBack();
                          data.onClick();
                        },
                        child: Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: Dimen.d_16),
                          constraints: BoxConstraints(
                            minWidth: Dimen.d_150,
                            maxHeight: Dimen.d_32,
                            minHeight: Dimen.d_32,
                          ),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                data.iconImage!,
                                width: Dimen.d_20,
                              ).paddingOnly(right: Dimen.d_8),
                              Text(
                                data.title,
                                style: CustomTextStyle.titleMedium(context)
                                    ?.apply(fontWeightDelta: 1),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList();
                },
                title: '',
                leading: CustomCircularBorderBackground(
                  outerRadius: Dimen.d_20,
                  innerRadius: Dimen.d_20,
                  image: profileModel?.profilePhoto,
                ),
              );
            },
          ),
      ],
    ).paddingSymmetric(vertical: Dimen.d_12, horizontal: Dimen.d_16);
  }
}
