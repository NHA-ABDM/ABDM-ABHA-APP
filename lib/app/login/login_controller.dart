import 'package:abha/app/app_intro/model/login_option_model.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

enum LoginMethod {
  address,
  mobile,
  email,
  abhaAddressSelection,
  verifyAadhaar,
  verifyMobile,
  verifyEmail,
  verifyAbhaMobileOtp,
}

enum LoginUpdateUiBuilderIds {
  abhaNumberBirthYears,
  abhaNumberValidator,
  updateLoginButton,
  abhaAddressPassword,
  loginMethodToggle,
  radioToggle,
}

enum ABHAAddressLoginOption { password, otp }

enum ABHAValidationMethod {
  password,
  otp,
}

class LoginController extends BaseController {
  String? selectedBirthYear;
  late String abhaNumberValue;
  List<String> birthYears = [];

  // bool isAuthModeFetched = false;
  final LaunchURLService launchURLService = LaunchURLServiceImpl();
  bool isShowEnable = false;
  final abhaNumberTEC =
      AppTextController(mask: StringConstants.abhaNumberFormatValue);
  late List<String> textAadhaarMobileOtpType;
  late List<String> iconsAadhaarMobileOtpType;
  late LoginRepo _loginRepo;
  late int otpCountDown;
  late bool isResendOtpEnabled;
  late Timer otpTimer;

  final ApiProvider _apiProvider = abhaSingleton.getApiProvider;
  final int _otpTime = 60;
  final loginFormKey = GlobalKey<FormState>();
  bool obscurePassword = true;
  List<LoginOptionModel> loginOptions = [];
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  LoginMethod loginMethod = LoginMethod.mobile;

  LoginMethod? selectedValidationMethod;
  String? abhaAddressSelectedValue;
  String? txnId;
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();
  AppTextController mobileTextController =
      AppTextController(inputFormatters: Validator.numberFormatter());
  AppTextController emailTextController =
      AppTextController(inputFormatters: Validator.withoutSpace());
  TextEditingController otpTextController = TextEditingController();
  AppTextController abhaAddressTEC = AppTextController();
  AppTextController abhaPasswordTEC =
      AppTextController(inputFormatters: Validator.withoutSpace());

  ABHAValidationMethod selectedABHAValidationMethod =
      ABHAValidationMethod.password;

  AutovalidateMode webAutoValidateMode = AutovalidateMode.disabled;

  LoginController(LoginRepoImpl repo) : super(LoginController) {
    _loginRepo = repo;
  }

  List<LoginOptionModel> initLoginOptions() {
    loginOptions.clear();
    loginOptions.add(
      LoginOptionModel(
        LocalizationHandler.of().mobileNumber,
        ImageLocalAssets.loginMobileNoIconSvg,
      ),
    );
    loginOptions.add(
      LoginOptionModel(
        LocalizationHandler.of().abhaAddress,
        ImageLocalAssets.loginAbhaAddressIconSvg,
      ),
    );

    loginOptions.add(
      LoginOptionModel(
        LocalizationHandler.of().abhaNumber,
        ImageLocalAssets.loginAbhaNoIconSvg,
      ),
    );
    if (kIsWeb) {
      loginOptions.add(
        LoginOptionModel(
          LocalizationHandler.of().emailId,
          ImageLocalAssets.loginEmailIconSvg,
        ),
      );
    }
    return loginOptions;
  }

  /// @Here function calls api to authenticate with
  /// abha Address and password. Params used :
  ///     [abhaAddress] of type String.
  ///     [abhaPassword] of type String.
  Future<void> getAbhaAddressAuthInit(
    String abhaAddress,
    String abhaPassword,
  ) async {
    Map<String, dynamic> searchAbhaAddressRequestData = {
      ApiKeys.requestKeys.abhaAddress: abhaAddress,
    };
    tempResponseData =
        await _loginRepo.onSearchAbhaAddress(searchAbhaAddressRequestData);
    await getVerify(abhaPassword, abhaAddress: abhaAddress);
  }

