import 'package:abha/app/app_intro/model/login_option_model.dart';
import 'package:abha/app/profile/model/profile_abha_model.dart';
import 'package:abha/app/registration/model/enroll_abha_request_model.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/service/lgd_service.dart';

enum RegistrationMethod {
  mobile,
  email,
  verifyAadhaar,
  verifyMobile,
}

enum UpdateAddressSelectUiBuilderIds {
  addressSelect,
  updateLoginButton,
}

enum RegistrationUpdateUiBuilderIds {
  abhaNumberValidator,
}

class RegistrationController extends BaseController {
  late LGDService lgdService;

  AppTextController mobileTexController =
      AppTextController(inputFormatters: Validator.numberFormatter());
  AppTextController emailTextController =
      AppTextController(inputFormatters: Validator.withoutSpace());
  AppTextController abhaNumberTextController =
      AppTextController(mask: StringConstants.abhaNumberFormatValue);
  TextEditingController otpTextController = TextEditingController();

  // bool isSubmitButtonEnable = false;

  ValueNotifier<bool> showLoader = ValueNotifier(false);

  // final String _abhaNumber = StringConstants.abhaNumber;
  // final String _mobile = StringConstants.mobile;
  final String _email = StringConstants.email;
  final String _aadhaar = StringConstants.aadhaar;
  final int _otpTime = 60;
  late int otpCountDown;
  late bool isResendOtpEnabled;
  String? authMode;
  String? sessionId;
  String? txnId;
  late RegistrationRepo registrationRepo;
  RegistrationMethod? registrationMethod;
  final ApiProvider _apiProvider = abhaSingleton.getApiProvider;
  var selectedDate = DateTime.now().obs;
  List<LoginOptionModel> registrationOptions = [];
  late Timer timer;
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();

  bool isAuthModeFetched = false;
  RegistrationMethod? selectedValidationMethod;

  final formKey = GlobalKey<FormState>();
  final abhaAddressTEC =
      AppTextController(inputFormatters: Validator.abhaAddressFormatter());
  final passwordTEC =
      AppTextController(inputFormatters: Validator.withoutSpace());
  final confirmPasswordTEC =
      AppTextController(inputFormatters: Validator.withoutSpace());
  List? suggestedAbhaAddress;
  bool? isAbhaAddressExist;
  bool showAbhaAddressAvailability = false;
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  ProfileModel? abhaAddressSelectedValue;

  /// Used to allow user to skip password while registering
  bool skipPassword = false;

  /// Model class to enroll the ABHA address using v3 apis
  late EnrollAbhaRequestModel enrollAbhaRequestModel;
  String? mobileNumberToRegister;
  String? emailAddressToRegister;

  AutovalidateMode autoValidateModeWeb = AutovalidateMode.disabled;

  RegistrationController(RegistrationRepoImpl repo)
      : super(RegistrationController) {
    registrationRepo = repo;
    enrollAbhaRequestModel = EnrollAbhaRequestModel();
    lgdService = LGDServiceImpl();
  }

  List<LoginOptionModel> initRegistrationOptions() {
    registrationOptions.clear();
    registrationOptions.add(
      LoginOptionModel(
        LocalizationHandler.of().mobileNumber,
        ImageLocalAssets.loginMobileNoIconSvg,
      ),
    );
    registrationOptions.add(
      LoginOptionModel(
        LocalizationHandler.of().abhaNumber,
        ImageLocalAssets.loginAbhaNoIconSvg,
      ),
    );
    registrationOptions.add(
      LoginOptionModel(
        LocalizationHandler.of().emailId,
        ImageLocalAssets.loginEmailIconSvg,
      ),
    );
    return registrationOptions;
  }

  Future<void> getResendOtp(String data) async {
    if (registrationMethod == RegistrationMethod.verifyAadhaar ||
        registrationMethod == RegistrationMethod.verifyMobile) {
      await getAbhaRequestOtp(data);
    } else if (registrationMethod == RegistrationMethod.mobile ||
        registrationMethod == RegistrationMethod.email) {
      await getMobileEmailAuthInit(data);
    }
  }

