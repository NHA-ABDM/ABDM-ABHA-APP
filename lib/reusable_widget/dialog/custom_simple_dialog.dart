import 'package:abha/export_packages.dart';

class CustomSimpleDialog extends StatelessWidget {
  final Widget child;
  final Widget? widget;
  final String? title;
  final String? subTitle;
  final bool showCloseButton;
  final double paddingLeft;
  final double paddingTop;
  final double size;

  const CustomSimpleDialog({
    required this.child,
    super.key,
    this.widget,
    this.title,
    this.subTitle,
    this.showCloseButton = false,
    this.paddingLeft = 0.0,
    this.paddingTop = 0.0,
    this.size = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: abhaSingleton.getBorderDecoration
          .getRectangularShapeBorder(size: size),
      titlePadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,
      title: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (!Validator.isNullOrEmpty(title))
                    Text(
                      title ?? '',
                      style: CustomTextStyle.bodyMedium(context)?.apply(),
                    ),
                  if (!Validator.isNullOrEmpty(subTitle))
                    Text(
                      subTitle ?? '',
                      style: CustomTextStyle.labelMedium(context)?.apply(
                        color: AppColors.colorBlack,
                        fontWeightDelta: -1,
                      ),
                    ).marginOnly(top: Dimen.d_2),
                ],
              ),
              if (showCloseButton)
                CloseWindow(
                  onPressed: () {
                    context.navigateBack();
                  },
                )
              else
                const SizedBox.shrink()
            ],
          ).marginSymmetric(horizontal: Dimen.d_16, vertical: Dimen.d_10),
          if (showCloseButton)
            Divider(
              color: AppColors.colorGreyLight7,
              height: Dimen.d_1,
            ),
        ],
      ),
      children: [child],
    );
  }
}
