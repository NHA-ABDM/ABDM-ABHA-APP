import 'package:abha/utils/common/dimes.dart';
import 'package:abha/utils/constants/assets_constants.dart';
import 'package:abha/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CloseWindow extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color color;

  const CloseWindow({
    super.key,
    this.onPressed,
    this.color = AppColors.colorGreyDark,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Icon(
        IconAssets.close,
        color: color,
        size: Dimen.d_24,
      ),
    );
  }
}
