import 'package:abha/app/abha_number/model/abha_number_user_detail_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/utils/global/global_key.dart';
import 'package:flutter/foundation.dart';

enum AbhaNumberOptionEnum { otpVerifyAadhaar, faceAuth, updateNextButton }

enum AbhaNumberForgotOptionEnum { aadhaarNumber, mobileNumber }

class AbhaNumberController extends BaseController {
  late AbhaNumberRepo _abhaNumberRepo;
  String txnId = '';
  final FileService _fileService = FileServiceImpl();
  String aadhaarNumber = '';
  String mobileNumber = '';
  String pid = '';
  // late String _authToken;
  final FlutterTts _flutterTts = FlutterTts();

  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  final aadhaarNumberTextController =
      AppTextController(mask: StringConstants.aadhaarNumberFormatValue);

  final mobileNumberTextController = AppTextController();

  final TextEditingController otpTextController = TextEditingController();

  final StreamController<ErrorAnimationType> otpErrorController =
      StreamController<ErrorAnimationType>.broadcast();

  AbhaNumberOptionEnum? abhaVerificationOptionValue =
      AbhaNumberOptionEnum.otpVerifyAadhaar;

  AbhaNumberForgotOptionEnum? abhaNumberForgotOptionEnum =
      AbhaNumberForgotOptionEnum.aadhaarNumber;

