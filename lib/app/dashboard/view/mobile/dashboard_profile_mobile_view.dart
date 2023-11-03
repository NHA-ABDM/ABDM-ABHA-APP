import 'package:abha/export_packages.dart';

class DashboardProfileMobileView extends StatefulWidget {
  const DashboardProfileMobileView({super.key});

  @override
  DashboardProfileMobileViewState createState() =>
      DashboardProfileMobileViewState();
}

class DashboardProfileMobileViewState
    extends State<DashboardProfileMobileView> {
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

  void _getProfileData() async{
    _profileModel = _profileController.profileModel;
    _isKycVerified = _profileController.getKycDetail();
  }

  @override
  Widget build(BuildContext context) {
    return _mainView();
  }

  Widget _mainView() {
    return ValueListenableBuilder<ProfileModel?>(
      valueListenable: _profileController.getProfileModel,
      builder: (context, profileModel, _) {
        _profileModel = profileModel;
        _isKycVerified = _profileController.getKycDetail();
        return Column(
          children: [
            _showUserNameAndKycStatusView(),
            _showAbhaAddressAbhaNumberView()
          ],
        );
      },
    );
  }

  /// @Here widget shows the Name and Kyc status of User
  Widget _showUserNameAndKycStatusView() {
    return Stack(
      children: [
        DecoratedBox(
          decoration:
              abhaSingleton.getBorderDecoration.getRectangularCornerBorder(
            topLeft: 0,
            topRight: 0,
            bottomLeft: 0,
            bottomRight: 0,
          ),
          child: Image.asset(
            ImageLocalAssets.dashboardTopBgImagePng,
            fit: BoxFit.contain,
          ).sizedBox( height: Dimen.d_120,
            width: context.width,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CustomCircularBorderBackground(
                  outerRadius: Dimen.d_75,
                  innerRadius: Dimen.d_72,
                  image: _profileModel?.profilePhoto ?? '',
                ).centerWidget.marginOnly(top: Dimen.d_20),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _profileModel?.fullName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: CustomTextStyle.bodyLarge(context)?.apply(
                      color: AppColors.colorBlack6,
                      fontWeightDelta: 2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ).marginOnly(top: Dimen.d_10),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                      color: AppColors.colorGreyDark2,
                      fontWeightDelta: 2,
                    ),
                    textAlign: TextAlign.center,
                  ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
                ],
              ),
            ).marginOnly(top: Dimen.d_5),
          InkWell(
            onTap: () async{
              _profileController.mappedPhrAddress = [];
              _profileController.functionHandler(
                function: () => _profileController.getSwitchAccountUsers(),
                isLoaderReq: true,
              ).whenComplete(() {
                _profileController.mappedPhrAddress = [];
                Map data = _profileController.responseHandler.data;
                if (data.isNotEmpty) {
                  for (Map<String, dynamic> jsonMap
                  in data[ApiKeys.responseKeys.users]) {
                    _profileController.mappedPhrAddress
                        .add(ProfileModel.fromMappedUserMap(jsonMap));
                  }
                  _profileController.abhaAddressSelectedValue =
                      _profileModel?.abhaAddress ?? '';
                  _profileController.showUserList(context);
                }
              });

              // await abhaSingleton.getSharedPref.get(SharedPref.userLists).then((usersString) {
              //   for (Map<String, dynamic> jsonMap in jsonDecode(usersString!)) {
              //     _profileController.mappedPhrAddress.add(ProfileModel.fromMappedUserMap(jsonMap));
              //   }
              //   _profileController.abhaAddressSelectedValue = _profileModel?.abhaAddress ?? '';
              //   _profileController.showUserList(context);
              // });
              // context.navigatePush(
              //   RoutePath.routeSwitchAccount,);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                  CustomSvgImageView(
                    ImageLocalAssets.switchAccountIconSvg,
                    width: Dimen.d_20,
                    height: Dimen.d_20,
                    color: AppColors.colorAppOrange,
                  ).marginOnly(left: Dimen.d_10),
                Text(
                  LocalizationHandler.of().switchAccount,
                  style: CustomTextStyle.bodyMedium(context)?.apply(
                    color: AppColors.colorAppOrange,
                  ),
                  textAlign: TextAlign.center,
                ).marginOnly(left: Dimen.d_5, right: Dimen.d_5),
              ],
            ).paddingAll(Dimen.d_5),
          ),
          ],
        ),
      ],
    );
  }

  /// @Here Widget showing Abha Address and Abha Number of User.
  Widget _showAbhaAddressAbhaNumberView() {
    return GetBuilder<ProfileController>(
      builder: (_) {
        _getProfileData();
        return DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getElevation(
            size: 5,
            color: AppColors.colorWhite1,
            borderColor: AppColors.colorGrey2,
            isLow: true,
          ),
          child: Column(
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
              Container(
                height: Dimen.d_2,
                color: AppColors.colorGrey2,
              ),
              _titleValueOfProfileWidget(
                const Key(KeyConstant.abhaAddressTextField),
                ImageLocalAssets.profileAbhaAddressIconSvg,
                LocalizationHandler.of().abhaAddress,
                _profileModel?.abhaAddress ?? '',
                Dimen.d_2,
                AppColors.colorAppBlue,
                _isKycVerified,
              )
            ],
          ),
        ).marginOnly(top: Dimen.d_20);
      },
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
    ).paddingOnly(
      top: Dimen.d_10,
      bottom: Dimen.d_5,
      left: Dimen.d_30,
      right: Dimen.d_30,
    );
  }

}
