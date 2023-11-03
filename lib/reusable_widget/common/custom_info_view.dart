// import 'package:abha/localization/localization_handler.dart';
// import 'package:abha/network/api_response_handler.dart';
// import 'package:abha/reusable_widget/button/blue/elevated_button_blue.dart';
// import 'package:abha/utils/common/dimes.dart';
// import 'package:abha/utils/extensions/extension.dart';
// import 'package:abha/utils/theme/app_colors.dart';
// import 'package:abha/utils/theme/app_text_style.dart';
// import 'package:abha/utils/validate/validator.dart';
// import 'package:flutter/material.dart';
//
// class CustomInfoView extends StatelessWidget {
//   final String? infoMessageTitle;
//   final String? infoMessageSubTitle;
//   final Color? colorTitle;
//   final Color? colorSubTitle;
//
//   const CustomInfoView({
//     super.key,
//     this.infoMessageTitle,
//     this.infoMessageSubTitle,
//     this.colorTitle,
//     this.colorSubTitle,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: <Widget>[
//         Text(
//           infoMessageTitle ?? LocalizationHandler.of().noDataAvailable,
//           textAlign: TextAlign.center,
//           style: CustomTextStyle.bodySmall(context)
//               ?.apply(color: colorTitle ?? AppColors.colorBlueDark1),
//         ).paddingOnly(left: Dimen.d_20, right: Dimen.d_20),
//         if (!Validator.isNullOrEmpty(infoMessageSubTitle))
//           Text(
//             infoMessageSubTitle ?? '',
//             textAlign: TextAlign.center,
//             style: CustomTextStyle.bodySmall(context)
//                 ?.apply(color: colorSubTitle ?? AppColors.colorBlueDark1),
//           ).marginOnly(top: Dimen.d_5),
//
//       ],
//     ).sizedBox(height: Dimen.d_290).centerWidget;
//   }
// }
