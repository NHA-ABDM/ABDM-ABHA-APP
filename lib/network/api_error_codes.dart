class ApiErrorCodes {
  static const int defaultCode = 0;
  static const int noInternetConnection = 100;
  static const int badResponse = 110;
  static const int consentNotFound = 120;
  static const int invalidToken = 1401;
  static const int noPatient = 1404;
  static const int invalidOTP = 1405;
  static const int otpRequestLimitExceed = 1407;
  static const int sameRequestID = 1412;
  static const int noAccountFound = 1414;
  static const int noConsentRequestFound = 1415;
  static const int invalidRequestAbhaAddress = 1417;
  static const int maximumLoginAttempt = 1423;
  static const int invalidTransactionPin = 1424;
  static const int invalidTransactionPin_1 = 1425;
  static const int abhaAddressAlreadyExist = 1434;
  static const int invalidEmailAbhaNumber = 1437;
  static const int passwordMustBeDifferent = 1440;
  static const int didNotFoundUser = 1500;
  static const int nameCharacterTooLong = 1502;
  static const int didNotResultGateway = 1504;
  static const int didNotFoundProvider = 1505;
  static const int invalidRequest1510 = 1510;
  static const int unexpectedError = 1511;
  static const int requesterNotAuthorized = 4401;
  static const int failedToFetchConsentReq = 4500;
  static const int invalidAuthorizationRequest = 1453;

  /// V3 APIs error codes
  static const String notificationServiceUnavailable = 'ABDM-1034';
  static const String abdm_9999 = 'ABDM-9999:';
  static const String abdm_9999_space = 'ABDM-9999: ';
  static const String verificationPending = 'ABDM-1214';
  static const String unknownException = 'UNKNOWN_EXCEPTION';
  static const String abdm_1209 = 'ABDM-1209';
  static const String abdm_1006 = 'ABDM-1006';
  static const String abdm_1211 = 'ABDM-1211';
  static const String abdm_1016 = 'ABDM-1016:';
  static const String abdm_1024 = 'ABDM-1024:';
  static const String badRequest = 'BAD_REQUEST';
  static const String abdm_1100 = 'ABDM-1100';
  static const String abdm_1019 = 'ABDM-1019:';
  static const String abdm_1006_colon = 'ABDM-1006:';
  static const String abdm_1006_colon_space = 'ABDM-1006: ';
  static const String abdm_1092_colon = 'ABDM-1092:';
}
