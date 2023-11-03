import 'package:abha/utils/common/dimes.dart';
import 'package:abha/utils/decor/button_border_shape.dart';
import 'package:abha/utils/extensions/extension.dart';
import 'package:abha/utils/theme/app_colors.dart';
import 'package:abha/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class ElevatedButtonBlue extends StatelessWidget {
  final String text;
  final double? width;
  final double? height;
  final Function()? onPressed;
  final double fontSizeDelta;

  const ElevatedButtonBlue({
    required this.text,
    required this.onPressed,
    super.key,
    this.width,
    this.height,
    this.fontSizeDelta = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width ?? context.width, height ?? Dimen.d_50),
        backgroundColor: AppColors.colorAppBlue,
        shape:
            ButtonBorderShape().getSquareButton(color: AppColors.colorAppBlue),
      ),
      child: Text(
        text.toUpperCase(),
        style: CustomTextStyle.titleMedium(context)?.apply(
          fontSizeDelta: fontSizeDelta,
          color: AppColors.colorWhite,
        ),
      ),
    );
  }
}
