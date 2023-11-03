import 'package:abha/export_packages.dart';

class ProfileOtpView extends StatefulWidget {
  final Map arguments;
  final bool isDesktopView;

  const ProfileOtpView({
    required this.arguments,
    super.key,
    this.isDesktopView = false,
  });

  @override
  ProfileOtpViewState createState() => ProfileOtpViewState();
}

class ProfileOtpViewState extends State<ProfileOtpView> {
  late ProfileController _profileController;

  // late String _screenTitle = '';
  late String _fromScreenString;
  late Timer _timer;
  bool _updateEmail = false;
  String _otpValue = '';
  final ValueNotifier<bool> _isButtonEnable = ValueNotifier(false);

  // late String _sessionId;
  late String _mobileEmailData;
  TextEditingController otpTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
    initScreenTitleText();
  }

  @override
  void dispose() {
    _timer.cancel();
    otpTextController.clear();
    super.dispose();
  }

  void initData() {
    _profileController = Get.find<ProfileController>();
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    _mobileEmailData = widget.arguments[IntentConstant.data];
    _startOtpTimer();
  }

  void initScreenTitleText() {
    if (_fromScreenString == StringConstants.profileEmailUpdate) {
      // _screenTitle = LocalizationHandler.of().updateEmail;
      _updateEmail = true;
    } else if (_fromScreenString == StringConstants.profileMobileUpdate) {
      // _screenTitle = LocalizationHandler.of().updateMobile;
      _updateEmail = false;
    }
  }

  /// This method is used to resend the OTP for a given sessionId.
  /// and start a timer for the OTP if the response status is successful.
  ///
  /// @param sessionId The sessionId of the user.
  /// @return void
  void _onResendOtp() async {
    if (_profileController.isResendOtpEnabled) {
      await _profileController.functionHandler(
        function: () => _profileController.getEmailMobileOtpGen(
          _mobileEmailData,
          isUpdateEmail: _updateEmail,
        ),
        isLoaderReq: true,
      );
      if (_profileController.responseHandler.status == Status.success) {
        _timer.cancel();
        _startOtpTimer();
      }
    }
  }

  /// This function starts a timer to count down the OTP time.
  /// It calls the [_profileController.functionHandler] function with the [_profileController.otpTimerInit] and [_profileController.otpTimerCountDown] functions as parameters,
  /// and sets a Timer with a duration of 1 second.
  void _startOtpTimer() {
    _profileController.functionHandler(
      function: () => _profileController.otpTimerInit(),
      isUpdateUi: true,
    );
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _profileController.functionHandler(
          function: () => _profileController.otpTimerCountDown(),
          isUpdateUi: true,
        );
      },
    );
  }

  /// This method is used to verify the OTP entered by the user.
  /// It takes in the OTP value entered by the user and checks if it is valid using [Validator.isOtpValid] method.
  /// If valid, it calls [_profileController.getOtpVerify] with the OTP value and session ID as parameters.
  /// If successful, it navigates back and then pushes a new route named [RouteName.routeProfileView].
  /// If not successful, it shows a toast message with [LocalizationHandler.of().invalidOTP].
  Future<void> _onOtpVerify() async {
    _otpValue = otpTextController.text;
    if (Validator.isOtpValid(_otpValue)) {
      _profileController
          .functionHandler(
        function: () =>
            _profileController.getOtpVerify(_otpValue, _updateEmail),
        isLoaderReq: true,
        // successMessage: LocalizationHandler.of().successful,
      )
          .whenComplete(() {
        if (_profileController.responseHandler.status == Status.success) {
          /// TO-IMPLEMENT: make it proper at backend
          if (_profileController.tempResponseData
                  .containsKey(ApiKeys.responseKeys.authResult) &&
              _profileController
                  .tempResponseData[ApiKeys.responseKeys.authResult]
                  .toString()
                  .contains('failed')) {
            String message = _profileController
                .tempResponseData[ApiKeys.responseKeys.message];
            if (message.toLowerCase().contains('entered otp is incorrect')) {
              message = LocalizationHandler.of().invalidOTP;
            } else if (message
                .toString()
                .toLowerCase()
                .contains('otp expired')) {
              message = LocalizationHandler.of().otpExpired;
            } else {
              message = LocalizationHandler.of().somethingWrong;
            }
            MessageBar.showToastDialog(
              message,
              onPositiveButtonPressed: () {
                otpTextController.clear();
              },
            );
          } else {
            String successString = LocalizationHandler.of().mobileUpdatedSuccessMessage;
            if (_fromScreenString == StringConstants.profileEmailUpdate) {
              successString = LocalizationHandler.of().emailUpdatedSuccessMessage;
            }
            MessageBar.showToastSuccess(successString);
            /// Below code will update the updated email/mobile on UI
            _profileController.update();
            context.navigateBack();
          }
        }
      });
    } else {
      MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: otpWidget(),
    );
  }

  Widget otpWidget() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${LocalizationHandler.of().sentSixDigitOTPCode} $_mobileEmailData',
            style: CustomTextStyle.bodyLarge(context)
                ?.apply(color: AppColors.colorBlack4, fontSizeDelta: -2),
          ).marginOnly(top: Dimen.d_20, left: Dimen.d_20),
          AutoFocusTextView(
            textEditingController: otpTextController,
            errorController: _profileController.errorController,
            length: 6,
            width: Dimen.d_50,
            height: Dimen.d_50,
            fieldOuterPadding: EdgeInsets.only(right: Dimen.d_12),
            mainAxisAlignment: MainAxisAlignment.start,
            onCompleted: (value) {
              otpTextController.text = value;
            },
            onChanged: (String value) {
              if (!Validator.isNullOrEmpty(value) && value.length == 6) {
                _isButtonEnable.value = true;
              } else {
                _isButtonEnable.value = false;
              }
            },
          ).marginOnly(top: Dimen.d_10, left: Dimen.d_17, right: Dimen.d_17),
          //.sizedBox(width: context.width / 1.5),
          GetBuilder<ProfileController>(
            builder: (_) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!_profileController.isResendOtpEnabled)
                  Text(
                    '${LocalizationHandler.of().resend_code_in}${_profileController.otpCountDown} ${LocalizationHandler.of().sec}',
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: AppColors.colorBlack4,
                      fontWeightDelta: -1,
                    ),
                  ).marginOnly(left: Dimen.d_17, right: Dimen.d_17)
                else
                  Container(),
                TextButton(
                  key: const Key(KeyConstant.resendOTPBtn),
                  onPressed: () async {
                    if (_profileController.isResendOtpEnabled) {
                      setState(() {
                        otpTextController.clear();
                      });
                    }
                    _onResendOtp();
                  },
                  child: Text(
                    LocalizationHandler.of().resendOTP,
                    style: CustomTextStyle.bodySmall(context)?.apply(
                      color: _profileController.isResendOtpEnabled
                          ? AppColors.colorAppOrange
                          : AppColors.colorGrey,
                    ),
                  ),
                ),
              ],
            ).marginOnly(
              top: Dimen.d_10,
              right: Dimen.d_15,
            ),
          ),
          if (widget.isDesktopView)
            ValueListenableBuilder(
              valueListenable: _isButtonEnable,
              builder: (context, enable, _) {
                return TextButtonOrange.desktop(
                  key: const Key(KeyConstant.continueBtn),
                  isButtonEnable: enable,
                  text: LocalizationHandler.of().continuee,
                  onPressed: () {
                    if (enable) {
                      _onOtpVerify();
                    }
                  },
                ).alignAtBottomRight().marginOnly(
                      top: Dimen.d_20,
                      left: Dimen.d_17,
                      right: Dimen.d_17,
                    );
              },
            )
          else
            ValueListenableBuilder(
              valueListenable: _isButtonEnable,
              builder: (context, enable, _) {
                return TextButtonOrange.mobile(
                  key: const Key(KeyConstant.continueBtn),
                  isButtonEnable: enable,
                  text: LocalizationHandler.of().continuee,
                  onPressed: () {
                    if (enable) {
                      _onOtpVerify();
                    }
                  },
                ).marginOnly(
                  top: Dimen.d_30,
                  left: Dimen.d_17,
                  right: Dimen.d_17,
                  bottom: Dimen.d_30,
                );
              },
            ),
        ],
      ),
    );
  }
}
