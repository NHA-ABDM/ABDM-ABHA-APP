import 'package:abha/utils/config/app_config.dart';
import 'package:abha/utils/singleton/abha_singleton.dart';

class ApiPath {
  static final String middlePhrUrl =
      abhaSingleton.getAppConfig.getConfigData()[AppConfig.middlePhrUrl];
  static final String middlePhiuUrl =
      abhaSingleton.getAppConfig.getConfigData()[AppConfig.middlePhiuUrl];

// ---------------------------- helper apis  -----------------------------------------------------
  static final String deviceToken =
      '${middlePhiuUrl}app-notification-token'; // POST
  static final String xAuthToken = '${middlePhiuUrl}idp/x-auth-token'; // POST
  static final String encryptDataApi =
      '${middlePhrUrl}enrollment/encrypt'; // GET
  static final String refreshApiHeaderToken =
      '${middlePhrUrl}login/profile/request/token'; // GET
  // static const String sessionApi = 'v0.5/sessions'; // POST
  static const String sessionApi = 'session'; // GET

// ------------------------------- consents apis--------------------------------------------------
  static final String consentRequestLinkHipApi = linkFacilityApi; // GET
  static String consentHipProvidersApi = hipProvidersApi; // GET
  static final String consentAutoApproveForHiuApi =
      '${middlePhiuUrl}consents/auto-approve'; // POST
  static final String consentRequestFetchApi =
      '${middlePhiuUrl}consent-requests'; // GET
  static final String consentRevokeFetchApi =
      '${middlePhiuUrl}consents/revoke'; // POST
  static final String consentRequests =
      '${middlePhiuUrl}consent-requests'; // GET

  static String consentApproveApi(String requestId) {
    return '$consentRequests/$requestId/approve'; // POST
  }

  static String consentArtefactsApi(String requestId) {
    return '$consentRequests/$requestId/consent-artefacts'; // GET
  }

  static String consentDenyApi(String requestId) {
    return '$consentRequests/$requestId/deny'; // POST
  }

// ------------------------------ create abha number apis-----------------------------------------
  static String abhaNumberCreateRequestOtp =
      '${middlePhrUrl}enrollment/abha/enrollment/request/otp'; // POST
  static String abhaNumberCreateVerifyOtp =
      '${middlePhrUrl}enrollment/abha/enrollment/enrol/byAadhaar'; // POST
  static String abhaNumberCard =
      '${middlePhrUrl}enrollment/abha/profile/account/abha-card'; // GET

  static const String abhaNumberCheckAndGenerateMobileOTP =
      'v2/registration/aadhaar/checkAndGenerateMobileOTP'; // POST
  static const String abhaNumberCreateHealthIdWithPreVerified =
      'v1/registration/aadhaar/createHealthIdWithPreVerified'; // POST
  static const String abhaNumberFaceAuth =
      'v1/registration/aadhaar/verifyBio'; // POST
  static const String abhaNumberFacility = 'facility/login'; // POST

// ------------------------------ Discovery and Linking apis--------------------------------------
  static String govtProgramsApi =
      '${middlePhiuUrl}providers/govt-programs'; // GET
  static String hipProvidersApi = '${middlePhiuUrl}providers'; // GET
  static const String discoverHipApi = '/topic/care-context/discover'; // GET
  static const String onDiscoverHipApi = '/topic/on-discover/request/'; // GET
  static const String linkHipApi = '/topic/links/link/init'; // GET
  static const String onLinkHipApi = '/topic/on-link-init/request/'; // GET
  static const String linkConfirmHipApi = '/topic/links/link/confirm'; // GET
  static const String onLinkConfirmHipApi =
      '/topic/on-link-confirm/request/'; // GET

//------------------------------ Forget ABHA number apis------------------------------
  static const String abhaNumberForgetRequestOtp =
      'phr/app/enrollment/abha/profile/login/request/otp'; // POST
  static const String abhaNumberForgetVerifyOtp =
      'phr/app/enrollment/abha/profile/login/verify'; // POST

//------------------------------ Forget and Create now Web Url-------------------------
  static const String forgetAbhaUrl = 'abha/v3/login/recover';
  static const String createAbhaUrl = 'abha/v3/register';

//------------------------------ Feedback apis-------------------------------------------------
  static String sendFeedbackApi = '${middlePhiuUrl}feedback'; //POST

// ----------------------------- Health records apis-------------------------------------------------
  static final String healthInformationLinkHipApi = linkFacilityApi; // GET
  static final String healthInformationConsentRequestApi =
      '${middlePhiuUrl}patient/consent-request'; // POST
  static final String healthInformationStatusApi =
      '${middlePhiuUrl}patient/health-information/status'; // POST
  static final String healthInformationFetchApi =
      '${middlePhiuUrl}patient/health-information/fetch'; // POST

// ------------------------------ Health Locker apis----------------------------
  static final String lockerLinkHipApi = linkFacilityApi; // GET
  static final String lockerConnectedListApi = '${middlePhiuUrl}health-lockers';
  static String lockerListApi =
      '${middlePhiuUrl}providers/health-lockers?limit=150&offset=0';
  static final String lockerIndividualInfoApi =
      '${middlePhiuUrl}patients/health-lockers/';
  static const String lockerToAdd = 'health-locker';

