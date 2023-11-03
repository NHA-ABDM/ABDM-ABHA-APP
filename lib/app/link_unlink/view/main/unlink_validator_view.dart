import 'package:abha/app/link_unlink/view/widget/common_link_unlink_widget.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/common/validate_using_option_view.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';
import 'package:flutter/foundation.dart';

class UnLinkValidatorView extends StatefulWidget {
  const UnLinkValidatorView({super.key});

  @override
  UnLinkValidatorViewState createState() => UnLinkValidatorViewState();
}

class UnLinkValidatorViewState extends State<UnLinkValidatorView> {
  late LinkUnlinkController _linkUnlinkController;
  final borderDecoration = abhaSingleton.getBorderDecoration;
  // String _selectedRadioButton = '';
  LinkUnlinkMethod? _selectedValidationMethod;
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _linkUnlinkController = Get.find<LinkUnlinkController>();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  /// @Here this function call on click of radio buttons and parameter [value] assignes
  /// to another variable [_selectedValidationMethod] also updates the Ui according to selection
  /// of auth mode either [verifyAadhaar] or [verifyMobile].
  void checkOnValidationTypeClick(LinkUnlinkMethod value) {
    _linkUnlinkController.linkUnlinkMethod = value;
    /*if (value.toString().contains(LocalizationHandler.of().aadhaarOtp)) {
      _linkUnlinkController.linkUnlinkMethod = LinkUnlinkMethod.verifyAadhaar;
    } else {
      _linkUnlinkController.linkUnlinkMethod = LinkUnlinkMethod.verifyMobile;
    }*/
    _selectedValidationMethod = value;
    isButtonEnable.value = true;
    _linkUnlinkController.update([LinkUnlinkUpdateUiBuilderIds.radioToggle]);
  }

