import 'package:abha/export_packages.dart';

class RegistrationDesktopPhoneSizeView extends StatefulWidget {
  const RegistrationDesktopPhoneSizeView({super.key});

  @override
  State<RegistrationDesktopPhoneSizeView> createState() =>
      _RegistrationDesktopPhoneSizeViewState();
}

class _RegistrationDesktopPhoneSizeViewState
    extends State<RegistrationDesktopPhoneSizeView> {
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
        ).marginOnly(bottom: Dimen.d_24),
        Text(
          LocalizationHandler.of()
              .pleaseChooseOneOfTheBelowOptionToCreateABHAAddress,
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6,
            fontWeightDelta: -1,
          ),
        ).marginOnly(bottom: Dimen.d_24),
        regWidget().marginOnly(bottom: Dimen.d_24),
        Divider(
          height: Dimen.d_1,
          color: AppColors.colorGreyWildSand,
        )
            .paddingSymmetric(horizontal: Dimen.d_20)
            .marginOnly(bottom: Dimen.d_24),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$title ',
          style: CustomTextStyle.bodySmall(context)?.apply(
            color: AppColors.colorBlack6,
          ),
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

  Widget regWidget() {
    return Wrap(
      children: WidgetUtility.spreadWidgets(
        List.generate(registrationController.initRegistrationOptions().length,
            (index) {
          return Card(
            shape: abhaSingleton.getBorderDecoration
                .getRectangularShapeBorder(size: Dimen.d_8),
            elevation: Dimen.d_1,
            child: InkWell(
              onTap: () {
                if (index == 0) {
                  context.navigatePush(
                    RoutePath.routeRegistrationAbha,
                  );
                } else if (index == 1) {
                  context.navigatePush(
                    RoutePath.routeRegistrationMobile,
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
                      image: registrationController
                          .registrationOptions[index].icon,
                      radius: (context.width / 4) * 0.2,
                      width: (context.width / 4) * 1.0,
                      height: (context.width / 4) * 1.0,
                    ),
                  if (Validator.isNullOrEmpty(
                    registrationController.registrationOptions[index].title,
                  ))
                    const SizedBox.shrink()
                  else
                    Text(
                      registrationController.registrationOptions[index].title,
                      style: CustomTextStyle.bodySmall(context)
                          ?.apply(color: AppColors.colorGreyDark2),
                    ).marginOnly(top: Dimen.d_15),
                ],
              ).paddingOnly(top: Dimen.d_15, bottom: Dimen.d_15).centerWidget,
            ),
          );
        }),
        interItemSpace: Dimen.d_14,
      ),
    );
  }
}
