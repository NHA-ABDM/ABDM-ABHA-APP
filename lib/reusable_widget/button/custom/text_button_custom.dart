import 'package:abha/export_packages.dart';
import 'package:abha/utils/decor/button_border_shape.dart';

class TextButtonCustom extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Function()? onPressed;
  final IconData? leadingIcon;
  final IconData? tailingIcon;
  final double borderSize;
  final double leadingIconSize;
  final double tailingIconSize;
  final double? fontSizeDelta;
  final bool centerAlign;
  final bool startAlign;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color leadingIconColor;
  final Color tailingIconColor;

  const TextButtonCustom({
    required this.text,
    required this.onPressed,
    super.key,
    this.width,
    this.height,
    this.borderSize = 5,
    this.leadingIconSize = 30,
    this.tailingIconSize = 30,
    this.fontSizeDelta,
    this.centerAlign = true,
    this.leadingIcon,
    this.tailingIcon,
    this.startAlign = false,
    this.backgroundColor = AppColors.colorWhite,
    this.borderColor = AppColors.colorWhite,
    this.textColor = AppColors.colorAppBlue,
    this.leadingIconColor = AppColors.colorAppBlue,
    this.tailingIconColor = AppColors.colorAppBlue,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        fixedSize: Size(width ?? context.width * 0.85, height ?? Dimen.d_50),
        shape: ButtonBorderShape()
            .getSquareButton(color: borderColor, radius: borderSize),
      ),
      child: Row(
        mainAxisAlignment: centerAlign
            ? MainAxisAlignment.center
            : startAlign
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
        children: WidgetUtility.spreadWidgets(
          [
            if (leadingIcon != null)
              Icon(
                size: leadingIconSize,
                leadingIcon,
                color: leadingIconColor,
              ),
            Flexible(
              child: Text(
                text,
                style: CustomTextStyle.bodyMedium(context)?.apply(
                  fontSizeDelta: fontSizeDelta ?? 0.0,
                  color: textColor,
                ),
                // textAlign: TextAlign.center,
              ),
            ),
            if (tailingIcon != null)
              Icon(
                size: tailingIconSize,
                tailingIcon,
                color: tailingIconColor,
              )
          ],
          interItemSpace: Dimen.d_8,
        ),
      ),
    );
  }
}
