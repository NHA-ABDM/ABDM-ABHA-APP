import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/app/share_profile/share_profile_controller.dart';
import 'package:abha/export_packages.dart';

class BaseController extends GetxController {
  late Type _type;
  late Logger _abhaLog;
  // late BuildContext? _context;
  late dynamic tempResponseData;
  late ResponseHandler responseHandler;

  BaseController(type) {
    _type = type;
    _abhaLog = customLogger(_type);
    _abhaLog.d(_type.toString());
    // _context = navKey.currentContext;
    tempResponseData = null;
    responseHandler = ResponseHandler.none();
  }

  Future<void> functionHandler({
    Function()? function,
    bool isLoaderReq = false,
    bool isUpdateUi = false,
    bool isUpdateUiOnLoading = false,
    bool isUpdateUiOnError = false,
    bool isShowError = true,
    List<Object>? updateUiBuilderIds,
    String successMessage = '',
  }) async {
    try {
      _statusHandler(
        apiResHandler: ResponseHandler.loading(),
        isLoaderReq: isLoaderReq,
        isUpdateUi: isUpdateUiOnLoading,
        updateUiBuilderIds: updateUiBuilderIds,
      );
      Validator.isNullOrEmpty(function) ? null : await function!();
      _statusHandler(
        apiResHandler: ResponseHandler.success(
          tempResponseData,
          message: successMessage,
        ),
        isLoaderReq: isLoaderReq,
        isUpdateUi: isUpdateUi,
        updateUiBuilderIds: updateUiBuilderIds,
      );
    } on Exception catch (e) {
      abhaLog.e(e);
      String errorData = e.toString();
      String? msg;
      String? code;
      if (errorData.contains(ApiKeys.responseKeys.message)) {
        msg = errorData.getMessageData;
      }
      if (errorData.contains(ApiKeys.responseKeys.code)) {
        code = errorData.getCodeData;
      }
      _statusHandler(
        apiResHandler: ResponseHandler.error(message: msg, errorCode: code),
        isLoaderReq: isLoaderReq,
        isUpdateUi: isUpdateUiOnError,
        updateUiBuilderIds: updateUiBuilderIds,
        isShowError: isShowError,
      );
    }
  }

  void _statusHandler({
    required ResponseHandler apiResHandler,
    required bool isLoaderReq,
    bool isUpdateUi = false,
    bool isShowError = true,
    List<Object>? updateUiBuilderIds,
  }) {
    responseHandler = apiResHandler;
    switch (responseHandler.status) {
      case Status.loading:
        isLoaderReq ? CustomDialog.showCircularDialog() : null;
        break;
      case Status.success:
        isLoaderReq ? CustomDialog.dismissDialog() : null;
        if (!Validator.isNullOrEmpty(responseHandler.message)) {
          MessageBar.showToastSuccess(responseHandler.message);
        }
        break;
      case Status.error:
        isLoaderReq ? CustomDialog.dismissDialog() : null;
        isShowError ? _errorHandler(responseHandler.errorCode ?? 0) : null;
        break;
      case Status.none:
        break;
      default:
    }
    update(updateUiBuilderIds, isUpdateUi);
  }