  Future<void> checkVerifyOtp(String otp, String fromScreen) async {
    if (fromScreen == 'registrationAbha') {
      await getAbhaVerifyOtp(otp);
    } else {
      await getMobileEmailVerifyOtp(otp);
    }
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
  }

  Future<void> getMobileEmailAuthInit(String mobileEmail) async {
    authMode = _email;
    tempResponseData = await registrationRepo
        .onMobileEmailGenerateOtp(await createGenerateOtpData(mobileEmail));
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
  }

  Future<void> getMobileEmailVerifyOtp(String otp) async {
    tempResponseData = await registrationRepo
        .onMobileEmailValidateOtp(await createAuthConfirmData(otp));
  }

  Future<void> getAbhaRequestOtp(String abhaNumber) async {
    authMode = _aadhaar;
    tempResponseData = await registrationRepo
        .onAbhaRequestOtp(await createGenerateOtpData(abhaNumber));
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
  }

  Future<void> getAbhaVerifyOtp(String otp) async {
    tempResponseData = await registrationRepo
        .onAbhaVerifyOtp(await createAuthConfirmData(otp));
  }

  Future<void> getSuggestedAbhaAddress() async {
    tempResponseData = await registrationRepo.onGetSuggestedAbhaAddress(
      enrollAbhaRequestModel.toSuggestedAbhaAddressJson(),
    );
  }

  Future<void> getIsAbhaAddressExist(String abhaAddress) async {
    tempResponseData = await registrationRepo.onIsAbhaExist(abhaAddress);
  }

  Future<void> getRegistrationAbhaFormSubmission(
    Map registrationAbhaFormData,
  ) async {
    if (!Validator.isNullOrEmpty(mobileNumberToRegister)) {
      tempResponseData =
          await _apiProvider.onEncryptData(mobileNumberToRegister!);
      enrollAbhaRequestModel.phrDetails!.mobile = tempResponseData;
    }
    if (!Validator.isNullOrEmpty(emailAddressToRegister)) {
      tempResponseData =
          await _apiProvider.onEncryptData(emailAddressToRegister!);
      enrollAbhaRequestModel.phrDetails!.email = tempResponseData;
    }
    if (!Validator.isNullOrEmpty(
      registrationAbhaFormData[ApiKeys.requestKeys.password],
    )) {
      tempResponseData = await _apiProvider.onEncryptData(
        registrationAbhaFormData[ApiKeys.requestKeys.password],
      );
      enrollAbhaRequestModel.phrDetails!.password = tempResponseData;
    }
    enrollAbhaRequestModel.phrDetails!.abhaAddress =
        registrationAbhaFormData[ApiKeys.responseKeys.phrAddress];

    tempResponseData = await registrationRepo
        .onRegistrationAbhaFormSubmission(enrollAbhaRequestModel.toJson());
  }

  Future<void> getLoginFromRegistrationAbha({
    String? registeredAbhaAddress,
  }) async {
    Map tempData = {};
    tempData[ApiKeys.requestKeys.abhaAddress] =
        registeredAbhaAddress ?? abhaAddressSelectedValue?.abhaAddress ?? '';
    tempData[ApiKeys.requestKeys.txnId] = txnId ?? '';
    tempResponseData =
        await registrationRepo.onLoginFromRegistrationAbha(tempData);
    _apiProvider.addXHeaderToken(tempResponseData);
  }

