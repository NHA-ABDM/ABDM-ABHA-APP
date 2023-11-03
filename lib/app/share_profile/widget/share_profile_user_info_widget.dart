import 'package:abha/app/share_profile/widget/share_profile_title_subtitle_widget.dart';
import 'package:abha/export_packages.dart';

class ShareProfileUserInfoWidget extends StatelessWidget {
  final ProfileModel? profileModel;

  const ShareProfileUserInfoWidget({required this.profileModel, super.key});

  @override
  Widget build(BuildContext context) {
    var dtObj = DateTime(
      profileModel?.dateOfBirth?.year ?? 0,
      profileModel?.dateOfBirth?.month ?? 0,
      profileModel?.dateOfBirth?.date ?? 0,
    );
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              CustomCircularBorderBackground(
                outerRadius: Dimen.d_65,
                innerRadius: Dimen.d_60,
                image: profileModel?.profilePhoto ?? '',
              ).paddingOnly(
                top: Dimen.d_20,
                left: Dimen.d_20,
                right: Dimen.d_20,
              ),
              Flexible(
                child: ListTile(
                  title: Text(
                    profileModel?.fullName ??
                        '${profileModel?.name?.firstName} ${profileModel?.name?.lastName}',
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack6,
                      fontSizeDelta: 2,
                      fontWeightDelta: 2,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      if (isKycVerified)
                        const Icon(
                          IconAssets.checkCircleRounded,
                          color: AppColors.colorGreenDark,
                          size: 10,
                        )
                      else
                        CustomSvgImageView(
                          ImageLocalAssets.selfDeclaredIcon,
                          width: Dimen.d_20,
                          height: Dimen.d_20,
                        ).marginOnly(left: Dimen.d_10),
                      Text(
                        isKycVerified
                            ? LocalizationHandler.of().kycVerified
                            : LocalizationHandler.of().selfdeclared,
                        style: CustomTextStyle.labelMedium(context)?.apply(
                          color: AppColors.colorBlack6,
                          fontWeightDelta: -1,
                        ),
                      ).marginOnly(left: Dimen.d_6)
                    ],
                  ),
                ).marginOnly(top: Dimen.d_6),
              )
            ],
          ),
          Divider(
            thickness: Dimen.d_2,
            color: AppColors.colorGrey2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ///Date of birth
              Flexible(
                flex: 1,
                child: ShareProfileTitleSubtitleWidget(
                  title: LocalizationHandler.of().dateOfBirth,
                  value: Validator.isNullOrEmpty(
                            profileModel?.dateOfBirth?.month,
                          ) ||
                          Validator.isNullOrEmpty(
                            profileModel?.dateOfBirth?.date,
                          )
                      ? (profileModel?.dateOfBirth?.year).toString()
                      : dtObj.formatDDMMMMYYYY,
                  keyValue: KeyConstant.dateOfBirthText,
                ),
              ),

              VerticalDivider(
                thickness: Dimen.d_2,
                color: AppColors.colorGrey2,
              ).sizedBox(height: Dimen.d_50),

              ///gender
              Flexible(
                flex: 1,
                child: ShareProfileTitleSubtitleWidget(
                  title: LocalizationHandler.of().gender,
                  value: Validator.getGender(profileModel?.gender ?? ''),
                  keyValue: KeyConstant.genderTxt,
                ),
              ),
            ],
          )
        ],
      ),
    ).marginOnly(left: Dimen.d_20, right: Dimen.d_20, top: Dimen.d_50);
  }

  bool get isKycVerified => profileModel?.kycStatus == 'VERIFIED'
      // || profileModel?.kycVerified == 'true'
      ? true
      : false;
}