  void _errorHandler(dynamic errorCode) {
    int code = ApiErrorCodes.defaultCode;
    String message =
        responseHandler.message?.trim().capitalizeFirstLetter ?? '';
    try {
      if (errorCode is int) {
        code = errorCode;
        switch (code) {
          case ApiErrorCodes.noInternetConnection:
            MessageBar.showToastDialog(
              LocalizationHandler.of().noInternet,
            );
            break;
          case ApiErrorCodes.badResponse:
            MessageBar.showToastDialog(
              LocalizationHandler.of().unableToCompleteRequest,
            );
            break;
          case ApiErrorCodes.invalidToken:
            if (_type == ShareProfileController) {
              MessageBar.showToastDialog(
                LocalizationHandler.of().shareProfileFailure,
              );
            }
            break;
          case ApiErrorCodes.otpRequestLimitExceed:
            MessageBar.showToastDialog(LocalizationHandler.of().otpTimeOut);
            break;
          case ApiErrorCodes.sameRequestID:
            MessageBar.showToastDialog(LocalizationHandler.of().sameRequest);
            break;
          case ApiErrorCodes.failedToFetchConsentReq:
            MessageBar.showToastDialog(
              LocalizationHandler.of().failedToFetchPatientData,
            );
            break;
          case ApiErrorCodes.noPatient:
            MessageBar.showToastDialog(LocalizationHandler.of().noPatientFound);
            break;
          case ApiErrorCodes.invalidOTP:
            MessageBar.showToastDialog(LocalizationHandler.of().invalidOTP);
            break;
          case ApiErrorCodes.noAccountFound:
            MessageBar.showToastDialog(LocalizationHandler.of().noAccountFound);
            break;
          case ApiErrorCodes.noConsentRequestFound:
            MessageBar.showToastDialog(
              LocalizationHandler.of().cannonFindConsentRequest,
            );
            break;
          case ApiErrorCodes.invalidRequestAbhaAddress:
            String? msg;
            if (message.toLowerCase().contains('')) {
              msg = LocalizationHandler.of().invalidAbhaAddress;
            } else if (message.toLowerCase().contains('characters')) {
              msg = LocalizationHandler.of().invalidAbhaAddress;
            } else if (message
                .toLowerCase()
                .contains('Transaction is not found')) {
              msg = LocalizationHandler.of().unableToCompleteRequest;
            } else {
              msg = LocalizationHandler.of().invalidAbhaAddress;
            }
            MessageBar.showToastDialog(msg);
            break;
          case ApiErrorCodes.didNotFoundUser:
            String? msg;
            if (message.toLowerCase().contains('unknown')) {
              msg = LocalizationHandler.of().unableToCompleteRequest;
            } else {
              msg = LocalizationHandler.of().userNotFound;
            }
            MessageBar.showToastDialog(msg);
            break;
          case ApiErrorCodes.nameCharacterTooLong:
            String? msg;
            if (message.contains('Failed to fetch')) {
              msg = message;
            } else {
              msg = LocalizationHandler.of().nameCharacterTooLong;
            }
            MessageBar.showToastDialog(msg);
            break;
          case ApiErrorCodes.didNotFoundProvider:
            MessageBar.showToastDialog(
              LocalizationHandler.of().providerNotFound,
            );
            break;
          case ApiErrorCodes.didNotResultGateway:
            MessageBar.showToastDialog(
              LocalizationHandler.of().unableToCompleteRequest,
            );
            break;
          case ApiErrorCodes.invalidRequest1510:
            String? msg;
            if (message.toLowerCase().contains('mobile') ||
                message.toLowerCase().contains('email')) {
              if (_type == LoginController) {
                if (Get.find<LoginController>().loginMethod ==
                    LoginMethod.mobile) {
                  msg = LocalizationHandler.of().invalidMobile;
                } else if (Get.find<LoginController>().loginMethod ==
                    LoginMethod.email) {
                  msg = LocalizationHandler.of().invalidEmail;
                } else {
                  msg = LocalizationHandler.of().unableToCompleteRequest;
                }
              } else {
                _onSessionExpired();
                // CustomDialog.showPopupDialog(
                //   LocalizationHandler.of().sessionExpired,
                //   onPositiveButtonPressed: _onSessionExpired,
                //   backDismissible: false,
                // );
              }
            } else if (message
                .toLowerCase()
                .contains('otp(one time password)')) {
              msg = LocalizationHandler.of().invalidOTP;
            } else if (message.toLowerCase().contains('password')) {
              msg = LocalizationHandler.of().invalidPass;
            } else if (message.toLowerCase().contains('credentials')) {
              msg = LocalizationHandler.of().invalidCred;
            } else if (message.toLowerCase().contains('uuid')) {
              msg = LocalizationHandler.of().invalidUuidNumber;
            } else if (message
                .toLowerCase()
                .contains('minutes before sending')) {
              msg = LocalizationHandler.of().invalidOTPRequest30Minutes;
            } else if (message.toLowerCase().contains('invalid otp')) {
              msg = LocalizationHandler.of().invalidOTP;
            } else if (message.toLowerCase().contains('abha number')) {
              msg = LocalizationHandler.of().invalidAbhaNumber;
            } else if (message
                .toLowerCase()
                .contains('invalid feedback body')) {
              msg = LocalizationHandler.of().invalidFeedbackBody;
            } else if (message.toLowerCase().contains('feedback')) {
              msg = LocalizationHandler.of().feedbackLimitReached;
            } else {
              msg = LocalizationHandler.of().unableToCompleteRequest;
            }
            MessageBar.showToastDialog(msg);
            break;
          case ApiErrorCodes.maximumLoginAttempt:
            MessageBar.showToastDialog(
              LocalizationHandler.of().maximumLoginAttempt,
            );
            break;
          case ApiErrorCodes.invalidTransactionPin:
          case ApiErrorCodes.invalidTransactionPin_1:
            String? msg;
            if (message.toLowerCase().contains('left')) {
              msg = LocalizationHandler.of().invalidTransactionPinAttemptsLeft(
                message.getDataAfterGivenCharacter(';'),
              );
              MessageBar.showToastDialog(msg);
              break;
            }
            break;
          case ApiErrorCodes.abhaAddressAlreadyExist:
            MessageBar.showToastDialog(
              LocalizationHandler.of().abhaAddressInUse,
            );
            break;
          case ApiErrorCodes.invalidEmailAbhaNumber:
            String? msg;
            if (Get.find<LoginController>().loginMethod == LoginMethod.email) {
              msg = LocalizationHandler.of().invalidEmail;
            } else {
              msg = LocalizationHandler.of().invalidAbhaNumber;
            }
            MessageBar.showToastDialog(msg);
            break;
          case ApiErrorCodes.passwordMustBeDifferent:
            MessageBar.showToastDialog(
              LocalizationHandler.of().passwordMustBeDifferent,
            );
            break;
          case ApiErrorCodes.invalidAuthorizationRequest:
            MessageBar.showToastDialog(
              LocalizationHandler.of().invalidAuthorizationRequest,
            );
            break;
          case ApiErrorCodes.requesterNotAuthorized:
            // CustomDialog.showPopupDialog(LocalizationHandler.of().unableToCompleteRequest,);
            break;
          case ApiErrorCodes.unexpectedError:
            String? msg;
            if (message.contains(StringConstants.invalidProfileImage)) {
              msg = message;
            } else {
              msg = LocalizationHandler.of().unableToCompleteRequest;
            }
            MessageBar.showToastDialog(
              msg,
            );
            update();
            break;
          case ApiErrorCodes.defaultCode:
            MessageBar.showToastDialog(
              LocalizationHandler.of().somethingWrong,
            );
            break;
        }
      } else if (errorCode is String) {
        switch (errorCode.trim()) {
          case ApiErrorCodes.notificationServiceUnavailable:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message.toLowerCase().contains('service unavailable')) {
              msg = LocalizationHandler.of().backendServiceUnavailableMessage;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;
          case ApiErrorCodes.abdm_9999:
          case ApiErrorCodes.abdm_9999_space:
            {
              String msg = LocalizationHandler.of().somethingWrong;
              if (message
                  .toLowerCase()
                  .contains('login via email address otp is not allowed')) {
                msg = LocalizationHandler.of().emailAddressOtpNotAllowed;
              } else if (message
                  .toLowerCase()
                  .contains('transaction is not found for uuid')) {
                msg = LocalizationHandler.of().backendServiceUnavailableMessage;
              } else if (message.toLowerCase().contains('invalid scope')) {
                msg = LocalizationHandler.of().invalidScope;
              } else if (message
                  .toLowerCase()
                  .contains('old and new passwords are same')) {
                msg = LocalizationHandler.of().passwordMustBeDifferent;
              } else if (message.toLowerCase().contains(
                    'the size of the document uploaded exceeds the permissible limits',
                  )) {
                msg = LocalizationHandler.of().sizeOftheDocumentIsBig;
              } else if (message.toLowerCase().contains('x-token expired')) {
                _onSessionExpired();
                // CustomDialog.showPopupDialog(
                //   LocalizationHandler.of().sessionExpired,
                //   onPositiveButtonPressed: _onSessionExpired,
                //   backDismissible: false,
                // );
                break;
              } else if (message
                  .toLowerCase()
                  .contains('email address not found')) {
                msg = LocalizationHandler.of().abhaAddressNotFound;
              } else if (message
                  .toLowerCase()
                  .contains('invalid mobile number')) {
                msg = LocalizationHandler.of().invalidMobileNumber;
              } else if (message.toLowerCase().contains('t-token expired')) {
                msg = LocalizationHandler.of().tTokenExpired;
                CustomDialog.showPopupDialog(
                  msg,
                  onPositiveButtonPressed: () {
                    CustomDialog.dismissDialog();
                    CustomDialog.dismissDialog();
                  },
                  backDismissible: false,
                );
                break;
              } else if (message
                  .toLowerCase()
                  .contains('old & new email are same')) {
                msg = LocalizationHandler.of().sameOldNewEmail;
              } else if (message
                  .toLowerCase()
                  .contains('mobile number not found')) {
                msg = LocalizationHandler.of().abhaAddressNotFound;
              } else if (message
                  .toLowerCase()
                  .contains('cannot find any linked abha address')) {
                msg = LocalizationHandler.of().abhaAddressNotFound;
              } else if (message
                  .toLowerCase()
                  .contains('unable to connect the database')) {
                msg = LocalizationHandler.of().backendServiceUnavailableMessage;
              } else if (message
                  .toLowerCase()
                  .contains('login via mobile number otp is not allowed')) {
                msg = LocalizationHandler.of().loginViaMobileNotAllowed;
              } else if (message
                  .toLowerCase()
                  .contains('login via password is not allowed')) {
                msg = LocalizationHandler.of().loginViaPasswordNotAllowed;
              } else if (message
                  .toLowerCase()
                  .contains('invalid abha address')) {
                msg = LocalizationHandler.of().invalidAbhaAddress;
              } else if (message.toLowerCase().contains(
                    'invalid photo. please upload a file with a human face.',
                  )) {
                msg = LocalizationHandler.of().invalidProfilePhoto;
              } else if (message.toLowerCase().contains(
                    'please provide a photo featuring only one individual and not a group photo.',
                  )) {
                msg = LocalizationHandler.of().groupPhotoNotAllowed;
              } else if (message.toLowerCase().contains(
                    'please upload a photo that matches your current profile picture.',
                  )) {
                msg = LocalizationHandler.of().profilePhotoMismatchWithKycPhoto;
              } else if (message.toLowerCase().contains(
                    'record not found in subscription for given abha user',
                  )) {
                break;
              } else if (message.toLowerCase().contains(
                    'invalid file extension. please upload a file with extensions as jpg/png',
                  )) {
                msg = LocalizationHandler.of().imageFileNotSupported;
              }
              MessageBar.showToastDialog(msg);
              break;
            }
          case ApiErrorCodes.verificationPending:
            MessageBar.showToastDialog(
              message,
            );
            break;
          case ApiErrorCodes.unknownException:
            MessageBar.showToastDialog(
              message,
            );
            break;
          case ApiErrorCodes.abdm_1209:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message.toLowerCase().contains('db service unavailable')) {
              msg = LocalizationHandler.of().backendServiceUnavailableMessage;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;
          case ApiErrorCodes.abdm_1006:
            MessageBar.showToastDialog(
              message,
            );
            break;
          case ApiErrorCodes.abdm_1092_colon:
            MessageBar.showToastDialog(LocalizationHandler.of().consentAlready);
            break;
          case ApiErrorCodes.abdm_1006_colon:
          case ApiErrorCodes.abdm_1006_colon_space:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message
                .toLowerCase()
                .contains('login via email address otp is not allowed')) {
              msg = LocalizationHandler.of().emailAddressOtpNotAllowed;
            } else if (message
                .toLowerCase()
                .contains('transaction is not found for uuid')) {
              msg = LocalizationHandler.of().backendServiceUnavailableMessage;
            } else if (message.toLowerCase().contains('invalid scope')) {
              msg = LocalizationHandler.of().invalidScope;
            } else if (message
                .toLowerCase()
                .contains('old and new passwords are same')) {
              msg = LocalizationHandler.of().passwordMustBeDifferent;
            } else if (message
                .toLowerCase()
                .contains('old & new mobile are same')) {
              msg = LocalizationHandler.of().mobileMustBeDifferent;
            } else if (message.toLowerCase().contains(
                  'the size of the document uploaded exceeds the permissible limits',
                )) {
              msg = LocalizationHandler.of().sizeOftheDocumentIsBig;
            } else if (message.toLowerCase().contains('x-token expired')) {
              _onSessionExpired();
              // CustomDialog.showPopupDialog(
              //   LocalizationHandler.of().sessionExpired,
              //   onPositiveButtonPressed: _onSessionExpired,
              //   backDismissible: false,
              // );
              break;
            } else if (message
                .toLowerCase()
                .contains('email address not found')) {
              msg = LocalizationHandler.of().abhaAddressNotFound;
            } else if (message
                .toLowerCase()
                .contains('invalid mobile number')) {
              msg = LocalizationHandler.of().invalidMobileNumber;
            } else if (message.toLowerCase().contains('t-token expired')) {
              msg = LocalizationHandler.of().tTokenExpired;
              CustomDialog.showPopupDialog(
                msg,
                onPositiveButtonPressed: () {
                  CustomDialog.dismissDialog();
                  CustomDialog.dismissDialog();
                },
                backDismissible: false,
              );
              break;
            } else if (message
                .toLowerCase()
                .contains('old & new email are same')) {
              msg = LocalizationHandler.of().sameOldNewEmail;
            } else if (message
                .toLowerCase()
                .contains('mobile number not found')) {
              msg = LocalizationHandler.of().abhaAddressNotFound;
            } else if (message
                .toLowerCase()
                .contains('cannot find any linked abha address')) {
              msg = LocalizationHandler.of().abhaAddressNotFound;
            } else if (message
                .toLowerCase()
                .contains('unable to connect the database')) {
              msg = LocalizationHandler.of().backendServiceUnavailableMessage;
            } else if (message
                .toLowerCase()
                .contains('login via mobile number otp is not allowed')) {
              msg = LocalizationHandler.of().loginViaMobileNotAllowed;
            } else if (message
                .toLowerCase()
                .contains('login via password is not allowed')) {
              msg = LocalizationHandler.of().loginViaPasswordNotAllowed;
            } else if (message.toLowerCase().contains('invalid abha address')) {
              msg = LocalizationHandler.of().invalidAbhaAddress;
            } else if (message.toLowerCase().contains(
                  'invalid photo. please upload a file with a human face.',
                )) {
              msg = LocalizationHandler.of().invalidProfilePhoto;
            } else if (message.toLowerCase().contains(
                  'please provide a photo featuring only one individual and not a group photo.',
                )) {
              msg = LocalizationHandler.of().groupPhotoNotAllowed;
            } else if (message.toLowerCase().contains(
                  'please upload a photo that matches your current profile picture.',
                )) {
              msg = LocalizationHandler.of().profilePhotoMismatchWithKycPhoto;
            } else if (message.toLowerCase().contains(
                  'record not found in subscription for given abha user',
                )) {
              break;
            } else if (message.toLowerCase().contains(
                  'invalid file extension. please upload a file with extensions as jpg/png',
                )) {
              msg = LocalizationHandler.of().imageFileNotSupported;
            }
            MessageBar.showToastDialog(msg);
            break;
          case ApiErrorCodes.abdm_1211:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message.toLowerCase().contains('user not found')) {
              msg = LocalizationHandler.of().userNotFound;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;
          case ApiErrorCodes.abdm_1016:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message.toLowerCase().contains('invalid timestamp')) {
              msg = LocalizationHandler.of().invalidTimestamp;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;
          case ApiErrorCodes.abdm_1024:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message
                .toLowerCase()
                .contains('dependent service unavailable')) {
              msg = LocalizationHandler.of().backendServiceUnavailableMessage;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;
          case ApiErrorCodes.badRequest:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message.toLowerCase().contains('mobile number not found')) {
              msg = LocalizationHandler.of().mobileNumberNotFound;
            } else if (message.toLowerCase().contains('user not found')) {
              msg = LocalizationHandler.of().userNotFound;
            } else if (message.toLowerCase().contains(
                  'you have exceeded the maximum limit of failed attempts',
                )) {
              msg = LocalizationHandler.of().exceedsMaxLoginAttempts;
            } else if (message.toLowerCase().contains(
                  'uidai error code   400   invalid aadhaar otp value',
                )) {
              msg = LocalizationHandler.of().abhaNumberInvalidOtp;
            } else if (message
                .toLowerCase()
                .contains(StringConstants.requestedMultipleOtp.toLowerCase())) {
              msg = LocalizationHandler.of().requestedMultipleOtp;
            } else if (message.toLowerCase().contains(
                  StringConstants.mobileNoNotMatchWithRecords.toLowerCase(),
                )) {
              msg = LocalizationHandler.of().mobileNotMatchWithRecords;
            } else if (message.toLowerCase().contains(
                  'the provided biometric details and aadhaar details does not match',
                )) {
              msg = LocalizationHandler.of().pidAndAadhaarNotMatched;
            } else if (message.toLowerCase().contains('uidai error')) {
              msg = LocalizationHandler.of().somethingWrong;
            } else if (message
                .toLowerCase()
                .contains('you have requested multiple otps')) {
              msg = LocalizationHandler.of().exceedMaxAttempts;
            } else if (message
                .toLowerCase()
                .contains('email sending limit exceeded')) {
              msg = LocalizationHandler.of().emailSendExceeded;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;
          case ApiErrorCodes.abdm_1100:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message
                .toLowerCase()
                .contains('you have requested multiple otps')) {
              msg = LocalizationHandler.of().exceedMaxAttempts;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;
          case ApiErrorCodes.abdm_1019:
            String msg = LocalizationHandler.of().somethingWrong;
            if (message
                .toLowerCase()
                .contains('dependent service unavailable')) {
              msg = LocalizationHandler.of().backendServiceUnavailableMessage;
            }
            MessageBar.showToastDialog(
              msg,
            );
            break;

          default:
            MessageBar.showToastDialog(
              LocalizationHandler.of().somethingWrong,
            );
            break;
        }
      }
    } catch (e) {
      MessageBar.showToastDialog(LocalizationHandler.of().somethingWrong);
    }
  }

  /// @Here function used to set the boolean false in Shared preference in [_isLogin]
  /// parameter. This is to be done because of session expire in case of invalid token.

  void _onSessionExpired() {
    // CustomDialog.dismissDialog();
    abhaSingleton.getSharedPref
        .get(SharedPref.apiRHeaderToken, defaultValue: '')
        .then((rToken) {
      abhaSingleton.getApiProvider.setHeaderToken(rToken: rToken);
      functionHandler(
        isLoaderReq: true,
        function: () async {
          await Get.find<DashboardController>().getXToken();
          await Get.find<DashboardController>()
              .getXAuthToken(Get.find<ProfileController>().profileModel);
        },
      );
    });
  }
}
