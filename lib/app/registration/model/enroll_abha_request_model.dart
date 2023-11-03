class EnrollAbhaRequestModel {
  String? txnId;
  PhrDetails? phrDetails;

  EnrollAbhaRequestModel({this.txnId, this.phrDetails});

  EnrollAbhaRequestModel.fromJson(Map<String, dynamic> json) {
    txnId = json['txnId'];
    phrDetails = json['phrDetails'] != null
        ? PhrDetails.fromJson(json['phrDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['txnId'] = txnId;
    if (phrDetails != null) {
      data['phrDetails'] = phrDetails!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toSuggestedAbhaAddressJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['txnId'] = txnId;
    if (phrDetails != null) {
      data['firstName'] = phrDetails!.firstName ?? '';
      data['lastName'] = phrDetails!.lastName ?? '';
      data['dayOfBirth'] = phrDetails!.dayOfBirth ?? '';
      data['monthOfBirth'] = phrDetails!.monthOfBirth ?? '';
      data['yearOfBirth'] = phrDetails!.yearOfBirth ?? '';
      data['email'] =
          ''; //phrDetails!.email ?? ''; /// we are passing blank as backend wants email in encrypted
    }
    return data;
  }
}

class PhrDetails {
  String? firstName;
  String? middleName;
  String? lastName;
  String? dayOfBirth;
  String? monthOfBirth;
  String? yearOfBirth;
  String? gender;
  String? email;
  String? mobile;
  String? address;
  String? stateName;
  String? stateCode;
  String? districtName;
  String? districtCode;
  String? pinCode;
  String? abhaAddress;
  String? password;

  PhrDetails({
    this.firstName,
    this.middleName,
    this.lastName,
    this.dayOfBirth,
    this.monthOfBirth,
    this.yearOfBirth,
    this.gender,
    this.email,
    this.mobile,
    this.address,
    this.stateName,
    this.stateCode,
    this.districtName,
    this.districtCode,
    this.pinCode,
    this.abhaAddress,
    this.password,
  });

  PhrDetails.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    dayOfBirth = json['dayOfBirth'];
    monthOfBirth = json['monthOfBirth'];
    yearOfBirth = json['yearOfBirth'];
    gender = json['gender'];
    email = json['email'];
    mobile = json['mobile'];
    address = json['address'];
    stateName = json['stateName'];
    stateCode = json['stateCode'];
    districtName = json['districtName'];
    districtCode = json['districtCode'];
    pinCode = json['pinCode'];
    abhaAddress = json['abhaAddress'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['middleName'] = middleName ?? '';
    data['lastName'] = lastName ?? '';
    data['dayOfBirth'] = dayOfBirth ?? '';
    data['monthOfBirth'] = monthOfBirth ?? '';
    data['yearOfBirth'] = yearOfBirth;
    data['gender'] = gender ?? '';
    data['email'] = email ?? '';
    data['mobile'] = mobile ?? '';
    data['address'] = address ?? '';
    data['stateName'] = stateName ?? '';
    data['stateCode'] = stateCode;
    data['districtName'] = districtName ?? '';
    data['districtCode'] = districtCode;
    data['pinCode'] = pinCode;
    data['abhaAddress'] = abhaAddress;
    data['password'] = password ?? '';
    return data;
  }

  Map<String, dynamic> toSuggestedAbhaAddressJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // if(!Validator.isNullOrEmpty(firstName)) {
    data['firstName'] = firstName ?? '';
    // }
    // if(!Validator.isNullOrEmpty(middleName)) {
    data['middleName'] = middleName ?? '';
    // }
    // if(!Validator.isNullOrEmpty(lastName)) {
    data['lastName'] = lastName ?? '';
    // }
    data['dayOfBirth'] = dayOfBirth ?? '';
    data['monthOfBirth'] = monthOfBirth ?? '';
    data['yearOfBirth'] = yearOfBirth ?? '';
    data['gender'] = gender ?? '';
    data['email'] = email ?? '';
    data['mobile'] = mobile ?? '';
    data['address'] = address ?? '';
    data['stateName'] = stateName ?? '';
    data['stateCode'] = stateCode;
    data['districtName'] = districtName ?? '';
    data['districtCode'] = districtCode;
    data['pinCode'] = pinCode;
    return data;
  }
}
