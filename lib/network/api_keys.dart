class ApiKeys {
  static ErrorKeys errorKeys = const ErrorKeys();
  static HeadersKeys headersKeys = const HeadersKeys();
  static RequestKeys requestKeys = const RequestKeys();
  static ResponseKeys responseKeys = const ResponseKeys();
  static RequestValues requestValues = const RequestValues();
}

class ErrorKeys {
  const ErrorKeys();

  String get exception => 'exception';
}

class HeadersKeys {
  const HeadersKeys();

  String get authorization => 'Authorization';

  String get apikey => 'apikey';

  String get requestId => 'REQUEST-ID';

  String get rToken => 'R-token';

  String get requesterId => 'REQUESTER-ID';

  String get timestamp => 'TIMESTAMP';

  String get tToken => 'T-token';

  String get xAuthToken => 'X-AUTH-TOKEN';

  String get xCmId => 'X-CM-ID';

  String get xHiuId => 'X-HIU-ID';

  String get xToken => 'X-token';
}

class RequestKeys {
  const RequestKeys();

  String get address => 'address';

  String get authMode => 'authMode';

  String get appToken => 'appToken';

  String get authMethod => 'authMethod';

  String get authCode => 'authCode';

  String get action => 'action';

  String get authData => 'authData';

  String get authMethods => 'authMethods';

  String get abhaAddress => 'abhaAddress';

  String get abhaNumber => 'healthIdNumber';

  String get aadhaar => 'aadhaar';

  String get alreadyExistedPHR => 'alreadyExistedPHR';

  String get body => 'body';

  String get code => 'code';

  String get count => 'count';

  String get careContexts => 'careContexts';

  String get clientId => 'clientId';

  String get context => 'context';

  String get clientSecret => 'clientSecret';

  String get contextChecked => 'contextChecked';

  String get consents => 'consents';

  String get consent => 'consent';

  String get communicationHint => 'communicationHint';

  String get dayOfBirth => 'dayOfBirth';

  String get emailId => 'emailId';

  String get email => 'email';

  String get face => 'face';

  String get firstName => 'firstName';

  String get grantType => 'grantType';

  String get gender => 'gender';

  String get healthId => 'healthId';

  String get hipIds => 'hipIds';

  String get hipId => 'hipId';

  String get hprId => 'hprId';

  String get hip => 'hip';

  String get hiTypes => 'hiTypes';

  String get hiType => 'hiType';

  String get hipDetails => 'hipDetails';

  String get hfrUid => 'hfrUid';

  String get id => 'id';

  String get intent => 'intent';

  String get isNotificationRead => 'isNotificationRead';

  String get limit => 'limit';

  String get loginHint => 'loginHint';

  String get loginId => 'loginId';

  String get lastName => 'lastName';

  String get linkRefNumber => 'linkRefNumber';

  String get link => 'link';

  String get location => 'location';

  String get latitude => 'latitude';

  String get longitude => 'longitude';

  String get mobileEmail => 'value';

  String get mobile => 'mobile';

  String get middleName => 'middleName';

  String get meta => 'meta';

  String get monthOfBirth => 'monthOfBirth';

  String get metaData => 'metaData';

  String get name => 'name';

  String get notificationId => 'notificationId';

  String get offset => 'offset';

  String get osType => 'osType';

  String get otp => 'otp';

  String get otpSystem => 'otpSystem';

  String get otpValue => 'otpValue';

  String get patientId => 'patientId';

  String get parameters => 'parameters';

  String get patient => 'patient';

  String get profile => 'profile';

  String get phoneNumber => 'phoneNumber';

  String get password => 'password';

  String get profilePhoto => 'profilePhoto';

  String get permission => 'permission';

  String get pin => 'pin';

  String get pinCode => 'pinCode';

  String get purpose => 'purpose';

  String get rdPidData => 'rdPidData';

  String get requester => 'requester';

  String get referenceNumber => 'referenceNumber';

  String get requesterId => 'requesterId';

  String get reloadConsent => 'reloadConsent';

  String get requestId => 'requestId';

  String get requestIds => 'requestIds';

  String get scope => 'scope';

  String get stateCode => 'stateCode';

  String get sessionId => 'sessionId';

  String get temporaryToken => 'temporaryToken';

  String get type => 'type';

  String get title => 'title';

  String get timeStamp => 'timeStamp';

  String get token => 'token';

  String get transactionId => 'transactionId';

  String get txnId => 'txnId';

  String get keyType => 'KEY_TYPE';

  String get userAppVersion => 'userAppVersion';

  String get unverifiedIdentifiers => 'unverifiedIdentifiers';

  String get value => 'value';

  String get version => 'version';

  String get yearOfBirth => 'yearOfBirth';

  String get line => 'line';

  String get districtName => 'district';

  String get stateName => 'state';
}

class RequestValues {
  const RequestValues();

  String get otpSystemAbdm => 'abdm';

  String get otpSystemAadhaar => 'aadhaar';

  String get scopeAbhaEnroll => 'abha-enrol';

  String get scopeAbhaEnrollment => 'abha-enrollment';

  String get scopeAbhaAddressEnroll => 'abha-address-enroll';

  String get scopeAbhaAddressProfile => 'abha-address-profile';

  String get scopeAbhaLogin => 'abha-login';

  String get scopeAbhaAddressLogin => 'abha-address-login';

  String get scopeMobileVerify => 'mobile-verify';

  String get scopeEmailVerify => 'email-verify';

  String get scopeAadhaarVerify => 'aadhaar-verify';

  String get scopePasswordVerify => 'password-verify';

  String get loginHintMobileNumber => 'mobile-number';

  String get loginHintAbhaNumber => 'abha-number';

  String get loginHintEmail => 'email';

  String get loginHintAbhaAddress => 'abha-address';

  String get authMethodsOtp => 'otp';

  String get authMethodsPassword => 'password';

  String get patientShare => 'PROFILE_SHARE';
}

class ResponseKeys {
  const ResponseKeys();

  String get accessToken => 'accessToken';

  String get acknowledgement => 'acknowledgement';

  String get abhaAddress => 'abhaAddress';

  String get authResult => 'authResult';

  String get code => 'code';

  String get counterId => 'counter-id';

  String get careContexts => 'careContexts';

  String get data => 'data';

  String get display => 'display';

  String get error => 'error';

  String get email => 'email';

  String get hipId => 'hipId';

  String get hip => 'hip';

  String get hip_id => 'hip-id';

  String get id => 'id';

  String get identifier => 'identifier';

  String get links => 'links';

  String get message => 'message';

  String get mobileEmail => 'mobileEmail';

  String get mappedPhrAddress => 'mappedPhrAddress';

  String get matchedBy => 'matchedBy';

  String get name => 'name';

  String get phrAddress => 'phrAddress';

  String get patient => 'patient';

  String get reason => 'reason';

  String get requestId => 'requestId';

  String get referenceNumber => 'referenceNumber';

  String get statusCode => 'statusCode';

  String get sessionId => 'sessionId';

  String get status => 'status';

  String get statuses => 'statuses';

  String get tokenType => 'tokenType';

  String get tokens => 'tokens';

  String get token => 'token';

  String get refreshToken => 'refreshToken';

  String get transactionId => 'transactionId';

  String get txnId => 'txnId';

  String get userId => 'userId';

  String get users => 'users';
}