  // ---------NOT IN USE--------------------------------------------------------
  static const String lockerRequestApi = 'patients/locker-requests';
  // ---------NOT IN USE--------------------------------------------------------

  static final String lockerApproveEnableDisableApi =
      '${middlePhiuUrl}consents/auto-approval-policy';

  /// get Auto Approval enable or disable request
  static String lockerEnableApi(String requestId) {
    return '$lockerApproveEnableDisableApi/$requestId/enable';
  }

  static String lockerDisableApi(String requestId) {
    return '$lockerApproveEnableDisableApi/$requestId/disable';
  }

  static const String authorizationRequest = 'authorization-requests';
  // get Authorization request
  static String getAuthorizationRequest(String requestId) {
    return '$authorizationRequest/$requestId/authorization';
  }

  // get Revoked request
  static String getRevokedRequest(String requestId) {
    return '$authorizationRequest/$requestId/revoke';
  }

  static String subscriptionRequest = '${middlePhiuUrl}subscription-requests';
  // get Subscription request
  static String getSubscriptionRequest(String requestId) {
    return '$subscriptionRequest/$requestId';
  }

  static String getSubscriptionByRequestId(String requestId) {
    return '$subscriptionRequest/request/$requestId';
  }

  static String denySubscriptionRequest(String requestId) {
    return '$subscriptionRequest/$requestId/deny';
  }

  static String approveSubscriptionRequest(String requestId) {
    return '$subscriptionRequest/$requestId/approve';
  }

  static String updateSubscriptionDetail(String requestId) {
    return '${middlePhiuUrl}patients/subscription-requests/$requestId';
  }

// ------------------------------- Login apis--------------------------------------------------
  static final String otpGenApi = '${middlePhrUrl}login/request/otp'; // POST
  static final String verifyApi = '${middlePhrUrl}login/verify'; // POST
  static final String loginVerifyUserApi =
      '${middlePhrUrl}login/verify/user'; // POST
  static final String loginSearchAbhaAddressApi =
      '${middlePhrUrl}login/search'; // POST

// ------------------------------- Link-Unlink apis---------------------------------------------
  static final String linkApi = '${middlePhrUrl}login/profile/link'; // POST
  static final String deLinkApi = '${middlePhrUrl}login/profile/deLink'; // POST

//----------------------------------Link Facility apis----------------------------------------
  static final String linkFacilityApi =
      '${middlePhiuUrl}link/patient/links'; // GET

// ------------------------------- Notification apis----------------------------------------------
  static final String notificationsApi =
      '${middlePhiuUrl}get-notification'; // GET
  static final String notificationsReadApi =
      '${middlePhiuUrl}app-push-notification/all'; // POST

// ------------------------------- Profile apis--------------------------------------------------
  static final String profileMeApi = '${middlePhrUrl}login/profile'; // GET
  static final String profileQrCodeApi =
      '${middlePhrUrl}login/profile/qrCode'; // GET
  static final String profileAbhaCard =
      '${middlePhrUrl}login/profile/phrCard'; // GET
  static final String profileUpdatePasswordApi =
      '${middlePhrUrl}login/profile/verify'; // POST
  static final String profileEmailMobileOtpReq =
      '${middlePhrUrl}login/profile/request/otp'; // POST
  static final String profileEmailMobileOtpVerify =
      '${middlePhrUrl}login/profile/verify';
  static final String profileUpdate =
      '${middlePhrUrl}login/profile/updateProfile'; // POST
  static final String logout =
      '${middlePhrUrl}login/profile/request/logout'; // POST
  static final String switchProfile =
      '${middlePhrUrl}login/profile/switch-profile'; // GET
  static final String verifySwitchProfileUser =
      '${middlePhrUrl}login/profile/verify/switch-profile/user'; // POST

// ------------------------------- Registration apis--------------------------------------------------
  static final String mobileEmailGenerateOtpApi =
      '${middlePhrUrl}enrollment/request/otp'; // POST
  static final String mobileEmailValidateOtpApi =
      '${middlePhrUrl}enrollment/verify'; // POST
  static final String statesApi = '${middlePhrUrl}enrollment/lgd/state'; // GET
  static final String districtsApi =
      '${middlePhrUrl}enrollment/lgd/district'; // GET
  static final String validatePinCodeApi =
      '${middlePhrUrl}enrollment/lgd/search';
  static final String abhaAddressSuggestionApi =
      '${middlePhrUrl}enrollment/suggestion'; // POST
  static final String isAbhaExistsApi =
      '${middlePhrUrl}enrollment/isExists?abhaAddress'; // GET
  static final String enrollAbhaAddressApi =
      '${middlePhrUrl}enrollment/enrol'; // POST
  static final String abhaRequestOtpApi =
      '${middlePhrUrl}enrollment/request/otp'; // POST
  static final String abhaVerifyOtpApi =
      '${middlePhrUrl}enrollment/verify'; // POST

// ------------------------------- Share Patients Profile apis--------------------------------------------------
  static String shareProfileHipProvidersApi = hipProvidersApi; // GET
  static String hipTokenDetails =
      '${middlePhiuUrl}patient/getTokenDetails'; // GET
  static const String sharePatientsProfileApi =
      '/topic/patient-share/share'; // POST
  static const String onSharePatientsProfileApi =
      '/topic/patient-on-share/request/'; // POST
}