  final mobileTextController = AppTextController(
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],
  );
  ValueNotifier<bool> isButtonEnable = ValueNotifier(false);
  bool aadhaarDecelerationCheckBox = false;
  AbhaNumberUserDetailModel? abhaNumberUserDetailModel;
  List<Account>? accounts;
  late int otpCountDown;
  late bool isResendOtpEnabled;
  late Timer otpTimer;
  final int _otpTime = 60;
  List<int> abhaCardImageList = [];

  bool isAudioPlaying = false;

  AbhaNumberController(AbhaNumberRepoImpl repo) : super(AbhaNumberController) {
    _abhaNumberRepo = repo;
  }

  /// This method is used to generate OTP for Aadhaar authentication.
  ///
  /// @param aadhaarNumber The Aadhaar number of the user.
  ///
  /// @return Future<void> Returns a [Future] object which resolves to void. It also sets the [txnId] variable with the transaction id received from the server.
  Future<void> genAbhaNumberCreateOtp() async {
    Map<String, dynamic> authConfirmData = {
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaEnroll,
      ],
      ApiKeys.requestKeys.txnId: '',
      ApiKeys.requestKeys.loginHint: ApiKeys.requestKeys.aadhaar,
      ApiKeys.requestKeys.loginId: await apiProvider.onEncryptData(
        aadhaarNumber,
        options: Options(
          headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
        ),
      ),
      ApiKeys.requestKeys.otpSystem: ApiKeys.requestValues.otpSystemAadhaar,
    };
    tempResponseData = await _abhaNumberRepo.onGenerateOtp(authConfirmData);
    txnId = tempResponseData[ApiKeys.responseKeys.txnId] ?? '';
  }

  /// This method is used to verify the OTP sent to the user.
  ///
  /// @param otp The OTP sent to the user.
  /// @returns A [Future] that completes when the OTP has been verified.
  Future<void> verifyOtp(String otp) async {
    Map authConfirmData = {
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [ApiKeys.requestValues.authMethodsOtp],
        ApiKeys.requestKeys.otp: {
          ApiKeys.requestKeys.timeStamp:
              DateTime.now().toIso8601String().formatYYYYMMMddHHMMMSS,
          ApiKeys.requestKeys.txnId: txnId,
          ApiKeys.requestKeys.otpValue: await apiProvider.onEncryptData(
            otp,
            options: Options(
              headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
            ),
          ),
          ApiKeys.requestKeys.mobile: mobileNumber
        },
      },
      ApiKeys.requestKeys.consent: {
        ApiKeys.requestKeys.code: ApiKeys.requestValues.scopeAbhaEnrollment,
        ApiKeys.requestKeys.version: '1.4'
      },
    };
    tempResponseData = await _abhaNumberRepo.onVerifyOtp(authConfirmData);
  }

  Future<void> getAbhaCard() async {
    if (!Validator.isNullOrEmpty(tempResponseData)) {
      tempResponseData =
          await _abhaNumberRepo.onaAbhaNumberCard(tempResponseData, '');
      abhaCardImageList = tempResponseData;
    }
  }

  Future<void> getCardByFaceAuth() async {
    Map authConfirmData = {
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [ApiKeys.requestKeys.face],
        ApiKeys.requestKeys.face: {
          ApiKeys.requestKeys.timeStamp:
              DateTime.now().toIso8601String().formatYYYYMMMddHHMMMSS,
          ApiKeys.requestKeys.mobile: mobileNumber,
          ApiKeys.requestKeys.aadhaar: await apiProvider.onEncryptData(
            aadhaarNumber,
            options: Options(
              headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
            ),
          ),
          ApiKeys.requestKeys.rdPidData:
              pid //await apiProvider.onEncryptData(pid)
        },
      },
      ApiKeys.requestKeys.consent: {
        ApiKeys.requestKeys.code: ApiKeys.requestValues.scopeAbhaEnrollment,
        ApiKeys.requestKeys.version: '1.4'
      },
    };
    tempResponseData = await _abhaNumberRepo.onVerifyFaceAuth(authConfirmData);
    // apiProvider.setHeaderToken(
    //   authToken: _authToken,
    //   //tempResponseData[ApiKeys.responseKeys.tokens][ApiKeys.responseKeys.token],
    // );
  }

  // Future<void> getFaceAuth(String pid) async {
  //   tempResponseData = await _abhaNumberRepo
  //       .onaAbhaNumberFaceAuth(_createFaceAuthReqData(pid));
  //   txnId = tempResponseData[ApiKeys.responseKeys.txnId] ?? '';
  // }

  //------------------ Forget Abha Number Api Functions ----------------//

  /// @Here function calls the api to get session of the app
  // Future<void> getSession() async {
  //   tempResponseData = await _abhaNumberRepo.onSession(sessionRequestData());
  //   _authToken = tempResponseData[ApiKeys.responseKeys.accessToken];
  //   apiProvider.addAHeaderToken(tempResponseData);
  // }
  //
  // Map sessionRequestData() {
  //   final Map appConfigData = abhaSingleton.getAppConfig.getConfigData();
  //   var sessionData = {
  //     ApiKeys.requestKeys.clientId: appConfigData[AppConfig.clientId],
  //     ApiKeys.requestKeys.clientSecret: appConfigData[AppConfig.clientSecret],
  //     ApiKeys.requestKeys.grantType: appConfigData[AppConfig.grantType],
  //   };
  //   return sessionData;
  // }

  // This function used to call api for Create ABHA Number and Forget ABHA Number.
  /// This method is used to generate OTP for Aadhaar authentication.
  ///
  /// @param aadhaarNumber The Aadhaar number of the user.
  ///
  /// @return Future<void> Returns a [Future] object which resolves to void.
  /// It also sets the [txnId] variable with the transaction id received from the server.
  Future<void> generateOtpViaAadhaar() async {
    Map<String, dynamic> authConfirmData = {
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaLogin,
        ApiKeys.requestValues.scopeAadhaarVerify
      ],
      ApiKeys.requestKeys.loginHint: ApiKeys.requestKeys.aadhaar,
      ApiKeys.requestKeys.loginId: await apiProvider.onEncryptData(
        aadhaarNumber,
        options: Options(
          headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
        ),
      ),
      ApiKeys.requestKeys.otpSystem: ApiKeys.requestValues.otpSystemAadhaar,
    };
    tempResponseData =
        await _abhaNumberRepo.onGenerateOtpViaAadhaarOrMobile(authConfirmData);
    txnId = tempResponseData[ApiKeys.responseKeys.txnId] ?? '';
  }

  /// This method is used to generate OTP for Mobile authentication.
  ///
  /// @param mobileNumber The Mobile number of the user.
  ///
  /// @return Future<void> Returns a [Future] object which resolves to void.
  /// It also sets the [txnId] variable with the transaction id received from the server.
  Future<void> generateOtpViaMobile() async {
    Map<String, dynamic> authConfirmData = {
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaLogin,
        ApiKeys.requestValues.scopeMobileVerify
      ],
      ApiKeys.requestKeys.loginHint: ApiKeys.requestKeys.mobile,
      ApiKeys.requestKeys.loginId: await apiProvider.onEncryptData(
        mobileNumber,
        options: Options(
          headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
        ),
      ),
      ApiKeys.requestKeys.otpSystem: ApiKeys.requestValues.otpSystemAbdm,
    };
    tempResponseData =
        await _abhaNumberRepo.onGenerateOtpViaAadhaarOrMobile(authConfirmData);
    txnId = tempResponseData[ApiKeys.responseKeys.txnId] ?? '';
  }

  /// This method is used to verify the OTP sent to the user.
  ///
  /// @param otp The OTP sent to the user.
  /// @returns A [Future] that completes when the OTP has been verified.
  Future<void> verifyAadhaarOrMobileOtp(String otp, String authType) async {
    tempResponseData = await _abhaNumberRepo.onOtpVerify(
      await authInitV3RequestData(otp, authType),
    );
    String tempData = jsonEncode(tempResponseData);
    abhaNumberUserDetailModel = userAbhaNumbeDetailModelFromMap(tempData);
    accounts = abhaNumberUserDetailModel?.accounts;
  }

  /// This method is used to get Request data.
  ///
  /// @param otp, The OTP sent to the user.
  /// @param authType, Either for Aadhaar or Mobile.
  /// @returns A [Future] that completes requested data.
  Future<Map> authInitV3RequestData(String otp, String authType) async {
    Map authConfirmData = {
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [ApiKeys.requestValues.authMethodsOtp],
        ApiKeys.requestKeys.otp: {
          ApiKeys.requestKeys.txnId: txnId,
          ApiKeys.requestKeys.otpValue: await apiProvider.onEncryptData(
            otp,
            options: Options(
              headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
            ),
          )
        },
      },
    };
    if (authType == AbhaNumberForgotOptionEnum.aadhaarNumber.name) {
      authConfirmData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaLogin,
          ApiKeys.requestValues.scopeAadhaarVerify
        ],
      });
    } else {
      authConfirmData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaLogin,
          ApiKeys.requestValues.scopeMobileVerify
        ],
      });
    }
    return authConfirmData;
  }

  // Map _createFaceAuthReqData(String pid) {
  //   var str2 = pid.replaceAll('fCount=\"0\"', 'fCount=\"1\"');
  //   Codec<String, String> stringToBase64 = utf8.fuse(base64);
  //   String pidDataEncoded = stringToBase64.encode(str2);
  //   var data = {
  //     'bioType': 'FID',
  //     'aadhaar': aadhaarNumber,
  //     'pid': pidDataEncoded
  //   };
  //   return data;
  // }

  Future<void> downloadFile(var data) async {
    try {
      Uint8List bytes = Uint8List.fromList(data);
      await _fileService.writeToStorage(
        fileName: generateFileName(),
        data: bytes,
        directoryType: DirectoryType.download,
      );
      if (navKey.currentContext != null) {
        MessageBar.showToastSuccess(
          LocalizationHandler.of().file_download_success,
        );
      }
    } catch (e) {
      abhaLog.e(e.toString());
      if (navKey.currentContext != null) {
        MessageBar.showToastError(
          LocalizationHandler.of().file_download_failure,
        );
      }
    }
  }

  String generateFileName() {
    return kIsWeb ? 'abha_card_$txnId.svg' : 'abha_card_$txnId.png';
  }

  void showAppIsNotInstalledDialog() {
    CustomDialog.showPopupDialog(
      LocalizationHandler.of().faceRDNotInstalled,
      title: LocalizationHandler.of().alert,
      positiveButtonTitle: LocalizationHandler.of().yes,
      negativeButtonTitle: LocalizationHandler.of().no,
      onPositiveButtonPressed: () {
        CustomDialog.dismissDialog();
        _openPlayStoreToInstallApp();
      },
      onNegativeButtonPressed: CustomDialog.dismissDialog,
    );
  }

  Future<void> _openPlayStoreToInstallApp() async {
    final url = Uri.parse(
      'https://play.google.com/store/apps/details?id=in.gov.uidai.facerd',
    );
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void otpTimerInit() {
    otpCountDown = _otpTime;
    isResendOtpEnabled = false;
  }

  void otpTimerCountDown() {
    if (otpCountDown > 1) {
      otpCountDown--;
    } else {
      isResendOtpEnabled = true;
    }
  }

  Future<void> startSpeech(String textToSpeech) async {
    isAudioPlaying = true;
    String audioLang = abhaSingleton.getAppData.getLanguageAudioCode();
    await _flutterTts.setLanguage(audioLang);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.speak(textToSpeech);
    updateUiOnTtsCompletion();
  }

  void updateUiOnTtsCompletion() {
    // Update the UI on Tts Completion.
    _flutterTts.setCompletionHandler(() {
      isAudioPlaying = false;
      functionHandler(isUpdateUi: true);
    });
  }

  void stopSpeech() {
    isAudioPlaying = false;
    _flutterTts.stop();
  }
  //-------------------------- Unused Api functions ------------------------//
// /// Adds a mobile number to the user's account.
// ///
// /// This method takes in a [mobile] number and sends an OTP to that number.
// ///
// /// The [txnId] is used to identify the transaction.
// ///
// /// Returns a [Future] that completes when the request is successful.
// Future<void> addMobile(String mobile) async {
//   Map data = {
//     ApiKeys.requestKeys.mobile: mobile,
//     ApiKeys.requestKeys.txnId: txnId,
//   };
//   await _abhaNumberRepo.onAbhaNumberCheckAndGenerateMobileOTP(data);
// }

// /// Creates an Abha ID using the given [_mobileEmaildata].
// ///
// /// The [_mobileEmaildata] should contain the following keys:
// /// * `firstName`: The first name of the user.
// /// * `middleName`: The middle name of the user.
// /// * `lastName`: The last name of the user.
// /// * `password`: The password associated with the Abha ID.
// /// * `profilePhoto`: A profile photo for the Abha ID.
// /// * `healthId`: A health ID associated with the Abha ID.
// /// * `email`: An email associated with the Abha ID.
// /// * `txnId`: A transaction ID associated with the Abha ID.
// Future<void> createAbhaId() async {
//   Map data = {
//     ApiKeys.requestKeys.firstName: '',
//     ApiKeys.requestKeys.middleName: '',
//     ApiKeys.requestKeys.lastName: '',
//     ApiKeys.requestKeys.password: '',
//     ApiKeys.requestKeys.profilePhoto: '',
//     ApiKeys.requestKeys.healthId: '',
//     ApiKeys.requestKeys.email: '',
//     ApiKeys.requestKeys.txnId: txnId,
//   };
//   tempResponseData =
//       await _abhaNumberRepo.onAbhaNumberCreateHealthIdWithPreVerified(data);
// }
}
