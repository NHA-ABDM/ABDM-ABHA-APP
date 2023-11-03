import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LoginDesktopPhoneSizeView extends StatefulWidget {
  const LoginDesktopPhoneSizeView({super.key});

  @override
  State<LoginDesktopPhoneSizeView> createState() =>
      _LoginDesktopPhoneSizeViewState();
}

class _LoginDesktopPhoneSizeViewState extends State<LoginDesktopPhoneSizeView> {
  late LoginController loginController;

  @override
  void initState() {
    loginController = Get.find<LoginController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          LocalizationHandler.of().login,
          style: CustomTextStyle.headlineSmall(context)
              ?.apply(fontWeightDelta: 1, color: AppColors.colorBlack6),
        ).marginOnly(bottom: Dimen.d_24),
        Text(
          LocalizationHandler.of().pleaseChooseOneOfTheBelowOptionToLogin,
          style: CustomTextStyle.bodySmall(context)
              ?.apply(color: AppColors.colorBlack6, fontWeightDelta: -1),
        ).marginOnly(bottom: Dimen.d_24),
        loginWidget().marginOnly(bottom: Dimen.d_24),
        Divider(
          height: Dimen.d_1,
          color: AppColors.colorGreyWildSand,
        )
            .marginOnly(bottom: Dimen.d_24)
            .paddingSymmetric(horizontal: Dimen.d_20),
        bottomView()
      ],
    ).marginSymmetric(
      vertical: Dimen.d_20,
      horizontal: context.width * 0.1,
    );
  }

  Widget loginWidget() {
    return Wrap(
      children: WidgetUtility.spreadWidgets(
        List.generate(loginController.initLoginOptions().length, (index) {
          return Card(
            shape: abhaSingleton.getBorderDecoration
                .getRectangularShapeBorder(size: Dimen.d_8),
            elevation: Dimen.d_1,
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  context.navigatePush(
                    RoutePath.routeLoginMobile,
                  );
                } else if (index == 1) {
                  context.navigatePush(
                    RoutePath.routeLoginAbhaAddress,
                  );
                } else if (index == 2) {
                  context.navigatePush(
                    RoutePath.routeLoginAbhaNumber,
                  );
                } else if (index == 3) {
                  context.navigatePush(
                    RoutePath.routeLoginEmail,
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (Validator.isNullOrEmpty(
                    loginController.loginOptions[index].icon,
                  ))
                    const SizedBox.shrink()
                  else
                    CustomCircularBackground(
                      image: loginController.loginOptions[index].icon,
                      radius: (context.width /
                              loginController.loginOptions.length) *
                          0.2,
                      width: (context.width /
                              loginController.loginOptions.length) *
                          1,
                      height: (context.width /
                              loginController.loginOptions.length) *
                          1,
                    ),
                  if (Validator.isNullOrEmpty(
                    loginController.loginOptions[index].title,
                  ))
                    const SizedBox.shrink()
                  else
                    Text(
                      loginController.loginOptions[index].title,
                      style: CustomTextStyle.bodySmall(context)
                          ?.apply(color: AppColors.colorGreyDark2),
                    ).marginOnly(
                      top: Dimen.d_15,
                      left: Dimen.d_10,
                      right: Dimen.d_10,
                    ),
                ],
              ).paddingOnly(top: Dimen.d_15, bottom: Dimen.d_15).centerWidget,
            ),
          );
        }),
        interItemSpace: Dimen.d_14,
      ),
    );
  }

  Row bottomView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _titleSubtitleWidget(
            context,
            LocalizationHandler.of().dontHaveABHANumber,
            LocalizationHandler.of().createNow,
            () {
              if (kIsWeb) {
                CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
              } else {
                context.navigateBack();
                context.navigatePush(RoutePath.routeAbhaNumber);
              }
            },
          ),
        ),
        Expanded(
          child: _titleSubtitleWidget(
            context,
            LocalizationHandler.of().dontHaveABHAAddress,
            LocalizationHandler.of().register,
            () {
              context.navigatePush(RoutePath.routeRegistration);
            },
          ),
        )
      ],
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
          '$title ',
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6,
          ),
          textAlign: TextAlign.center,
        ),
        InkWell(
          onTap: onClick,
          child: Text(
            subtitle,
            style: CustomTextStyle.bodySmall(context)?.apply(
              decoration: TextDecoration.underline,
              color: AppColors.colorAppOrange,
            ),
          ),
        )
      ],
    );
  }
}
