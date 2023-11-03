import 'package:abha/export_packages.dart';
import 'package:abha/utils/theme/desktop/card_theme_desktop.dart';

class DesktopCommonScreenWidget extends StatelessWidget {
  final String image;
  final String? title;
  final Widget child;
  final Widget? bottomView;

  const DesktopCommonScreenWidget({
    required this.image,
    required this.title,
    required this.child,
    super.key,
    this.bottomView,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: CardThemeDesktop.backgroundColor,
        border: CardThemeDesktop.border,
        boxShadow: CardThemeDesktop.shadow,
        borderRadius: BorderRadius.circular(CardThemeDesktop.borderRadius),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: CustomImageView(
                image: image,
                // width: Dimen.d_200,
                height: Dimen.d_260,
              ).centerWidget.paddingSymmetric(
                    vertical: Dimen.d_24,
                    horizontal: Dimen.d_20,
                  ),
            ),
            Container(
              width: Dimen.d_1,
              color: AppColors.colorGreyWildSand,
            ).marginSymmetric(vertical: Dimen.d_10),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '',
                    textAlign: TextAlign.start,
                    style: CustomTextStyle.titleLarge(context)?.apply(
                      color: AppColors.colorAppBlue,
                      fontWeightDelta: 2,
                    ),
                  ).paddingSymmetric(
                    vertical: Dimen.d_10,
                    // horizontal: Dimen.d_20,
                  ),
                  child.paddingSymmetric(
                    vertical: Dimen.d_10,
                    // horizontal: Dimen.d_20,
                  ),
                  if (bottomView != null)
                    Divider(
                      height: 1,
                      thickness: Dimen.d_1,
                      color: AppColors.colorGreyWildSand,
                    ),
                  if (bottomView != null)
                    Container(
                      child: bottomView,
                    )
                ],
              ).marginSymmetric(
                vertical: Dimen.d_20,
                horizontal: Dimen.d_60,
              ),
            )
          ],
        ),
      ),
    ).paddingSymmetric(
      vertical: Dimen.d_30,
      horizontal: context.width * 0.1,
    );
  }
}
