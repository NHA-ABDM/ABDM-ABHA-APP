import 'package:abha/app/app_intro/model/login_option_model.dart';
import 'package:abha/app/registration/view/mobile/registration_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/dialog/custom_bottom_sheet_or_dialog.dart';

class RegistrationOptionDialog {
  static open(BuildContext mContext) {
    CustomBottomSheetOrDialogHandler.bottomSheetOrDialog(
      mContext: mContext,
      isScrollControlled: true,
      height: mContext.width * 1.0,
      child: RegistrationMobileView(
        registrationViewOptions: [
          LoginOptionModel(
            LocalizationHandler.of().abhaNumber,
            ImageLocalAssets.loginAbhaNoIconSvg,
          ),
          LoginOptionModel(
            LocalizationHandler.of().mobileNumber,
            ImageLocalAssets.loginMobileNoIconSvg,
          ),
          // LoginOptionModel(
          //   LocalizationHandler.of().emailId,
          //   ImageLocalAssets.loginEmailIconSvg,
          // ),
        ],
        crossAxisCount: 2,
        title: LocalizationHandler.of().register,
        onClick: (index, context) {
          context.navigateBack();
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
      ),
    );
  }
}
