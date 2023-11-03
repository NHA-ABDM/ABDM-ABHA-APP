// import 'package:abha/export_packages.dart';
//
// class ProfileHeaderView extends StatefulWidget {
//   const ProfileHeaderView({super.key});
//
//   @override
//   ProfileHeaderViewState createState() => ProfileHeaderViewState();
// }
//
// class ProfileHeaderViewState extends State<ProfileHeaderView> {
//   ProfileModel? _profileModel;
//   late ProfileController _profileController;
//   late bool _kycDetail;
//
//   @override
//   void initState() {
//     _profileController = Get.find<ProfileController>();
//     _profileModel = _profileController.profileModel;
//     _kycDetail = _profileController.getKycDetail();
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _profileHeaderWidget();
//   }
//
//   Widget _profileHeaderWidget() {
//     return ColoredBox(
//       color: AppColors.colorWhite1,
//       child: Column(
//         children: [
//           Stack(
//             children: [
//               /// close the navigation drawer
//               _closeIcon(),
//               Container(
//                 alignment: Alignment.center,
//                 child: Stack(
//                   children: [_userProfileImage(), _editUserIcon()],
//                 ),
//               ).marginOnly(top: Dimen.d_0, bottom: Dimen.d_0),
//             ],
//           ),
//
//           ///Name of user
//           _textUserName(),
//
//           /// KYC verify or not status
//           _userKYCVerifyStatus(),
//
//           /// Linear progress bar
//           // _progressBar(),
//         ],
//       ),
//     );
//   }
//
//   Widget _closeIcon() {
//     return GestureDetector(
//       onTap: () {
//         context.navigateBack();
//       },
//       child: Icon(
//         IconAssets.closeCircle,
//         size: Dimen.d_30,
//         color: AppColors.colorAppOrange,
//       ),
//     ).alignAtTopRight();
//   }
//
//   /// User Profile Image [CircleAvatar] Widget
//   Widget _userProfileImage() {
//     return CustomCircularBorderBackground(
//       image: _profileModel?.profilePhoto ?? '',
//     ).centerWidget;
//   }
//
//   /// User profile edit [Icon] Widget
//   Widget _editUserIcon() {
//     return GestureDetector(
//       onTap: () {
//         context.navigatePushNamed(
//           RoutesName.routeUpdateAddress,
//         );
//       },
//       child: SvgPicture.asset(
//         ImageLocalAssets.editProfileIconPng,
//         width: Dimen.d_40,
//         height: Dimen.d_40,
//       ).alignAtTopCenter().marginOnly(left: Dimen.d_120, top: Dimen.d_50),
//     );
//   }
//
//   /// UserName [Text] Widget
//   Widget _textUserName() {
//     return Text(
//       '${_profileModel?.fullName}',
//       style: CustomTextStyle.bodyText1(context)?.apply(
//         color: AppColors.colorGreyDark2,
//       ),
//       textAlign: TextAlign.center,
//     ).marginOnly(bottom: Dimen.d_3);
//   }
//
//   /// User KYC Verified Status [Text] and [Icon] Widget
//   Widget _userKYCVerifyStatus() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           _kycDetail
//               ? LocalizationHandler.of().kycVerified
//               : LocalizationHandler.of().selfdeclared,
//           style: CustomTextStyle.bodyText2(context)?.apply(
//             color: AppColors.colorGrey1,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         _kycDetail
//             ? const Icon(
//                 IconAssets.checkCircleRounded,
//                 color: AppColors.colorGreenDark,
//               ).marginOnly(left: Dimen.d_10)
//             : const Icon(
//                 IconAssets.closeCircle,
//                 color: AppColors.colorRedLight,
//               )
//           ..marginOnly(left: Dimen.d_10),
//       ],
//     );
//   }
//
//   /// Proggress Bar Widget
//   // Widget _progressBar() {
//   //   return Align(
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: [
//   //         LinearProgressBar(
//   //           percent: 0.9,
//   //           width: context.width * 0.75,
//   //           height: Dimen.d_12,
//   //         ),
//   //         Text(
//   //           '90%',
//   //           style: CustomTextStyle.bodyText2(context)?.apply(
//   //             color: AppColors.colorAppBlue,
//   //           ),
//   //           textAlign: TextAlign.center,
//   //         ).marginOnly(left: Dimen.d_10),
//   //       ],
//   //     ).marginOnly(top: Dimen.d_10),
//   //   );
//   // }
//
//   /// User ABHA Address [Text] Widget
//   // Widget _userABHAAddress() {
//   //   return Text(
//   //     '${LocalizationHandler.of().abhaAddress} ${_profileModel?.id}',
//   //     style: CustomTextStyle.bodyText2(context)?.apply(
//   //       color: AppColors.colorGreyDark2,
//   //     ),
//   //     textAlign: TextAlign.center,
//   //   ).marginOnly(top: Dimen.d_5);
//   // }
// }