  Future<void> getGenerateOtp(String data) async {
    // _authMode =  loginMethod == LoginMethod.verifyEmail || loginMethod == LoginMethod.email
    //     ? _email
    //     : loginMethod == LoginMethod.verifyAadhaar
    //     ? _aadhaar
    //     : _mobile;
    tempResponseData =
        await _loginRepo.onOtpGenerate(await authInitRequestData(data));
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
  }

  Future<void> getVerify(String data, {String? abhaAddress}) async {
    // loginMethod = LoginMethod.verifyOtp;
    tempResponseData = await _loginRepo.onVerifyData(
      await authVerifyRequestData(data, abhaAddress: abhaAddress),
    );
    if (loginMethod == LoginMethod.address) {
      _apiProvider.addXHeaderToken(tempResponseData);
    } else {
      txnId = tempResponseData[ApiKeys.responseKeys.txnId];
    }
  }

  /// @Here function calls api to mobile or Email or
  /// Abha number authentication confirmation. Params used:-
  ///   [abhaAddress] of type String.
  Future<void> getUserVerify(String abhaAddress) async {
    Map verifyAbhaAddressUserData = {
      ApiKeys.requestKeys.abhaAddress: abhaAddress,
      ApiKeys.requestKeys.txnId: txnId ?? ''
    };
    tempResponseData = await _loginRepo.onVerifyUser(verifyAbhaAddressUserData);
    // _apiProvider.updateApiDetails(tempResponseData);
    _apiProvider.addXHeaderToken(tempResponseData);
  }

  ///    [loginInitData] of type String.
  ///    returns the variable [authInitData].
  Future<Map> authInitRequestData(String loginInitData) async {
    Options options = Options();
    if (loginMethod == LoginMethod.verifyAadhaar ||
        loginMethod == LoginMethod.verifyAbhaMobileOtp) {
      options =
          Options(headers: {ApiKeys.requestKeys.keyType: StringConstants.abha});
    }
    tempResponseData =
        await _apiProvider.onEncryptData(loginInitData, options: options);
    Map<String, dynamic> authInitData = {
      ApiKeys.requestKeys.otpSystem: loginMethod == LoginMethod.verifyAadhaar
          ? ApiKeys.requestValues.otpSystemAadhaar
          : ApiKeys.requestValues.otpSystemAbdm,
    };
    authInitData.addAll({
      ApiKeys.requestKeys.scope: [
        if (loginMethod == LoginMethod.verifyAadhaar ||
            loginMethod == LoginMethod.verifyAbhaMobileOtp)
          ApiKeys.requestValues.scopeAbhaLogin
        else
          ApiKeys.requestValues.scopeAbhaAddressLogin,
        if (loginMethod == LoginMethod.mobile ||
            loginMethod == LoginMethod.verifyMobile ||
            loginMethod == LoginMethod.verifyAbhaMobileOtp)
          ApiKeys.requestValues.scopeMobileVerify
        else
          loginMethod == LoginMethod.email ||
                  loginMethod == LoginMethod.verifyEmail
              ? ApiKeys.requestValues.scopeEmailVerify
              : loginMethod == LoginMethod.verifyAadhaar
                  ? ApiKeys.requestValues.scopeAadhaarVerify
                  : ''
      ],
      ApiKeys.requestKeys.loginHint: loginMethod == LoginMethod.mobile
          ? ApiKeys.requestValues.loginHintMobileNumber
          : loginMethod == LoginMethod.email
              ? ApiKeys.requestValues.loginHintEmail
              : loginMethod == LoginMethod.verifyMobile ||
                      loginMethod == LoginMethod.verifyEmail
                  ? ApiKeys.requestValues.loginHintAbhaAddress
                  : loginMethod == LoginMethod.verifyAbhaMobileOtp ||
                          loginMethod == LoginMethod.verifyAadhaar
                      ? ApiKeys.requestValues.loginHintAbhaNumber
                      : '',
      ApiKeys.requestKeys.loginId: tempResponseData,
    });

    return authInitData;
  }

