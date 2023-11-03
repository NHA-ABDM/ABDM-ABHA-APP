// import 'package:abha/export_packages.dart';
//
// class UserProfileInformationView extends StatelessWidget {
//   final ProfileModel? profileModel;
//
//   const UserProfileInformationView({super.key, required this.profileModel});
//
//   @override
//   Widget build(BuildContext context) {
//     return userBasicAbhaDetail(context);
//   }
//
//   Widget userBasicAbhaDetail(BuildContext context) {
//     return Column(
//       children: [
//         Align(
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   if (isKycVerified)
//                     const Icon(
//                       IconAssets.checkCircleRounded,
//                       color: AppColors.colorGreenDark,
//                       size: 15,
//                     )
//                   else
//                   // const Icon(
//                   //   IconAssets.closeCircle,
//                   //   color: AppColors.colorRedLight,
//                   // ).marginOnly(left: Dimen.d_10),
//                     CustomSvgImageView(
//                       ImageLocalAssets.selfDeclaredIcon,
//                       width: Dimen.d_20,
//                       height: Dimen.d_20,
//                     ).marginOnly(left: Dimen.d_10),
//                   Text(
//                     isKycVerified
//                         ? LocalizationHandler.of().kycVerified
//                         : LocalizationHandler.of().selfdeclared,
//                     style: CustomTextStyle.caption(context)?.apply(
//                       color: AppColors.colorGreyDark7,
//                       fontWeightDelta: 1,
//                     ),
//                     textAlign: TextAlign.center,
//                   ).marginOnly(left: Dimen.d_10),
//                 ],
//               ),
//             ],
//           ),
//         ).marginOnly(top: Dimen.d_50),
//         IntrinsicHeight(
//           child: Stack(
//             children: [
//               Column(
//                 children: [
//               Row(
//               children: [
//               Expanded(
//               flex: 1,
//                 //child: kycStatusWidget(context)
//                 child: titleValueOfProfileBasicInfo(
//                   context, profileModel?.healthIdNumber ?? '',
//                   LocalizationHandler.of().abhaNumber,
//                 ).marginOnly(top: Dimen.d_20),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: titleValueOfProfileBasicInfo(
//                   context,
//                   profileModel?.id ?? '',
//                   LocalizationHandler.of().abhaAddress,
//                 ).marginOnly(top: Dimen.d_20),
//               ),
//             ],
//           ),
//                   Divider(
//                     thickness: Dimen.d_1,
//                     color: AppColors.colorGreyLight7,
//                   ).marginOnly(
//                     top: Dimen.d_15,
//                   ),
//                 ],
//               ),
//
//               /// Vertical Divider line
//               VerticalDivider(
//                 thickness: Dimen.d_1_5,
//                 color: AppColors.colorGreyLight7,
//               ).sizedBox(height: Dimen.d_60).centerWidget,
//             ],
//           ),
//         ),
//         InfoNote(
//           note: LocalizationHandler.of().note_edited_doc_info,
//         ),
//       ],
//     );
//   }
//
//   /// Here is the common widget to arrange the Title and Value [Text]
//   Widget titleValueOfProfileBasicInfo(
//       BuildContext context,
//       String value,
//       String title,
//       ) {
//     return Column(
//       children: [
//         Text(
//           title,
//           style: CustomTextStyle.caption(context)?.apply(
//             color: AppColors.colorGreyDark1,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         Text(
//           value,
//           style: CustomTextStyle.bodyText2(context)?.apply(
//             color: AppColors.colorGreyDark2,
//             fontWeightDelta: 2,
//             fontSizeDelta: -2,
//           ),
//           textAlign: TextAlign.center,
//         ).marginOnly(top: Dimen.d_3),
//       ],
//     );
//   }
//
//   bool get isKycVerified => profileModel?.kycStatus == 'VERIFIED' ||
//       profileModel?.kycVerified == 'true'
//       ? true
//       : false;
// }
