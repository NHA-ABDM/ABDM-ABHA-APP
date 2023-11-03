import 'package:abha/app/app_intro/view/mobile/app_intro_slider_mobile_view.dart';
import 'package:abha/app/login/view/mobile/login_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';
import 'package:abha/reusable_widget/dialog/registration_option_dialog.dart';
import 'package:flutter/foundation.dart';

class AppIntroMobileView extends StatefulWidget {
  const AppIntroMobileView({super.key});

  @override
  State<AppIntroMobileView> createState() => _AppIntroMobileViewState();
}

class _AppIntroMobileViewState extends State<AppIntroMobileView> {
  late LoginController loginController;

  @override
  void initState() {
    loginController = Get.find<LoginController>();
    loginController.resetData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Flexible(
          child: AppIntroScreenMobileView(
            key: Key(KeyConstant.introScreen),
          ),
        ),
        loginRegButtonView()
      ],
    );
  }

  Widget loginRegButtonView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButtonOrangeBorder.mobile(
          key: const Key(KeyConstant.btnRegister),
          text: LocalizationHandler.of().register,
          onPressed: () {
            if (kIsWeb) {
              context.navigatePush(
                RoutePath.routeRegistration,
              );
            } else {
              openOptionsToRegistration(context);
            }
          },
        ).marginOnly(left: Dimen.d_10, right: Dimen.d_10).expand(),
        TextButtonOrange.mobile(
          key: const Key(KeyConstant.btnLogin),
          text: LocalizationHandler.of().login,
          onPressed: () async {
            if (kIsWeb) {
              context.navigatePush(
                RoutePath.routeLogin,
              );
            } else {
              openOptionsToLogin(context);
            }
          },
        ).marginOnly(left: Dimen.d_10, right: Dimen.d_10).expand(),
      ],
    )
        .paddingSymmetric(vertical: Dimen.d_17, horizontal: Dimen.d_17)
        .marginOnly(bottom: Dimen.d_20);
  }

  void openOptionsToRegistration(BuildContext context) {
    RegistrationOptionDialog.open(context);
  }

  void openOptionsToLogin(BuildContext context) {
    CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
      isScrollControlled: true,
      height: context.width * 1.75,
      mContext: context,
      child: LoginMobileView(
        loginOptions: loginController.initLoginOptions(),
        crossAxisCount: 2,
        title: LocalizationHandler.of().login,
        onClick: onLoginClick,
      ),
    );
  }

  void onLoginClick(int index) {
    context.navigateBack();
    if (index == 0) {
      context.navigatePush(RoutePath.routeLoginMobile);
    } else if (index == 1) {
      context.navigatePush(RoutePath.routeLoginAbhaAddress);
    } else if (index == 2) {
      context.navigatePush(RoutePath.routeLoginAbhaNumber);
    } else if (index == 3) {
      context.navigatePush(RoutePath.routeLoginEmail);
    }
  }
}