  /// @Here function call api by passing abha number for authentication.
  /// After Success response navigate to OTP Screen.
  void _onAbhaNumberInit() async {
    if (Validator.isNullOrEmpty(_selectedValidationMethod)) {
      MessageBar.showToastDialog(
        LocalizationHandler.of().pleaseSelectValidationType,
      );
    } else {
      String abhaNumber = abhaSingleton.getAppData.getAbhaNumber();
      await _linkUnlinkController
          .functionHandler(
        function: () => _linkUnlinkController.getAbhaNumberAuthInit(abhaNumber),
        isLoaderReq: true,
      )
          .whenComplete(() {
        if (_linkUnlinkController.responseHandler.status == Status.success) {
          var arguments = {IntentConstant.mobileEmail: abhaNumber};
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
      mobileBackgroundColor: AppColors.colorWhite,
      title: LocalizationHandler.of().unlinkAbhaNumber,
      type: UnLinkValidatorView,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: kIsWeb
          ? MobileWebCardWidget(child: _unLinkMobileWidget())
          : _unLinkMobileWidget(),
      bodyDesktop: CustomDrawerDesktopView(
        widget: _unLinkWebValidatorParentWidget(),
      ),
      // height: 0.30,
      // DesktopCommonScreenWidget(
      //   image: ImageLocalAssets.abhaLogo,
      //   title: LocalizationHandler.of().unlinkAbhaNumber,
      //   child: _unLinkWebWidget(),
      // ),
    );
  }

  /// Here method is used for Validator widget for unlinking the Abha number .
  /// For [Mobile] View
  Widget _unLinkMobileWidget() {
    return Column(
      children: [
        if (kIsWeb)
          Text(
            LocalizationHandler.of().unlinkAbhaNumber,
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).alignAtCenter().paddingSymmetric(vertical: Dimen.d_20),
        _validateUsingAbhaNumberOrAdhaarOtp(),
        ValueListenableBuilder<bool>(
          valueListenable: isButtonEnable,
          builder: (context, isButtonEnable, _) {
            return TextButtonOrange.mobile(
              text: LocalizationHandler.of().continuee,
              isButtonEnable: isButtonEnable,
              onPressed: () {
                _onAbhaNumberInit();
              },
            ).marginOnly(top: Dimen.d_30);
          },
        ),
      ],
    ).paddingSymmetric(
      vertical: Dimen.d_16,
      horizontal: Dimen.d_16,
    );
  }

  /// Here method is parent widget for web in case of validator view for unlink
  /// abha number.
  Widget _unLinkWebValidatorParentWidget() {
    return Column(
      children: [
        Text(
          LocalizationHandler.of().unlinkAbhaNumber,
          style: CustomTextStyle.titleLarge(context)?.apply(
            color: AppColors.colorAppBlue,
            fontWeightDelta: 2,
          ),
        ).alignAtTopLeft().marginOnly(bottom: Dimen.d_20),
        CommonBackgroundCard(
          child: CommonLinkUnlinkWidget(
            image: ImageLocalAssets.unlinkAbhaNumberSvg,
            child: _unLinkWebWidget(),
          ),
        )
      ],
    ).marginAll(
      Dimen.d_20,
    );
  }

  /// Here method is used for Validator widget for unlinking the Abha number .
  /// For [Web] Desktop View
  Widget _unLinkWebWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _validateUsingAbhaNumberOrAdhaarOtp(),
        Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: isButtonEnable,
              builder: (context, isButtonEnable, _) {
                return TextButtonOrange.desktop(
                  text: LocalizationHandler.of().continuee,
                  isButtonEnable: isButtonEnable,
                  onPressed: () {
                    _onAbhaNumberInit();
                  },
                ).marginOnly(
                  top: Dimen.d_30,
                );
              },
            ),
            TextButtonPurple(
              text: LocalizationHandler.of().cancel,
              onPressed: () {
                context.navigateBack();
              },
            ).marginOnly(
              left: Dimen.d_20,
              right: Dimen.d_20,
              top: Dimen.d_30,
            )
          ],
        ),
      ],
    );
  }

  Widget _validateUsingAbhaNumberOrAdhaarOtp() {
    return GetBuilder<LinkUnlinkController>(
      id: LinkUnlinkUpdateUiBuilderIds.radioToggle,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              LocalizationHandler.of().validateUsing,
              style: kIsWeb
                  ? CustomTextStyle.titleMedium(context)?.apply(
                      fontSizeDelta: -1,
                      fontWeightDelta: 1,
                      color: AppColors.colorGreyDark1,
                    )
                  : CustomTextStyle.titleLarge(context)?.apply(
                      fontSizeDelta: -1,
                      fontWeightDelta: 1,
                      color: AppColors.colorGreyDark1,
                    ),
            ),

            /// Icons and Text of Adhaar Otp and Mobile Otp in [Row] Widget
            rowAdhaarAndMobileOtpIcon()
          ],
        );
      },
    );
  }

  /// Here is the widget to select  icon for adhaar and mobile otp type.
  /// It contains the Adhaar otp and Mobile otp Icon and text Widget.
  Widget rowAdhaarAndMobileOtpIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ValidateUsingOptionView(
            onClick: () {
              checkOnValidationTypeClick(
                LinkUnlinkMethod.verifyAadhaar,
              );
            },
            selectedValidationMethod:
                _selectedValidationMethod == LinkUnlinkMethod.verifyAadhaar,
            text: LocalizationHandler.of().aadhaarOtp,
            icon: ImageLocalAssets.loginAdhaarOtpIconOneSvg,
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
          ),
        ),
        SizedBox(
          width: Dimen.d_10,
        ),
        Expanded(
          child: ValidateUsingOptionView(
            onClick: () {
              checkOnValidationTypeClick(LinkUnlinkMethod.verifyMobile);
            },
            selectedValidationMethod:
                _selectedValidationMethod == LinkUnlinkMethod.verifyMobile,
            text: LocalizationHandler.of().mobileOtp,
            icon: ImageLocalAssets.loginMobileNoIconSvg,
            iconWidth: Dimen.d_90,
            iconHeight: Dimen.d_90,
          ),
        ),
      ],
    ).marginOnly(top: Dimen.d_20);
  }
}
