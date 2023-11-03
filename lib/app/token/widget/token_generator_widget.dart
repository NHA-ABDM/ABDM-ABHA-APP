import 'package:abha/app/token/token_controller.dart';
import 'package:abha/export_packages.dart';

class TokenPopup {
  void showTokenCreatedPopup(
    BuildContext context,
    TokenController tokenController,
  ) {
    context.openDialog(
      CustomSimpleDialog(
        size: 10,
        paddingLeft: Dimen.d_5,
        child: Column(
          children: [
            Text(
              tokenController.tokenNo,
              textAlign: TextAlign.center,
              style: CustomTextStyle.displaySmall(context)?.apply(
                color: AppColors.colorGreenDark2,
              ),
            ),
            Text(
              LocalizationHandler.of().hereIsTokenNo,
              textAlign: TextAlign.center,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack6,
                fontWeightDelta: 2,
                fontSizeDelta: -2,
              ),
            ).marginOnly(top: Dimen.d_10),
            Text(
              LocalizationHandler.of()
                  .tokenValidFor((tokenController.expiryTime ~/ 60).toString()),
              textAlign: TextAlign.center,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack3,
                fontSizeDelta: -2,
                fontWeightDelta: -1,
              ),
            ).marginOnly(top: Dimen.d_10),
            TextButtonOrange.mobile(
              text: LocalizationHandler.of().okay,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(
              top: Dimen.d_30,
              left: Dimen.d_20,
              right: Dimen.d_20,
              bottom: Dimen.d_20,
            )
          ],
        ),
      ),
    );
  }

  void showTokenExpiredPopup(BuildContext context) {
    context.openDialog(
      CustomSimpleDialog(
        size: 10,
        paddingLeft: Dimen.d_5,
        child: Column(
          children: [
            CustomSvgImageView(
              ImageLocalAssets.tokenExpireClock,
              width: Dimen.d_48,
            ),
            Text(
              LocalizationHandler.of().tokenNoExpire,
              textAlign: TextAlign.center,
              style: CustomTextStyle.bodySmall(context)?.apply(
                color: AppColors.colorBlack6,
                fontSizeDelta: -1,
                fontWeightDelta: 2,
              ),
            ).marginOnly(top: Dimen.d_10),
            TextButtonOrange.mobile(
              text: LocalizationHandler.of().okay,
              onPressed: () {
                Navigator.pop(context);
              },
            ).marginOnly(
              top: Dimen.d_30,
              left: Dimen.d_20,
              right: Dimen.d_20,
              bottom: Dimen.d_20,
            )
          ],
        ),
      ),
    );
  }
}
