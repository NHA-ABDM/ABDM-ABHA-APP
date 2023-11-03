import 'package:abha/export_packages.dart';
import 'package:flutter/gestures.dart';

class RegistrationDesktopView extends StatefulWidget {
  const RegistrationDesktopView({super.key});

  @override
  State<RegistrationDesktopView> createState() => _RegistrationDesktopViewState();
}

class _RegistrationDesktopViewState extends State<RegistrationDesktopView> {
  late RegistrationController registrationController;

  @override
  void initState() {
    registrationController = Get.find<RegistrationController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _mainWidget();
  }

  Widget _mainWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          LocalizationHandler.of().createAbhaAddress,
          style: CustomTextStyle.headlineSmall(context)?.apply(
            fontWeightDelta: 1,
            color: AppColors.colorBlack6,
          ),
        ).marginOnly(bottom: Dimen.d_14),
        Text(
          LocalizationHandler.of().pleaseChooseOneOfTheBelowOptionToCreateABHAAddress,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6,
            fontWeightDelta: -1,
          ),
        ).marginOnly(bottom: Dimen.d_14),
        regWidget().marginOnly(bottom: Dimen.d_24),
        Divider(
          height: Dimen.d_1,
          color: AppColors.colorGreyWildSand,
        ).paddingSymmetric(horizontal: Dimen.d_20).marginOnly(bottom: Dimen.d_24),
        _titleSubtitleWidget(
          context,
          LocalizationHandler.of().alreadyHaveABHAAddress,
          LocalizationHandler.of().login,
          () {
            context.navigatePush(RoutePath.routeLogin);
          },
        )
      ],
    ).marginSymmetric(
      vertical: Dimen.d_20,
      horizontal: context.width * 0.1,
    );
  }

  Widget _titleSubtitleWidget(
    BuildContext context,
    String title,
    String subtitle,
    VoidCallback onClick,
  ) {
    return RichText(
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
    );
  }

  Widget regWidget() {
    return Row(
      key: const Key(KeyConstant.registrationOptions),
      children: WidgetUtility.spreadWidgets(
        List.generate(registrationController.initRegistrationOptions().length, (index) {
          return Expanded(
            child: Card(
              shape: abhaSingleton.getBorderDecoration.getRectangularShapeBorder(size: Dimen.d_8),
              elevation: Dimen.d_1,
              child: InkWell(
                onTap: () {
                  if (index == 0) {
                    context.navigatePush(
                      RoutePath.routeRegistrationMobile,
                    );
                  } else if (index == 1) {
                    context.navigatePush(
                      RoutePath.routeRegistrationAbha,
                    );
                  } else if (index == 2) {
                    context.navigatePush(
                      RoutePath.routeRegistrationEmail,
                    );
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (Validator.isNullOrEmpty(
                      registrationController.registrationOptions[index].icon,
                    ))
                      const SizedBox.shrink()
                    else
                      CustomCircularBackground(
                        image: registrationController.registrationOptions[index].icon,
                        radius: (context.width / registrationController.registrationOptions.length) * 0.2,
                        width: (context.width / registrationController.registrationOptions.length) * 0.2,
                        height: (context.width / registrationController.registrationOptions.length) * 0.2,
                      ),
                    if (Validator.isNullOrEmpty(
                      registrationController.registrationOptions[index].title,
                    ))
                      const SizedBox.shrink()
                    else
                      Text(
                        registrationController.registrationOptions[index].title,
                        style: CustomTextStyle.bodySmall(context)?.apply(color: AppColors.colorGreyDark2),
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
}
