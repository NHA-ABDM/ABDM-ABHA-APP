import 'package:abha/export_packages.dart';
import 'package:abha/localization/localization_view.dart';
import 'package:abha/reusable_widget/app_bar/desktop/menu_data/custom_header_menu_data.dart';
import 'package:abha/reusable_widget/popup/custom_popup_button_view.dart';

class CustomHeaderDesktopView extends StatelessWidget {
  final Type? type;
  final LaunchURLService _launchURLService = LaunchURLServiceImpl();

  CustomHeaderDesktopView({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _headerLanguageWidget(context),
        _headerLogoWidget(context),
        if(!abhaSingleton.getAppData.getLogin())
          _headerOptionWidget(context)
        else
          Container(height: Dimen.d_1, color: AppColors.colorBlueLight5),
      ],
    );
  }

  Widget _headerLanguageWidget(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorBlueLight8,
      child: const IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [LocalizationView()],
        ),
      ).paddingSymmetric(
        vertical: Dimen.d_6,
        horizontal: !abhaSingleton.getAppData.getLogin() ? context.width * 0.10 : Dimen.d_50,
      ),
    );
  }

  Widget _headerLogoWidget(BuildContext context) {
    return ColoredBox(
      color: AppColors.colorWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: WidgetUtility.spreadWidgets(
              [
                SvgPicture.asset(
                  ImageLocalAssets.nhaLogo,
                  fit: BoxFit.cover,
                  height: Dimen.d_55,
                ),
                CustomSvgImageView(
                  ImageLocalAssets.abdmLogo,
                  fit: BoxFit.cover,
                  height: Dimen.d_55,
                ),
              ],
              interItemSpace: Dimen.d_10,
            ),
          ),
          if (!abhaSingleton.getAppData.getLogin())
            Row(
              children: [
                TextButtonOrange.desktop(
                  text: LocalizationHandler.of().createAbhaAddress,
                  onPressed: () {
                    context.navigatePush(RoutePath.routeRegistration);
                  },
                ),
              ],
            ),
          if (abhaSingleton.getAppData.getLogin() && Get.isRegistered<ProfileController>())
            GetBuilder<ProfileController>(
              builder: (controller) {
                ProfileModel? profileModel = controller.profileModel;
                String kycStatus = profileModel?.kycStatus ?? '';
                bool isKycVerified = kycStatus == StringConstants.kycStatus ? true : false;
                return profileModel != null
                    ? CustomPopUpMenuButtonView(
                        shapeSize: Dimen.d_5,
                        titleColor: AppColors.colorAppBlue1,
                        bgColor: AppColors.colorWhite,
                        itemBuilder: (BuildContext context) {
                          return CustomHeaderMenuData.getCustomHeaderProfileMenuData(context,true).map((CustomHeaderMenuData data) {
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
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Dimen.d_16,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: Dimen.d_150,
                                    maxHeight: Dimen.d_32,
                                    minHeight: Dimen.d_32,
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        data.iconImage ?? '',
                                        width: Dimen.d_20,
                                      ).paddingOnly(right: Dimen.d_8),
                                      Text(
                                        data.title,
                                        style: CustomTextStyle.titleMedium(
                                          context,
                                        )?.apply(fontWeightDelta: 1),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList();
                        },
                        leading: CustomCircularBorderBackground(
                          outerRadius: Dimen.d_20,
                          innerRadius: Dimen.d_20,
                          image: profileModel.profilePhoto,
                        ),
                        title: profileModel.fullName ?? '',
                        widget: _userKycStatusWidget(context, isKycVerified),
                        isReqArrowCenter: false,
                      )
                    : const SizedBox.shrink();
              },
            ),
        ],
      ).paddingSymmetric(
        vertical: Dimen.d_8,
        horizontal: !abhaSingleton.getAppData.getLogin() ? context.width * 0.10 : Dimen.d_50,
      ),
    );
  }

  Widget _userKycStatusWidget(BuildContext context, bool isKYCVerified) {
    return Row(
      children: [
        if (isKYCVerified)
          Icon(
            IconAssets.checkCircleRounded,
            size: Dimen.d_12,
            color: AppColors.colorGreenDark,
          ).marginOnly(right: Dimen.d_5)
        else
          CustomSvgImageView(
            ImageLocalAssets.selfDeclaredIcon,
            width: Dimen.d_12,
            height: Dimen.d_12,
          ).marginOnly(right: Dimen.d_5),
        Text(
          isKYCVerified ? LocalizationHandler.of().kycVerified : LocalizationHandler.of().selfdeclared,
          style: CustomTextStyle.labelSmall(context)?.apply(),
          textAlign: TextAlign.center,
        ),
      ],
    ).marginOnly(
      top: Dimen.d_2,
    );
  }

  Widget _headerOptionWidget(BuildContext context) {
    return Container(
      height: Dimen.d_50,
      color: AppColors.colorBlueDark1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _verticalDivider(),
          Material(
            color: (context.currentPath == RoutePath.routeAppIntro || context.currentPath == RoutePath.routeDashboard) ? AppColors.colorAppBlue : AppColors.colorAppBlue3,
            child: InkWell(
              onTap: () {
                // if user is logged-in then it will automatically move to dashboard
                context.navigatePush(RoutePath.routeAppIntro);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        LocalizationHandler.of().home,
                        style: CustomTextStyle.titleSmall(context)?.apply(color: AppColors.colorWhite),
                      ),
                    ),
                  ),
                  Container(
                    height: Dimen.d_5,
                    width: Dimen.d_100,
                    color: (context.currentPath == RoutePath.routeAppIntro || context.currentPath == RoutePath.routeDashboard) ? AppColors.colorAppOrange : AppColors.colorAppBlue3,
                  ),
                ],
              ),
            ),
          ),
          _verticalDivider(),
          CustomPopUpMenuButtonView(
            title: LocalizationHandler.of().aboutUs.toTitleCase(),
            itemBuilder: (BuildContext context) {
              return CustomHeaderMenuData.getAboutABDMData(
                context,
                _launchURLService,
              ).map((CustomHeaderMenuData data) {
                return PopupMenuItem(
                  value: data,
                  padding: EdgeInsets.zero,
                  height: 0,
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
                        maxHeight: Dimen.d_52,
                        minHeight: Dimen.d_42,
                      ),
                      child: Text(
                        data.title,
                        style: CustomTextStyle.labelLarge(context)?.apply(color: AppColors.colorWhite),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList();
            },
          ).paddingSymmetric(horizontal: Dimen.d_20),
          _verticalDivider(),
          CustomPopUpMenuButtonView(
            title: LocalizationHandler.of().resourceCenter,
            widget: null,
            itemBuilder: (BuildContext context) {
              return CustomHeaderMenuData.getResourceCenterData(
                context,
                _launchURLService,
              ).map((CustomHeaderMenuData data) {
                return PopupMenuItem(
                  value: data,
                  padding: EdgeInsets.zero,
                  height: 0,
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
                        maxHeight: Dimen.d_52,
                        minHeight: Dimen.d_42,
                      ),
                      child: Text(
                        data.title,
                        style: CustomTextStyle.labelLarge(context)?.apply(color: AppColors.colorWhite),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList();
            },
          ).paddingSymmetric(horizontal: Dimen.d_20),
          _verticalDivider(),
          CustomPopUpMenuButtonView(
            title: LocalizationHandler.of().support,
            widget: null,
            itemBuilder: (BuildContext context) {
              return CustomHeaderMenuData.getSupportData(
                context,
                _launchURLService,
              ).map((CustomHeaderMenuData data) {
                return PopupMenuItem(
                  value: data,
                  padding: EdgeInsets.zero,
                  height: 0,
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
                        maxHeight: Dimen.d_52,
                        minHeight: Dimen.d_42,
                      ),
                      child: Text(
                        data.title,
                        style: CustomTextStyle.labelLarge(context)?.apply(color: AppColors.colorWhite),
                        // textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList();
            },
          ).paddingSymmetric(horizontal: Dimen.d_20),
          _verticalDivider(),
          Expanded(child: Container()),
          Row(
            children: [
              _verticalDivider(),
              Material(
                color: (context.currentPath == RoutePath.routeLogin) ? AppColors.colorAppBlue : AppColors.colorAppBlue3,
                child: InkWell(
                  onTap: () {
                    // if user is logged-in then it will automatically move to dashboard
                    context.navigatePush(RoutePath.routeLogin);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              CustomSvgImageView(
                                ImageLocalAssets.abhaLoginUserIconSvg,
                                height: Dimen.d_20,
                                width: Dimen.d_20,
                              ).marginOnly(right: Dimen.d_12),
                              Text(
                                LocalizationHandler.of().login,
                                style: CustomTextStyle.titleSmall(context)?.apply(
                                  color: AppColors.colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: Dimen.d_5,
                        width: Dimen.d_120,
                        color: (context.currentPath == RoutePath.routeLogin) ? AppColors.colorAppOrange : AppColors.colorAppBlue3,
                      ),
                    ],
                  ),
                ),
              ),
              _verticalDivider(),
              Material(
                color: AppColors.colorAppBlue3,
                child: Tooltip(
                  message: LocalizationHandler.of().abha_no_info,
                  child: InkWell(
                    onTap: () {
                      CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                CustomSvgImageView(
                                  ImageLocalAssets.abhaNumberInto,
                                  height: Dimen.d_20,
                                  width: Dimen.d_20,
                                ).marginOnly(right: Dimen.d_12),
                                Text(
                                  LocalizationHandler.of().createAbhaNumber,
                                  style: CustomTextStyle.titleSmall(context)?.apply(
                                    color: AppColors.colorWhite,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: Dimen.d_5,
                          width: Dimen.d_140,
                          color: AppColors.colorAppBlue3,
                        ),
                      ],
                    ),
                  ),
                ),
              ).paddingSymmetric(horizontal: Dimen.d_20),
              _verticalDivider(),
            ],
          ),
        ],
      ).paddingSymmetric(horizontal: context.width * 0.10),
    );
  }

  Widget _verticalDivider() {
    return VerticalDivider(
      width: Dimen.d_1,
      thickness: Dimen.d_1,
      color: AppColors.colorAppBlue,
    ).sizedBox(height: Dimen.d_70);
  }
}