  Future<Map> authVerifyRequestData(
    String encryptData, {
    String? abhaAddress,
  }) async {
    Options options = Options();
    if (loginMethod == LoginMethod.verifyAadhaar ||
        loginMethod == LoginMethod.verifyAbhaMobileOtp) {
      options =
          Options(headers: {ApiKeys.requestKeys.keyType: StringConstants.abha});
    }
    tempResponseData =
        await _apiProvider.onEncryptData(encryptData, options: options);

    Map<String, dynamic> authVerifyData = {};
    if (loginMethod == LoginMethod.address) {
      authVerifyData = _abhaPassVerifyRequestData(abhaAddress);
    } else {
      authVerifyData = {
        ApiKeys.requestKeys.authData: {
          ApiKeys.requestKeys.authMethods: [
            ApiKeys.requestValues.authMethodsOtp
          ],
          ApiKeys.requestKeys.otp: {
            ApiKeys.requestKeys.txnId: txnId,
            ApiKeys.requestKeys.otpValue: tempResponseData
          },
        },
      };
      if (loginMethod == LoginMethod.abhaAddressSelection) {
        authVerifyData.addAll({ApiKeys.requestKeys.patientId: encryptData});
      } else {
        authVerifyData.addAll({
          ApiKeys.requestKeys.scope: [
            if (loginMethod == LoginMethod.verifyAbhaMobileOtp ||
                loginMethod == LoginMethod.verifyAadhaar)
              ApiKeys.requestValues.scopeAbhaLogin
            else
              ApiKeys.requestValues.scopeAbhaAddressLogin,
            if (loginMethod == LoginMethod.mobile ||
                loginMethod == LoginMethod.verifyMobile ||
                loginMethod == LoginMethod.verifyAbhaMobileOtp)
              ApiKeys.requestValues.scopeMobileVerify
            else
              loginMethod == LoginMethod.email ||
                      loginMethod == LoginMethod.verifyEmail
                  ? ApiKeys.requestValues.scopeEmailVerify
                  : loginMethod == LoginMethod.verifyAadhaar
                      ? ApiKeys.requestValues.scopeAadhaarVerify
                      : ''
          ],
        });
      }
    }

    return authVerifyData;
  }

  Map<String, dynamic> _abhaPassVerifyRequestData(String? abhaAddress) {
    Map<String, dynamic> authVerifyData = {
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaAddressLogin,
        ApiKeys.requestValues.scopePasswordVerify
      ],
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [
          ApiKeys.requestValues.authMethodsPassword
        ],
        ApiKeys.requestKeys.password: {
          ApiKeys.requestKeys.abhaAddress: abhaAddress,
          ApiKeys.requestKeys.password: tempResponseData
        },
      },
    };
    return authVerifyData;
  }

  /// @Here function provides the user name saved to shared preference.
  Future<String> getUserName() async {
    String userName = await abhaSingleton.getSharedPref
        .get(SharedPref.userName, defaultValue: '');
    return userName;
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

  /// @Here method returns the list of years.
  List<String> getBirthYears() {
    List<String> birthYearsList = [];
    int startYear = 1900;
    int currentYear = DateTime.now().year - startYear;
    for (int i = currentYear; i >= 0; i--) {
      int year = startYear + i;
      birthYearsList.add(year.toString());
    }
    return birthYearsList;
  }

  void resetData() {
    mobileTextController.text = '';
    abhaAddressTEC.text = '';
    abhaPasswordTEC.text = '';
    selectedValidationMethod = null;
    emailTextController.text = '';
    otpTextController.text = '';
    obscurePassword = true;
    autoValidateMode = AutovalidateMode.disabled;
    abhaAddressSelectedValue = null;
    selectedBirthYear = null;
    abhaNumberValue = '';
    birthYears = [];
    isShowEnable = false;
  }
}
