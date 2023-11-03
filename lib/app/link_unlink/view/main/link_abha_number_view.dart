import 'package:abha/app/link_unlink/view/desktop/link_abha_number_desktop_view.dart';
import 'package:abha/app/link_unlink/view/mobile/link_abha_number_mobile_view.dart';
import 'package:abha/export_packages.dart';

class LinkAbhaNumberView extends StatefulWidget {
  const LinkAbhaNumberView({super.key});

  @override
  LinkAbhaNumberViewState createState() => LinkAbhaNumberViewState();
}

class LinkAbhaNumberViewState extends State<LinkAbhaNumberView> {
  late LinkUnlinkController _linkUnlinkController;
  late String _abhaNumberValue;
  LinkUnlinkMethod? _selectedRadioButton;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  // bool _isAuthModeFetched = false;
  final borderDecoration = abhaSingleton.getBorderDecoration;
  // final _abhaNumberTEC =
  //     AppTextController(mask: StringConstants.abhaNumberFormatValue);

  @override
  void initState() {
    _linkUnlinkController = Get.put(LinkUnlinkController(LinkUnlinkRepoImpl()));
    // _isAuthModeFetched = true;
    _linkUnlinkController.actionType = StringConstants.link;
    // _linkUnlinkController.functionHandler(
    //   isUpdateUi: true,
    //   updateUiBuilderIds: [LinkUnlinkUpdateUiBuilderIds.radioToggle],
    // );
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteLinkUnlink();
    super.dispose();
  }

  /// @Here function search the valid abha number by calling api. After success response
  /// allow user to select the authentication mode either AadhaarOtp or MobileOtp.
  // Future<void> _onAbhaNumberSearch() async {
  //   _abhaNumberValue = _abhaNumberTEC.text.replaceAll('-', '');
  //   if (!Validator.isAbhaNumberValid(_abhaNumberValue)) {
  //     MessageBar.showToastDialog(LocalizationHandler.of().invalidAbhaNumber);
  //   } else {
  //     await _linkUnlinkController.functionHandler(
  //       function: () => _linkUnlinkController.getAbhaNumberAuthSearch(
  //         _abhaNumberValue,
  //         StringConstants.link,
  //       ),
  //       isLoaderReq: true,
  //       isUpdateUi: true,
  //       updateUiBuilderIds: [LoginUpdateUiBuilderIds.abhaNumberValidator],
  //     );
  //     if (_linkUnlinkController.responseHandler.status == Status.success) {
  //       _isAuthModeFetched = true;
  //       _linkUnlinkController.functionHandler(
  //         isUpdateUi: true,
  //         updateUiBuilderIds: [LinkUnlinkUpdateUiBuilderIds.radioToggle],
  //       );
  //     }
  //   }
  // }

  /// @Here this function call on click of radio buttons and parameter [value] assignes
  /// to another variable [_selectedRadioButton] also updates the Ui according to selection
  /// of auth mode either [verifyAadhaar] or [verifyMobile].
  void _onClickRadioButton(LinkUnlinkMethod value) {
    _selectedRadioButton = value;
    _linkUnlinkController.linkUnlinkMethod = value;
    // if (value.toString().contains(LocalizationHandler.of().aadhaarOtp)) {
    //   _linkUnlinkController.linkUnlinkMethod = LinkUnlinkMethod.verifyAadhaar;
    // } else {
    //   _linkUnlinkController.linkUnlinkMethod = LinkUnlinkMethod.verifyMobile;
    // }
    _linkUnlinkController.update([LinkUnlinkUpdateUiBuilderIds.radioToggle]);
  }

