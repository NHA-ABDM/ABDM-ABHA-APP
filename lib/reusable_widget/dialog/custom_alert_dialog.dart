import 'package:abha/export_packages.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? msg;
  final VoidCallback? onPositiveButtonPressed;
  final VoidCallback? onNegativeButtonPressed;
  final String? positiveButtonTitle;
  final String? negativeButtonTitle;
  final bool showCloseButton;
  final Color positiveButtonColor;
  final Color negativeButtonColor;
  final Color positiveButtonTextColor;
  final Color negativeButtonTextColor;
  final double paddingLeft;
  final double paddingTop;

  const CustomAlertDialog({
    super.key,
    this.title,
    this.msg,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
    this.positiveButtonTitle,
    this.negativeButtonTitle,
    this.showCloseButton = false,
    this.positiveButtonColor = AppColors.colorAppOrange,
    this.negativeButtonColor = AppColors.colorPurple4,
    this.positiveButtonTextColor = AppColors.colorWhite,
    this.negativeButtonTextColor = AppColors.colorGreyDark4,
    this.paddingLeft = 24.0,
    this.paddingTop = 20.0,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.only(left: paddingLeft, top: paddingTop),
      actionsPadding: EdgeInsets.only(right: paddingLeft, bottom: paddingTop),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? LocalizationHandler.of().alert,
            style: CustomTextStyle.titleLarge(context)?.apply(),
          ),
          if (showCloseButton)
            CloseWindow(
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(right: Dimen.d_20)
          else
            Container()
        ],
      ),
      content: Text(
        msg?.trim() ?? '',
        style: CustomTextStyle.titleLarge(context)?.apply(fontWeightDelta: -1),
      ),
      actions: <Widget>[
        if (!Validator.isNullOrEmpty(negativeButtonTitle))
          TextButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: negativeButtonColor),
            onPressed: onNegativeButtonPressed,
            child: Text(
              negativeButtonTitle!.toUpperCase(),
              style: CustomTextStyle.titleSmall(context)?.apply(
                color: negativeButtonTextColor,
              ),
            ),
          ),
        TextButton(
          style: ElevatedButton.styleFrom(backgroundColor: positiveButtonColor),
          onPressed: onPositiveButtonPressed,
          child: Text(
            positiveButtonTitle?.toUpperCase() ??
                LocalizationHandler.of().ok.toUpperCase(),
            style: CustomTextStyle.titleSmall(context)?.apply(
              color: positiveButtonTextColor,
            ),
          ),
        ),
      ],
    );
  }
}
