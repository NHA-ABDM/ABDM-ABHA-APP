import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class CustomToolTipMessage extends StatelessWidget {
  final String message;
  final int showDuration;
  const CustomToolTipMessage({required this.message, super.key, this.showDuration = 2});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: 10.0,
      margin: EdgeInsets.symmetric(horizontal: Dimen.d_30),
      padding: EdgeInsets.only(
        left: Dimen.d_8,
        top: Dimen.d_8,
        bottom: Dimen.d_8,
        right: Dimen.d_20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimen.d_4),
        color: AppColors.colorBlack.withOpacity(0.8),
      ),
      triggerMode: TooltipTriggerMode.tap,
      textStyle: CustomTextStyle.titleSmall(context)
          ?.copyWith(height: 1.5, color: AppColors.colorWhite),
      message: message.trim(),
      showDuration: Duration(seconds: showDuration),
      child: Icon(
        IconAssets.infoOutline,
        size: kIsWeb ? Dimen.d_16 : null,
      ),
    );
  }
}