  Future<Map> createGenerateOtpData(String mobileEmailData) async {
    Options options = Options();
    if (registrationMethod == RegistrationMethod.verifyAadhaar
        || registrationMethod == RegistrationMethod.verifyMobile){
      options =  Options(headers: {ApiKeys.requestKeys.keyType: StringConstants.abha});
    }
    tempResponseData = await _apiProvider.onEncryptData(mobileEmailData, options: options);

    Map<String, dynamic> authInitData = {
      ApiKeys.requestKeys.otpSystem: ApiKeys.requestValues.otpSystemAbdm,
    };
    if (registrationMethod == RegistrationMethod.verifyAadhaar) {
      authInitData[ApiKeys.requestKeys.otpSystem] =
          ApiKeys.requestValues.otpSystemAadhaar;
      authInitData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaLogin,
          ApiKeys.requestValues.scopeAadhaarVerify
        ],
        ApiKeys.requestKeys.loginHint:
            ApiKeys.requestValues.loginHintAbhaNumber,
        ApiKeys.requestKeys.loginId: tempResponseData,
      });
    } else if (registrationMethod == RegistrationMethod.verifyMobile) {
      authInitData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaLogin,
          ApiKeys.requestValues.scopeMobileVerify
        ],
        ApiKeys.requestKeys.loginHint:
            ApiKeys.requestValues.loginHintAbhaNumber,
        ApiKeys.requestKeys.loginId: tempResponseData,
      });
    } else if (registrationMethod == RegistrationMethod.mobile) {
      authInitData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaAddressEnroll,
          ApiKeys.requestValues.scopeMobileVerify
        ],
        ApiKeys.requestKeys.loginHint:
            ApiKeys.requestValues.loginHintMobileNumber,
        ApiKeys.requestKeys.loginId: tempResponseData,
      });
    } else if (registrationMethod == RegistrationMethod.email) {
      authInitData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaAddressEnroll,
          ApiKeys.requestValues.scopeEmailVerify
        ],
        ApiKeys.requestKeys.loginHint: ApiKeys.requestValues.loginHintEmail,
        ApiKeys.requestKeys.loginId: tempResponseData,
      });
    } else {}

    return authInitData;
  }

  Future<Map> createAuthConfirmData(String otpConfirmData) async {
    Options options = Options();
    if (registrationMethod == RegistrationMethod.verifyAadhaar
        || registrationMethod == RegistrationMethod.verifyMobile){
      options =  Options(headers: {ApiKeys.requestKeys.keyType: StringConstants.abha});
    }
    tempResponseData = await _apiProvider.onEncryptData(otpConfirmData, options: options);
    Map<String, dynamic> authConfirmData = {
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [ApiKeys.requestValues.authMethodsOtp],
        ApiKeys.requestKeys.otp: {
          ApiKeys.requestKeys.txnId: txnId,
          ApiKeys.requestKeys.otpValue: tempResponseData
        }
      }
    };
    if (registrationMethod == RegistrationMethod.verifyAadhaar) {
      authConfirmData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaLogin,
          ApiKeys.requestValues.scopeAadhaarVerify
        ],
      });
    } else if (registrationMethod == RegistrationMethod.verifyMobile) {
      authConfirmData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaLogin,
          ApiKeys.requestValues.scopeMobileVerify
        ],
      });
    } else if (registrationMethod == RegistrationMethod.mobile) {
      authConfirmData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaAddressEnroll,
          ApiKeys.requestValues.scopeMobileVerify
        ],
      });
    } else if (registrationMethod == RegistrationMethod.email) {
      authConfirmData.addAll({
        ApiKeys.requestKeys.scope: [
          ApiKeys.requestValues.scopeAbhaAddressEnroll,
          ApiKeys.requestValues.scopeEmailVerify
        ],
      });
    }
    return authConfirmData;
  }

  Future<void> getStates({BuildContext? context}) async {
    tempResponseData = await lgdService.onGetStates();
  }

  Future<void> getDistricts(String stateCode, {BuildContext? context}) async {
    tempResponseData = await lgdService.onGetDistricts(stateCode);
  }

  Future<LGDDetails?> validatePinCode(
    String pinCode, {
    BuildContext? context,
  }) async {
    try {
      var response = await lgdService.validateLGDDetails(pinCode);
      return LGDDetails.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  Future<Map> authInitRequestData(String loginInitData) async {
    final authInitData = {
      ApiKeys.requestKeys.authMethod: authMode,
    };
    if (registrationMethod == RegistrationMethod.verifyAadhaar ||
        registrationMethod == RegistrationMethod.verifyMobile) {
      authInitData.addAll({
        ApiKeys.requestKeys.healthId: Validator.formatAbhaNumber(loginInitData),
      });
    } else {}

    return authInitData;
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

  void resetData() {
    emailTextController.text = '';
    mobileTexController.text = '';
    otpTextController.text = '';
    abhaNumberTextController.text = '';
    isAuthModeFetched = false;
    selectedValidationMethod = null;
    abhaAddressTEC.text == '';
    passwordTEC.text == '';
    confirmPasswordTEC.text == '';
    suggestedAbhaAddress = [];
    isAbhaAddressExist = null;
    showAbhaAddressAvailability = false;
    passwordVisible = false;
    confirmPasswordVisible = false;
    abhaAddressSelectedValue = null;
    mobileNumberToRegister = null;
    emailAddressToRegister = null;
  }

  void saveFormDetails(Map<dynamic, dynamic> formObject) {
    /// We are saving non encrypted mobile number and email address
    mobileNumberToRegister = formObject['mobile'];
    emailAddressToRegister = formObject['email'];

    enrollAbhaRequestModel.txnId = txnId;
    PhrDetails phrDetails = PhrDetails();
    phrDetails.firstName = formObject['name']['first'];
    phrDetails.middleName = formObject['name']['middle'];
    phrDetails.lastName = formObject['name']['last'];
    phrDetails.dayOfBirth = formObject['dateOfBirth']['date'];
    phrDetails.monthOfBirth = formObject['dateOfBirth']['month'];
    phrDetails.yearOfBirth = formObject['dateOfBirth']['year'];
    phrDetails.gender = formObject['gender'];
    phrDetails.email = formObject['email'];
    phrDetails.mobile = formObject['mobile'];
    phrDetails.address = formObject['address'];
    phrDetails.stateName = formObject['stateName'];
    phrDetails.stateCode = formObject['stateCode'].toString();
    phrDetails.districtName = formObject['districtName'];
    phrDetails.districtCode = formObject['districtCode'].toString();
    phrDetails.pinCode = formObject['pinCode'];
    enrollAbhaRequestModel.phrDetails = phrDetails;
  }

  void saveAbhaFormDetails(ProfileAbhaModel? abhaProfileModel) {
    enrollAbhaRequestModel.txnId = txnId;
    PhrDetails phrDetails = PhrDetails();
    Accounts? user = abhaProfileModel?.accounts?[0];

    /// We are saving non encrypted mobile number and email address
    mobileNumberToRegister = user?.mobile;
    emailAddressToRegister = user?.email;

    phrDetails.firstName = user?.firstName;
    phrDetails.middleName = user?.middleName;
    phrDetails.lastName = user?.lastName;
    phrDetails.dayOfBirth = user?.dayOfBirth;
    phrDetails.monthOfBirth = user?.monthOfBirth;
    phrDetails.yearOfBirth = user?.yearOfBirth;
    phrDetails.gender = user?.gender;
    phrDetails.email = user?.email;
    phrDetails.mobile = user?.mobile;
    phrDetails.address = user?.address;
    phrDetails.stateName = user?.stateName;
    phrDetails.stateCode = user?.stateCode;
    phrDetails.districtName = user?.districtName;
    phrDetails.districtCode = user?.districtCode;
    phrDetails.pinCode = user?.pincode;
    enrollAbhaRequestModel.phrDetails = phrDetails;
  }

  void forgetAbhaNumberViaWebUrl(BuildContext context) {
    Map configData = abhaSingleton.getAppConfig.getConfigData();
    LaunchURLServiceImpl().openInAppWebView(
      context,
      title: configData[AppConfig.appName],
      url: '${configData[AppConfig.abhaUrl]}${ApiPath.forgetAbhaUrl}',
    );
  }
}
