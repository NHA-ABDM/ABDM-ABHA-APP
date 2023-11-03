import 'package:abha/export_packages.dart';
import 'package:abha/utils/decor/button_border_shape.dart';
import 'package:flutter/foundation.dart';

class ElevatedButtonOrangeBorder extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final VoidCallback onPressed;
  final bool isLeadingIconRequired;
  final bool isTrailingIconRequired;
  final IconData? icon;
  final double size;
  final double? fontSizeDelta;
  final bool isCenter;
  final bool startAlign;
  final Color textColor;
  final Color iconColor;

  const ElevatedButtonOrangeBorder({
    required this.text,
    required this.onPressed,
    super.key,
    this.width,
    this.height,
    this.isLeadingIconRequired = false,
    this.isTrailingIconRequired = false,
    this.icon,
    this.size = 5,
    this.fontSizeDelta,
    this.isCenter = true,
    this.startAlign = false,
    this.textColor = AppColors.colorAppOrange,
    this.iconColor = AppColors.colorAppOrange,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(
          kIsWeb ? width ?? context.width * 0.10 : width ?? context.width,
          height ?? Dimen.d_50,
        ),
        backgroundColor: AppColors.colorWhite,
        shape: ButtonBorderShape().getSquareButton(
          radius: size,
          color: AppColors.colorAppOrange,
        ),
      ),
      child: Row(
        // mainAxisSize: kIsWeb ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: isCenter
            ? MainAxisAlignment.center
            : startAlign
                ? MainAxisAlignment.start
                : MainAxisAlignment.spaceBetween,
        children: [
          if (isLeadingIconRequired)
            Icon(
              icon,
              size: Dimen.d_20,
              color: iconColor,
            )
          else
            Container(),
          Flexible(
            child: Text(
              text,
              style: CustomTextStyle.bodyMedium(context)?.apply(
                fontSizeDelta: fontSizeDelta ?? 0.0,
                color: textColor,
                fontWeightDelta: 2,
              ),
            ).marginOnly(left: Dimen.d_8),
          ),
          if (isTrailingIconRequired)
            Icon(icon, size: Dimen.d_25, color: iconColor)
          else
            Container(),
        ],
      ),
    );
  }
}
