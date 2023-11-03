import 'package:abha/export_packages.dart';
import 'package:flutter/gestures.dart';

class LoginDesktopView extends StatefulWidget {
  const LoginDesktopView({super.key});

  @override
  State<LoginDesktopView> createState() => _LoginDesktopViewState();
}

class _LoginDesktopViewState extends State<LoginDesktopView> {
  late LoginController loginController;

  @override
  void initState() {
    loginController = Get.find<LoginController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimen.d_20,
        horizontal: context.width * 0.1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            LocalizationHandler.of().login,
            style: CustomTextStyle.headlineSmall(context)
                ?.apply(fontWeightDelta: 1, color: AppColors.colorBlack6),
          ).marginOnly(bottom: Dimen.d_14),
          Text(
            LocalizationHandler.of().pleaseChooseOneOfTheBelowOptionToLogin,
            style: CustomTextStyle.bodySmall(context)
                ?.apply(color: AppColors.colorBlack6, fontWeightDelta: -1),
          ).marginOnly(bottom: Dimen.d_14),
          loginWidget().marginOnly(bottom: Dimen.d_14),
          Divider(
            height: Dimen.d_1,
            color: AppColors.colorGreyWildSand,
          )
              .paddingSymmetric(horizontal: Dimen.d_20)
              .marginOnly(bottom: Dimen.d_24),
          bottomView()
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Row(
      children: WidgetUtility.spreadWidgets(
        List.generate(loginController.initLoginOptions().length, (index) {
          return Expanded(
            child: Card(
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
                            0.2,
                        height: (context.width /
                                loginController.loginOptions.length) *
                            0.2,
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
                      ).marginOnly(top: Dimen.d_15),
                  ],
                ).paddingOnly(top: Dimen.d_15, bottom: Dimen.d_15).centerWidget,
              ),
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
              CreateAbhaNumberUrl.abhaNumberCreateViaWeb(context);
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
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$title ',
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorBlack6,
                  fontSizeDelta: -2,
                  fontWeightDelta: -1,
                ),
              ),
              TextSpan(
                text: subtitle,
                style: CustomTextStyle.bodySmall(context)?.apply(
                  color: AppColors.colorAppOrange,
                  decoration: TextDecoration.underline,
                  fontWeightDelta: 2,
                  fontSizeDelta: -2,
                ),
                recognizer: TapGestureRecognizer()..onTap = onClick,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
