import 'package:abha/export_packages.dart';

class DashboardProfileDesktopView extends StatefulWidget {
  const DashboardProfileDesktopView({super.key});

  @override
  DashboardProfileDesktopViewState createState() =>
      DashboardProfileDesktopViewState();
}

class DashboardProfileDesktopViewState
    extends State<DashboardProfileDesktopView> {
  final ProfileController _profileController = Get.find<ProfileController>();
  ProfileModel? _profileModel;
  late bool _isKycVerified;

  @override
  void initState() {
    _getProfileData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getProfileData() {
    _profileModel = _profileController.profileModel;
    _isKycVerified = _profileController.getKycDetail();
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  Widget _mainView() {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        size: 0,
        isLow: true,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ColoredBox(
            color: AppColors.colorWhite,
            child: _showUserNameAndKycStatusView(),
          ).sizedBox(height: Dimen.d_100),
          ColoredBox(
            color: AppColors.colorWhite,
            child: _showAbhaAddressAbhaNumberView(),
          ).sizedBox(height: Dimen.d_100)
        ],
      ).paddingAll(Dimen.d_15),
    );
  }

  /// @Here widget shows the Name and Kyc status of User
  Widget _showUserNameAndKycStatusView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomCircularBorderBackground(
          outerRadius: Dimen.d_75,
          innerRadius: Dimen.d_72,
          image: _profileModel?.profilePhoto ?? '',
        ).sizedBox(width: Dimen.d_80, height: Dimen.d_80),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _profileModel?.fullName ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: CustomTextStyle.bodyLarge(context)?.apply(
                color: context.themeData.primaryColor,
                fontWeightDelta: 2,
              ),
              textAlign: TextAlign.center,
            ).marginOnly(top: Dimen.d_10),
            Row(
              children: [
                if (_isKycVerified)
                  const Icon(
                    IconAssets.checkCircleRounded,
                    color: AppColors.colorGreenDark,
                    size: 15,
                  )
                else
                  CustomSvgImageView(
                    ImageLocalAssets.selfDeclaredIcon,
                    width: Dimen.d_20,
                    height: Dimen.d_20,
                  ).marginOnly(left: Dimen.d_10),
                Text(
                  _isKycVerified
                      ? LocalizationHandler.of().kycVerified
                      : LocalizationHandler.of().selfdeclared,
                  style: CustomTextStyle.labelMedium(context)?.apply(
                    color: context.themeData.primaryColor,
                    fontWeightDelta: 2,
                  ),
                  textAlign: TextAlign.center,
                ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
              ],
            ),
          ],
        ).marginOnly(left: Dimen.d_15)
      ],
    ).paddingOnly(
      left: Dimen.d_30,
      right: Dimen.d_30,
    );
  }

  /// @Here Widget showing Abha Address and Abha Number of User.
  Widget _showAbhaAddressAbhaNumberView() {
    return GetBuilder<ProfileController>(
      builder: (_) {
        _getProfileData();
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _titleValueOfProfileWidget(
              const Key(KeyConstant.abhaNumberTextField),
              ImageLocalAssets.profileAbhaNumberIconSvg,
              LocalizationHandler.of().abhaNumber,
              _isKycVerified
                  ? _profileModel?.abhaNumber ?? '0'
                  : LocalizationHandler.of().not_linked,
              Dimen.d_2,
              AppColors.colorAppBlue,
              _isKycVerified,
            ),
            _titleValueOfProfileWidget(
              const Key(KeyConstant.abhaAddressTextField),
              ImageLocalAssets.profileAbhaAddressIconSvg,
              LocalizationHandler.of().abhaAddress,
              _profileModel?.abhaAddress ?? '',
              Dimen.d_2,
              AppColors.colorAppBlue,
              _isKycVerified,
            ).marginOnly(top: Dimen.d_10)
          ],
        );
      },
    ).paddingOnly(
      left: Dimen.d_30,
      right: Dimen.d_30,
    );
  }

  /// @Here Common Widget for [title] and its [value]
  Widget _titleValueOfProfileWidget(
    Key key,
    String icon,
    String title,
    String value,
    double fontSize,
    Color textColor,
    bool isKycVerified,
  ) {
    return Row(
      children: [
        CustomSvgImageView(
          icon,
          width: Dimen.d_25,
          height: Dimen.d_25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CustomTextStyle.labelMedium(context)?.apply(
                color: AppColors.colorBlack6,
                fontWeightDelta: -1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    color: textColor,
                    fontSizeDelta: fontSize,
                    fontWeightDelta: 2,
                  ),
                ),
                if (key == const Key(KeyConstant.abhaNumberTextField))
                  !isKycVerified
                      ? InkWell(
                          onTap: () {
                            // if (abhaSingleton.getAppData
                            //     .getHealthRecordFetched()) {
                              context.navigatePush(
                                RoutePath.routeLinkAbhaNumber,
                              );
                            // } else {
                            //   MessageBar.showToastDialog(
                            //     LocalizationHandler.of().pleaseWaitForRecord,
                            //   );
                            // }
                          },
                          child: Text(
                            LocalizationHandler.of().labelLinkAbhaNumber,
                            style: CustomTextStyle.bodyMedium(context)?.apply(
                              decoration: TextDecoration.underline,
                              color: AppColors.colorAppOrange,
                              fontSizeDelta: -2,
                              fontWeightDelta: 2,
                            ),
                          ).marginOnly(left: Dimen.d_22, top: Dimen.d_4),
                        )
                      : const SizedBox.shrink()
                else
                  const SizedBox.shrink()
              ],
            )
          ],
        ).marginOnly(left: Dimen.d_20)
      ],
    );
  }
}
