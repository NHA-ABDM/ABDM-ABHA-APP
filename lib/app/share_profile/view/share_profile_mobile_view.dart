import 'package:abha/app/share_profile/share_profile_controller.dart';
import 'package:abha/app/share_profile/widget/share_profile_title_subtitle_widget.dart';
import 'package:abha/app/share_profile/widget/share_profile_user_info_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/custom_loading_view.dart';

class ShareProfileMobileView extends StatefulWidget {
  final VoidCallback getCurrentLocation;

  const ShareProfileMobileView({
    required this.getCurrentLocation,
    super.key,
  });

  @override
  ShareProfileMobileViewState createState() => ShareProfileMobileViewState();
}

class ShareProfileMobileViewState extends State<ShareProfileMobileView> {
  late ShareProfileController _shareProfileController;
  late ProfileModel _profileModel;

  @override
  void initState() {
    _shareProfileController = Get.find<ShareProfileController>();
    _profileModel =
        Get.find<ProfileController>().profileModel ?? ProfileModel();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return shareProfileWidget();
  }

  Widget shareProfileWidget() {
    return Column(
      children: [
        DecoratedBox(
          decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
            size: 0,
            color: AppColors.colorAppBlue,
            borderColor: AppColors.colorAppBlue,
          ),
          child: _getHIPName().sizedBox(
            width: context.width,
            height: Dimen.d_100,
          ),
        ),
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ShareProfileUserInfoWidget(profileModel: _profileModel),
                showAbhaAddressAndNumberWidget(),
                showMobileAndEmailWidget(),
                showUserAddressDetail()
              ],
            ),
          ),
        ),
        shareAndCancelButton()
      ],
    );
  }

  /// Here is Widget to show the Hospital name in text
  Widget _getHIPName() {
    return GetBuilder<ShareProfileController>(
      builder: (_) {
        return _shareProfileController.responseHandler.status == Status.loading
            ? CustomLoadingView(
                loadingMessage: '',
                style: CustomTextStyle.labelMedium(context)?.apply(),
                width: Dimen.d_20,
                height: Dimen.d_20,
              ).marginOnly(top: Dimen.d_10)
            : _shareProfileController.responseHandler.status == Status.success
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomSvgImageView(
                        ImageLocalAssets.hospital,
                        width: Dimen.d_35,
                        height: Dimen.d_25,
                        color: AppColors.colorWhite,
                      ).marginOnly(left: Dimen.d_20, top: Dimen.d_40),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            LocalizationHandler.of().share_your_details_with,
                            style: CustomTextStyle.bodySmall(context)?.apply(
                              color: AppColors.colorPurple2,
                              fontWeightDelta: -1,
                              fontSizeDelta: -2,
                            ),
                          ).marginOnly(bottom: Dimen.d_3),
                          Text(
                            _shareProfileController.hipName ?? 'test',
                            style: CustomTextStyle.bodySmall(context)?.apply(
                              color: AppColors.colorPurple2,
                              fontSizeDelta: 2,
                              fontWeightDelta: 2,
                            ),
                          )
                        ],
                      ).paddingSymmetric(
                        vertical: Dimen.d_32,
                        horizontal: Dimen.d_12,
                      ),
                    ],
                  )
                : Container();
      },
    );
  }

  /// @Here Widget showing Abha Address and Abha Number of User.
  Widget showAbhaAddressAndNumberWidget() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleValueOfProfile(
            ImageLocalAssets.profileAbhaNumberIconSvg,
            LocalizationHandler.of().abhaNumber,
            _shareProfileController.getKyc(_profileModel)
                ? _profileModel.abhaNumber ?? ''
                : LocalizationHandler.of().not_linked,
            Dimen.d_2,
            AppColors.colorAppBlue,
          ),
          Container(
            height: Dimen.d_2,
            color: AppColors.colorGrey2,
          ),
          titleValueOfProfile(
            ImageLocalAssets.profileAbhaAddressIconSvg,
            LocalizationHandler.of().abhaAddress,
            _profileModel.abhaAddress ?? '',
            Dimen.d_2,
            AppColors.colorAppBlue,
          )
        ],
      ),
    ).marginOnly(left: Dimen.d_20, right: Dimen.d_20, top: Dimen.d_20);
  }

  /// @Here Widget showing Mobile Number and Email Id of User.
  Widget showMobileAndEmailWidget() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleValueOfProfile(
            ImageLocalAssets.shareMobileNoIconSvg,
            LocalizationHandler.of().mobile,
            _profileModel.mobile ?? '-',
            -2,
            AppColors.colorBlack6,
          ),
          Container(
            height: Dimen.d_2,
            color: AppColors.colorGrey2,
          ),
          titleValueOfProfile(
            ImageLocalAssets.shareEmailIconSvg,
            LocalizationHandler.of().emailId,
            _profileModel.email ?? '-',
            -2,
            AppColors.colorBlack6,
          )
        ],
      ),
    ).marginOnly(left: Dimen.d_20, right: Dimen.d_20, top: Dimen.d_20);
  }

  /// @Here Widget showing Address Details of User.
  Widget showUserAddressDetail() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ShareProfileTitleSubtitleWidget(
            title: LocalizationHandler.of().addres,
            value: _profileModel.address ?? '-',
            keyValue: KeyConstant.addressTxt,
            isCenter: false,
          ).paddingSymmetric(
            vertical: Dimen.d_10,
            horizontal: Dimen.d_30,
          ),
          Container(
            height: Dimen.d_2,
            color: AppColors.colorGrey2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShareProfileTitleSubtitleWidget(
                title: LocalizationHandler.of().state,
                value: _profileModel.stateName ?? '-',
                keyValue: KeyConstant.addressTxt,
                isCenter: false,
              ),
              ShareProfileTitleSubtitleWidget(
                title: LocalizationHandler.of().district,
                value: _profileModel.districtName ?? '-',
                keyValue: KeyConstant.addressTxt,
                isCenter: false,
              ).marginOnly(right: Dimen.d_80)
            ],
          ).paddingSymmetric(
            vertical: Dimen.d_10,
            horizontal: Dimen.d_30,
          ),
          Container(
            height: Dimen.d_2,
            color: AppColors.colorGrey2,
          ),
          ShareProfileTitleSubtitleWidget(
            title: LocalizationHandler.of().pinCode,
            value: _profileModel.pinCode ?? '-',
            keyValue: KeyConstant.pinCodeTxt,
            isCenter: false,
          ).paddingSymmetric(
            vertical: Dimen.d_10,
            horizontal: Dimen.d_30,
          ),
        ],
      ),
    ).marginOnly(left: Dimen.d_20, right: Dimen.d_20, top: Dimen.d_20);
  }

  /// @Here Common Widget for [title] and its [value]
  Widget titleValueOfProfile(
    String icon,
    String title,
    String value,
    double fontSize,
    Color textColor,
  ) {
    return Row(
      children: [
        CustomSvgImageView(
          icon,
          width: Dimen.d_25,
          height: Dimen.d_25,
        ).sizedBox(
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
                fontSizeDelta: -2,
                fontWeightDelta: -1,
              ),
            ),
            Text(
              value,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: textColor,
                fontSizeDelta: fontSize,
                fontWeightDelta: 2,
              ),
            ).marginOnly(top: Dimen.d_4),
          ],
        ).marginOnly(left: Dimen.d_20)
      ],
    ).paddingSymmetric(
      vertical: Dimen.d_10,
      horizontal: Dimen.d_30,
    );
  }

  /// @Here widget to show [Share] and [Cancel] button in row.
  Widget shareAndCancelButton() {
    return DecoratedBox(
      decoration: abhaSingleton.getBorderDecoration.getElevation(
        color: AppColors.colorWhite,
        borderColor: AppColors.colorGrey2,
        isLow: true,
        size: 0,
      ),
      child: Column(
        children: [
          GetBuilder<ShareProfileController>(
            builder: (_) {
              return Validator.isNullOrEmpty(_shareProfileController.hipName)
                  ? Container()
                  : InfoNote(
                      isCenter: false,
                      note: '${LocalizationHandler.of().share_profile_info} '
                          '${_shareProfileController.hipName}. '
                          '${LocalizationHandler.of().share_profile_info_1}',
                    );
            },
          ).marginOnly(
            top: Dimen.d_10,
            left: Dimen.d_30,
            right: Dimen.d_30,
            bottom: Dimen.d_5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButtonPurple(
                text: LocalizationHandler.of().cancel,
                onPressed: () {
                  context.navigateBack(result: false);
                },
              ).marginOnly(right: Dimen.d_20).expand(),
              TextButtonOrange.mobile(
                text: LocalizationHandler.of().share,
                onPressed: () {
                  widget.getCurrentLocation();
                },
              ).expand(),
            ],
          )
              .paddingSymmetric(vertical: Dimen.d_20, horizontal: Dimen.d_20)
              .marginOnly(bottom: Dimen.d_20)
        ],
      ),
    );
  }
}
