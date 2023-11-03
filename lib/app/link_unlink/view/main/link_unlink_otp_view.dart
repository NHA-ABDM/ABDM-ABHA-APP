import 'package:abha/app/link_unlink/view/desktop/link_unlink_confirm_desktop_view.dart';
import 'package:abha/app/link_unlink/view/desktop/link_unlink_otp_desktop_view.dart';
import 'package:abha/app/link_unlink/view/mobile/link_unlink_otp_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class LinkUnlinkOtpView extends StatefulWidget {
  final Map arguments;

  const LinkUnlinkOtpView({required this.arguments, super.key});

  @override
  LinkUnlinkOtpViewState createState() => LinkUnlinkOtpViewState();
}

class LinkUnlinkOtpViewState extends State<LinkUnlinkOtpView> {
  late LinkUnlinkController _linkUnlinkController;
  late Timer _timer;

  @override
  void initState() {
    _linkUnlinkController = Get.find<LinkUnlinkController>();
    _startOtpTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  /// @Here function call the api and resend the otp on users device.
  void _onResendOtp() async {
    if (_linkUnlinkController.isResendOtpEnabled) {
      await _linkUnlinkController.functionHandler(
        function: () => _linkUnlinkController.getAbhaNumberAuthInit(
          widget.arguments[IntentConstant.mobileEmail],
        ),
        isLoaderReq: true,
      );
      if (_linkUnlinkController.responseHandler.status == Status.success) {
        _linkUnlinkController.textEditingController.text = '';
        _timer.cancel();
        _startOtpTimer();
      }
    }
  }

  /// @Here start the timer
  void _startOtpTimer() {
    _linkUnlinkController.functionHandler(
      function: () => _linkUnlinkController.otpTimerInit(),
      isUpdateUi: true,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _linkUnlinkController.functionHandler(
        function: () => _linkUnlinkController.otpTimerCountDown(),
        isUpdateUi: true,
      );
    });
  }

  /// @Here function verifies the entered otp on textfield.
  /// Otp value is verified by calling api by passing the entered otp value.
  Future<void> _onOtpVerify() async {
    if (Validator.isOtpValid(_linkUnlinkController.otpValue)) {
      await _linkUnlinkController.functionHandler(
        function: () => _linkUnlinkController
            .getAbhaNumberOtpVerify(_linkUnlinkController.otpValue),
        isLoaderReq: true,
      );
      if (_linkUnlinkController.responseHandler.status == Status.success) {
        if (_linkUnlinkController.tempResponseData
                .containsKey(ApiKeys.responseKeys.authResult) &&
            _linkUnlinkController
                .tempResponseData[ApiKeys.responseKeys.authResult]
                .toString()
                .contains('failed')) {
          String message = _linkUnlinkController
              .tempResponseData[ApiKeys.responseKeys.message];
          if (message.toLowerCase().contains('otp expired, please try again')) {
            message = LocalizationHandler.of().otpExpired;
          } else if (message
              .toLowerCase()
              .contains('otp is either expired or incorrect')) {
            message = LocalizationHandler.of().invalidOrExpiredOtp;
          } else if (message.toLowerCase().contains('otp did not match')) {
            message = LocalizationHandler.of().invalidOrExpiredOtp;
          } else if (message
              .toLowerCase()
              .contains('entered otp is incorrect')) {
            message = LocalizationHandler.of().invalidOrExpiredOtp;
          } else {
            message = LocalizationHandler.of().somethingWrong;
          }
          MessageBar.showToastDialog(
            message,
            onPositiveButtonPressed: () {
              _linkUnlinkController.textEditingController.clear();
            },
          );
        } else {
          await _linkUnlinkController.getAbhaNumberLinkDeLink();

          _linkUnlinkController.textEditingController.clear();
          _timer.cancel();

          /// Below code will set the ABHA number if it is linked in this operation so that it can be shown in confirmation screen
          abhaSingleton.getAppData.setAbhaNumber(
            widget.arguments[IntentConstant.mobileEmail] ?? '',
          );

          navigateToConfirmView();
        }
      }
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
    }
  }

  /// @Here navigate to next Confirm Screen.
  void navigateToConfirmView() {
    if (kIsWeb) {
      context
          .openDialog(
        CustomSimpleDialog(
          size: 10,
          child: LinkUnlinkConfirmDesktopView(
            linkUnlinkController: _linkUnlinkController,
          ),
        ),
      )
          .then((value) {
        context.navigateBack();
        context.navigatePush(RoutePath.routeDashboard);
      });
    } else {
      Map data = _linkUnlinkController.responseHandler.data;
      if (data.isNotEmpty) {
        context
            .navigatePush(RoutePath.routeLinkUnlinkConfirmView)
            .whenComplete(() => context.navigateBack());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().otpVerification,
      type: LinkUnlinkOtpView,
      mobileBackgroundColor: AppColors.colorWhite,
      paddingValueMobile: Dimen.d_0,
      bodyMobile: LinkUnlinkOtpMobileView(
        mobileEmailValue: widget.arguments[IntentConstant.mobileEmail],
        onOtpVerify: _onOtpVerify,
        onResendOtp: _onResendOtp,
      ),
      bodyDesktop: LinkUnlinkOtpDesktopView(
        mobileEmailValue: widget.arguments[IntentConstant.mobileEmail],
        onOtpVerify: _onOtpVerify,
        onResendOtp: _onResendOtp,
      ),
    );
  }
}