  /// @Here function call api by passing abha number for authentication.
  /// After Success response navigate to OTP Screen.
  Future<void> _onAbhaNumberAuthInit() async {
    _abhaNumberValue = _linkUnlinkController.abhaNumberTEC.text.trim();
    if (!Validator.isAbhaNumberWithDashValid(_abhaNumberValue)) {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidAbhaNumber);
    } else if (Validator.isNullOrEmpty(_selectedRadioButton)) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().pleaseSelectValidationType,
      );
    } else {
      await _linkUnlinkController
          .functionHandler(
        function: () => _linkUnlinkController.getAbhaNumberAuthInit(
          _abhaNumberValue,
        ),
        isLoaderReq: true,
      )
          .then((value) {
        if (_linkUnlinkController.responseHandler.status == Status.success) {
          var arguments = {IntentConstant.mobileEmail: _abhaNumberValue};
          context
              .navigatePush(
                RoutePath.routeLinkUnlinkOtpView,
                arguments: arguments,
              )
              .whenComplete(() => context.navigateBack());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().linkAbhaNumber,
      type: LinkAbhaNumberView,
      paddingValueMobile: Dimen.d_0,
      mobileBackgroundColor: AppColors.colorWhite,
      bodyMobile: LinkAbhaNumberMobileView(
        linkUnlinkController: _linkUnlinkController,
        onAbhaNumberAuthInit: _onAbhaNumberAuthInit,
        onClickRadioButton: _onClickRadioButton,
        isButtonEnable: isButtonEnable,
      ),
      bodyDesktop: LinkAbhaNumberDesktopView(
        linkUnlinkController: _linkUnlinkController,
        onAbhaNumberAuthInit: _onAbhaNumberAuthInit,
        onClickRadioButton: _onClickRadioButton,
        isButtonEnable: isButtonEnable,
      ),
    );
  }

  // Widget _loginAbhaNumberWidget() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         LocalizationHandler.of().linkAbhaNumberMsg,
  //         style: CustomTextStyle.bodyMedium(context)
  //             ?.apply(color: AppColors.colorBlack6, fontWeightDelta: 2),
  //       ).marginOnly(top: Dimen.d_20),
  //       Text(
  //         abhaSingleton.getAppData.getAbhaAddress(),
  //         style: CustomTextStyle.bodyMedium(context)?.apply(),
  //       ).marginOnly(top: Dimen.d_5),
  //       Text(
  //         LocalizationHandler.of().abhaNumber,
  //         style: CustomTextStyle.labelMedium(context)?.apply(
  //           color: AppColors.colorGrey3,
  //           fontWeightDelta: 2,
  //         ),
  //       ).marginOnly(top: Dimen.d_20),
  //       Flexible(
  //         child: AppTextField(
  //           key: const Key(KeyConstant.abhaNumberTextField),
  //           textEditingController: _abhaNumberTEC,
  //           textInputType: TextInputType.number,
  //         ).marginOnly(top: Dimen.d_20),
  //       ),
  //       GetBuilder<LinkUnlinkController>(
  //         id: LinkUnlinkUpdateUiBuilderIds.radioToggle,
  //         builder: (_) {
  //           return Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 LocalizationHandler.of().validateUsing,
  //                 style: CustomTextStyle.bodyMedium(context)?.apply(
  //                   fontWeightDelta: 2,
  //                   color: AppColors.colorAppBlue,
  //                 ),
  //               ).marginOnly(top: Dimen.d_50),
  //               rowAbhaNumberOrAdhaarOtpIcon(),
  //             ],
  //           );
  //         },
  //       ),
  //       TextButtonOrange(
  //         text: LocalizationHandler.of().continuee,
  //         onPressed: () {
  //           _onAbhaNumberAuthInit();
  //         },
  //       ).centerWidget.marginOnly(top: Dimen.d_50),
  //     ],
  //   ).marginOnly(left: Dimen.d_17, right: Dimen.d_17);
  // }

  Widget rowAbhaNumberOrAdhaarOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              setState(() {
                _selectedRadioButton = LinkUnlinkMethod.verifyAadhaar;
                _onClickRadioButton(_selectedRadioButton!);
              });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _selectedRadioButton == LinkUnlinkMethod.verifyAadhaar,
            text: LocalizationHandler.of().aadhaarOtp,
            icon: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
          ),
        ),
        SizedBox(
          width: Dimen.d_10,
        ),
        Expanded(
          child: ValidateAuthOptionView(
            onClick: () {
              setState(() {
                _selectedRadioButton = LinkUnlinkMethod.verifyMobile;
                _onClickRadioButton(_selectedRadioButton!);
              });
            },
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
            isSelected: _selectedRadioButton == LinkUnlinkMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginAbhaAddressIconSvg,
          ).marginOnly(left: Dimen.d_3, right: Dimen.d_3),
        ),
      ],
    ).marginOnly(top: Dimen.d_20);
  }

  /// @Here Widget to show options for Aadhaar Otp and Mobile Otp.
// Widget rowAbhaNumberOrAdhaarOtpIcon() {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.spaceAround,
//     children: [
//       InkWell(
//         onTap: () {
//           _selectedRadioButton = LocalizationHandler.of().aadhaarOtp;
//           _onClickRadioButton(_selectedRadioButton);
//         },
//         child: adhaarOTPVerify(),
//       ),
//       InkWell(
//         onTap: () {
//           _selectedRadioButton = LocalizationHandler.of().mobileOtp;
//           _onClickRadioButton(_selectedRadioButton);
//         },
//         child: abhaNumberVerify(),
//       )
//     ],
//   ).marginOnly(top: Dimen.d_20);
// }
//
// Widget adhaarOTPVerify() {
//   return Container(
//     width: Dimen.d_120,
//     decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
//       size: Dimen.d_10,
//       borderColor: _selectedRadioButton == LocalizationHandler.of().aadhaarOtp
//           ? AppColors.colorAppBlue
//           : AppColors.colorWhite,
//     ),
//     child: Column(
//       children: [
//         const CustomCircularBackground(
//           image: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
//         ),
//         Text(
//           LocalizationHandler.of().aadhaarOtp,
//           style: CustomTextStyle.bodySmall(context)
//               ?.apply(fontWeightDelta: 2, color: AppColors.colorGreyDark2),
//         ).marginOnly(top: Dimen.d_15),
//       ],
//     ).paddingAll(Dimen.d_3),
//   );
// }
//
// Widget abhaNumberVerify() {
//   return Container(
//     width: Dimen.d_120,
//     decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
//       size: Dimen.d_10,
//       borderColor: _selectedRadioButton == LocalizationHandler.of().mobileOtp
//           ? AppColors.colorAppBlue
//           : AppColors.colorWhite,
//     ),
//     child: Column(
//       children: [
//         CustomCircularBackground(
//           image: ImageLocalAssets.loginAbhaAddressIconSvg,
//           width: Dimen.d_40,
//           height: Dimen.d_40,
//         ),
//         Text(
//           LocalizationHandler.of().mobileOtp,
//           style: CustomTextStyle.bodySmall(context)
//               ?.apply(fontWeightDelta: 2, color: AppColors.colorGreyDark2),
//         ).marginOnly(top: Dimen.d_15),
//       ],
//     ).paddingAll(Dimen.d_3),
//   );
// }
}
