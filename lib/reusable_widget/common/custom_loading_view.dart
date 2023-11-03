import 'package:abha/utils/common/dimes.dart';
import 'package:abha/utils/extensions/extension.dart';
import 'package:abha/utils/theme/app_colors.dart';
import 'package:abha/utils/theme/app_text_style.dart';
import 'package:flutter/material.dart';

class CustomLoadingView extends StatelessWidget {
  final String? loadingMessage;
  final TextStyle? style;
  final double? width;
  final double? height;
  final Color? color;
  final double strokeWidth;
  const CustomLoadingView({
    super.key,
    this.loadingMessage,
    this.style,
    this.width,
    this.height,
    this.color,
    this.strokeWidth = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // const ProgressLottie()
           CircularProgressIndicator(
            backgroundColor: AppColors.colorAppOrange,
            color: color ?? AppColors.colorAppBlue,
             strokeWidth: strokeWidth,
          ).sizedBox(width: width, height: height),
          Text(
            loadingMessage ?? '',
            textAlign: TextAlign.center,
            style: style ?? CustomTextStyle.bodyLarge(context)?.apply(),
          ).marginOnly(top: Dimen.d_5)
        ],
      ),
    );
  }
}
