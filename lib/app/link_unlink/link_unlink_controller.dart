import 'package:abha/export_packages.dart';

enum LinkUnlinkMethod { verifyAadhaar, verifyMobile }

enum LinkUnlinkUpdateUiBuilderIds {
  radioToggle,
}

class LinkUnlinkController extends BaseController {
  late LinkUnlinkRepo _linkUnlinkRepo;
  // final String _mobile = StringConstants.mobile;
  // final String _aadhaar = StringConstants.aadhaar;
  // final Map _appConfigData = abhaSingleton.getAppConfig.getConfigData();
  LinkUnlinkMethod linkUnlinkMethod = LinkUnlinkMethod.verifyMobile;
  // String? _authMode;
  String? actionType;
  // String? _transactionId;
  String? txnId;
  // final ApiProvider _apiProvider = abhaSingleton.getApiProvider;
  final int _otpTime = 60;
  late int otpCountDown;
  late bool isResendOtpEnabled;
  String selectedValidationMethod = StringConstants.yes;
  final abhaNumberTEC =
      AppTextController(mask: StringConstants.abhaNumberFormatValue);
  final TextEditingController textEditingController = TextEditingController();
  LinkUnlinkMethod? selectedRadioButton;
  String otpValue = '';
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>.broadcast();
  bool isSubmitEnable = false;

  LinkUnlinkController(LinkUnlinkRepoImpl repo) : super(LinkUnlinkController) {
    _linkUnlinkRepo = repo;
  }

  // Future<void> getAbhaNumberAuthSearch(
  //   String abhaNumber,
  //   String type,
  // ) async {
  //   actionType = type;
  //   var authSearchData = {
  //     ApiKeys.requestKeys.abhaNumber: abhaNumber,
  //   };
  //   tempResponseData = await _linkUnlinkRepo.onAbhaNumberAuthSearch(authSearchData);
  // }

  Future<void> getAbhaNumberAuthInit(String abhaNumber) async {
    // String authHeader = await abhaSingleton.getSharedPref.get(SharedPref.apiAuthHeaderToken, defaultValue: '');
    // _apiProvider.updateApiDetails(jsonDecode(authHeader));
    // _authMode = _mobile;
    // if (linkUnlinkMethod == LinkUnlinkMethod.verifyAadhaar) {
    //   _authMode = _aadhaar;
    // }
    tempResponseData = await _linkUnlinkRepo
        .onAbhaNumberAuthInit(await authInitRequestData(abhaNumber));
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
  }

  Future<void> getAbhaNumberOtpVerify(String otp) async {
    tempResponseData = await _linkUnlinkRepo
        .onAbhaNumberOtpVerify(await authConfirmRequestData(otp));
    // await getAbhaNumberLinkUnlink();
    /*if(actionType == StringConstants.link) {
      await getAbhaNumberLink();
    } else {
      await getAbhaNumberDeLink();
    }*/
  }

  // Future<void> getResendOtp() async {
  //   var resendOtpData = {
  //     ApiKeys.requestKeys.transactionId: _transactionId,
  //   };
  //   tempResponseData = await _linkUnlinkRepo.onResendOtp(resendOtpData);
  // }

  // Future<void> getAbhaNumberLinkUnlink() async {
  //   // String xAuthHeader = await abhaSingleton.getSharedPref.get(SharedPref.apiXAuthHeaderToken, defaultValue: '');
  //   // _apiProvider.updateApiDetails(jsonDecode(xAuthHeader));
  //   var linkUnlinkData = {
  //     ApiKeys.requestKeys.action: actionType,
  //     ApiKeys.requestKeys.transactionId: _transactionId
  //   };
  //   tempResponseData =
  //       await _linkUnlinkRepo.onAbhaNumberLinkUnlink(linkUnlinkData);
  // }

  Future<void> getAbhaNumberLinkDeLink() async {
    txnId = tempResponseData[ApiKeys.responseKeys.txnId];
    var data = {
      ApiKeys.requestKeys.action: actionType,
      ApiKeys.requestKeys.transactionId: txnId
    };
    tempResponseData = actionType == StringConstants.link
        ? await _linkUnlinkRepo.onAbhaNumberLink(data)
        : await _linkUnlinkRepo.onAbhaNumberDeLink(data);
  }

  // Future<void> getAbhaNumberDeLink() async {
  //   var deLinkData = {
  //     ApiKeys.requestKeys.action: actionType,
  //     ApiKeys.requestKeys.transactionId: txnId
  //   };
  //   tempResponseData =
  //       await _linkUnlinkRepo.onAbhaNumberDeLink(deLinkData);
  // }

  Future<Map> authInitRequestData(String loginInitData) async {
    tempResponseData = await abhaSingleton.getApiProvider.onEncryptData(
      loginInitData,
      options: Options(
        headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
      ),
    );
    Map<String, dynamic> authInitData = {
      ApiKeys.requestKeys.otpSystem:
          linkUnlinkMethod == LinkUnlinkMethod.verifyAadhaar
              ? ApiKeys.requestValues.otpSystemAadhaar
              : ApiKeys.requestValues.otpSystemAbdm,
    };
    authInitData.addAll({
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaLogin,
        if (linkUnlinkMethod == LinkUnlinkMethod.verifyMobile)
          ApiKeys.requestValues.scopeMobileVerify
        else
          linkUnlinkMethod == LinkUnlinkMethod.verifyAadhaar
              ? ApiKeys.requestValues.scopeAadhaarVerify
              : ''
      ],
      ApiKeys.requestKeys.loginHint: ApiKeys.requestValues.loginHintAbhaNumber,
      ApiKeys.requestKeys.loginId: tempResponseData,
    });
    return authInitData;
  }

  Future<Map> authConfirmRequestData(String loginConfirmData) async {
    tempResponseData = await abhaSingleton.getApiProvider.onEncryptData(
      loginConfirmData,
      options: Options(
        headers: {ApiKeys.requestKeys.keyType: StringConstants.abha},
      ),
    );
    Map<String, dynamic> authConfirmData = {
      ApiKeys.requestKeys.authData: {
        ApiKeys.requestKeys.authMethods: [ApiKeys.requestValues.authMethodsOtp],
        ApiKeys.requestKeys.otp: {
          ApiKeys.requestKeys.txnId: txnId,
          ApiKeys.requestKeys.otpValue: tempResponseData
        },
      },
      ApiKeys.requestKeys.scope: [
        ApiKeys.requestValues.scopeAbhaLogin,
        if (linkUnlinkMethod == LinkUnlinkMethod.verifyMobile)
          ApiKeys.requestValues.scopeMobileVerify
        else
          linkUnlinkMethod == LinkUnlinkMethod.verifyAadhaar
              ? ApiKeys.requestValues.scopeAadhaarVerify
              : ''
      ],
    };
    return authConfirmData;
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
}
