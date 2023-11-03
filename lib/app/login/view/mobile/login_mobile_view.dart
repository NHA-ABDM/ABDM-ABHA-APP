import 'package:abha/app/app_intro/model/login_option_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dialog/registration_option_dialog.dart';
import 'package:flutter/foundation.dart';

class LoginMobileView extends StatelessWidget {
  final List<LoginOptionModel> loginOptions;
  final int crossAxisCount;
  final String? title;
  final dynamic onClick;
  final Color? backgroundColor;
  final double? elevation;

  const LoginMobileView({
    required this.loginOptions,
    required this.crossAxisCount,
    required this.onClick,
    super.key,
    this.title,
    this.backgroundColor = AppColors.colorTransparent,
    this.elevation = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title ?? '',
          style: CustomTextStyle.headlineSmall(context)?.apply(
            color: AppColors.colorAppBlue1,
            fontWeightDelta: 2,
          ),
        ).marginOnly(left: Dimen.d_16, top: Dimen.d_32).alignAtTopLeft(),
        Expanded(
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: Dimen.d_10,
            mainAxisSpacing: Dimen.d_10,
            shrinkWrap: true,
            childAspectRatio: 1.2,
            children: List.generate(
              loginOptions.length,
              (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimen.d_10),
                    color: backgroundColor,
                  ),
                  child: InkWell(
                    onTap: () {
                      onClick(index);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (Validator.isNullOrEmpty(loginOptions[index].icon))
                          const SizedBox.shrink()
                        else
                          CustomCircularBackground(
                            image: loginOptions[index].icon,
                            radius: context.width * 0.18,
                            width: context.width * 0.25,
                            height: context.width * 0.25,
                          ),
                        if (Validator.isNullOrEmpty(loginOptions[index].title))
                          const SizedBox.shrink()
                        else
                          Text(
                            loginOptions[index].title,
                            style: CustomTextStyle.bodySmall(context)
                                ?.apply(color: AppColors.colorGreyDark2),
                          ).marginOnly(top: Dimen.d_5),
                      ],
                    ),
                  ),
                ).paddingAll(Dimen.d_10);
              },
            ),
          ).marginOnly(top: Dimen.d_20),
        ),
        Row(
          children: [
            Text(
              LocalizationHandler.of().otherLoginMethod,
              style: CustomTextStyle.bodySmall(context)
                  ?.apply(color: AppColors.colorGreyDark2),
            ).marginOnly(left: Dimen.d_25, right: Dimen.d_5),
            Expanded(child: _horizontalDivider()),
          ],
        ),
        Row(
          children: [
            InkWell(
              onTap: () {
                onClick(3);
              },
              child: Column(
                children: [
                  CustomCircularBackground(
                    image: ImageLocalAssets.loginEmailIconSvg,
                    radius: context.width * 0.18,
                    width: context.width * 0.25,
                    height: context.width * 0.25,
                  ),
                  Text(
                    LocalizationHandler.of().emailId,
                    style: CustomTextStyle.bodySmall(context)
                        ?.apply(color: AppColors.colorGreyDark2),
                  ).marginOnly(top: Dimen.d_5),
                ],
              ).marginOnly(left: Dimen.d_55),
            ),
          ],
        ).marginOnly(top: Dimen.d_10),
        _horizontalDivider().marginOnly(top: Dimen.d_10),
        _titleSubtitleWidget(
            context,
            LocalizationHandler.of().dontHaveABHANumber,
            LocalizationHandler.of().createNow, () {
          if (kIsWeb) {
            CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
          } else {
            context.navigateBack();
            context.navigatePush(RoutePath.routeAbhaNumber);
          }
        }),
        _horizontalDivider(),
        _titleSubtitleWidget(
            context,
            LocalizationHandler.of().dontHaveABHAAddress,
            LocalizationHandler.of().register, () {
          context.navigateBack();
          RegistrationOptionDialog.open(context);
        }).marginOnly(bottom: Dimen.d_30),
      ],
    );
  }

  Widget _horizontalDivider() {
    return Container(
      color: AppColors.colorGreyLight11,
      height: Dimen.d_1,
    );
  }

  Widget _titleSubtitleWidget(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onClick,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6,
            fontWeightDelta: -1,
            fontSizeDelta: -1,
          ),
        ),
        InkWell(
          onTap: onClick,
          child: Text(
            subtitle,
            style: CustomTextStyle.bodySmall(context)?.apply(
              decoration: TextDecoration.underline,
              color: AppColors.colorAppOrange,
              fontWeightDelta: 1,
              fontSizeDelta: -1,
            ),
          ).marginOnly(top: Dimen.d_5),
        )
      ],
    ).paddingSymmetric(vertical: Dimen.d_16, horizontal: Dimen.d_16);
  }
}
