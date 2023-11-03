class ProfileAbhaModel {
  String? txnId;
  String? message;
  String? authResult;
  List<Users>? users;
  List<Accounts>? accounts;
  Tokens? tokens;

  ProfileAbhaModel({
    this.txnId,
    this.message,
    this.authResult,
    this.users,
    this.accounts,
    this.tokens,
  });

  ProfileAbhaModel.fromJson(Map<String, dynamic> json) {
    txnId = json['txnId'];
    message = json['message'];
    authResult = json['authResult'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(Users.fromJson(v));
      });
    }
    if (json['accounts'] != null) {
      accounts = <Accounts>[];
      json['accounts'].forEach((v) {
        accounts!.add(Accounts.fromJson(v));
      });
    }
    tokens = json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['txnId'] = txnId;
    data['message'] = message;
    data['authResult'] = authResult;
    if (users != null) {
      data['users'] = users!.map((v) => v.toJson()).toList();
    }
    if (accounts != null) {
      data['accounts'] = accounts!.map((v) => v.toJson()).toList();
    }
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    return data;
  }
}

class Users {
  String? abhaAddress;
  String? fullName;
  String? profilePhoto;
  String? abhaNumber;
  String? status;
  String? kycStatus;

  Users({
    this.abhaAddress,
    this.fullName,
    this.profilePhoto,
    this.abhaNumber,
    this.status,
    this.kycStatus,
  });

  Users.fromJson(Map<String, dynamic> json) {
    abhaAddress = json['abhaAddress'];
    fullName = json['fullName'];
    profilePhoto = json['profilePhoto'];
    abhaNumber = json['abhaNumber'];
    status = json['status'];
    kycStatus = json['kycStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['abhaAddress'] = abhaAddress;
    data['fullName'] = fullName;
    data['profilePhoto'] = profilePhoto;
    data['abhaNumber'] = abhaNumber;
    data['status'] = status;
    data['kycStatus'] = kycStatus;
    return data;
  }
}

class Accounts {
  String? mobile;
  String? firstName;
  String? middleName;
  String? lastName;
  String? name;
  String? yearOfBirth;
  String? dayOfBirth;
  String? monthOfBirth;
  String? gender;
  String? email;
  String? profilePhoto;
  String? status;
  String? stateCode;
  String? districtCode;
  String? subDistrictCode;
  String? villageCode;
  String? townCode;
  String? wardCode;
  String? pincode;
  String? address;
  String? kycPhoto;
  String? stateName;
  String? districtName;
  String? subdistrictName;
  String? villageName;
  String? townName;
  String? wardName;
  List<String>? authMethods;
  bool? kycVerified;
  String? verificationStatus;
  String? verificationType;
  String? emailVerified;
  String? aBHANumber;
  String? preferredAbhaAddress;

  Accounts({
    this.mobile,
    this.firstName,
    this.middleName,
    this.lastName,
    this.name,
    this.yearOfBirth,
    this.dayOfBirth,
    this.monthOfBirth,
    this.gender,
    this.email,
    this.profilePhoto,
    this.status,
    this.stateCode,
    this.districtCode,
    this.subDistrictCode,
    this.villageCode,
    this.townCode,
    this.wardCode,
    this.pincode,
    this.address,
    this.kycPhoto,
    this.stateName,
    this.districtName,
    this.subdistrictName,
    this.villageName,
    this.townName,
    this.wardName,
    this.authMethods,
    this.kycVerified,
    this.verificationStatus,
    this.verificationType,
    this.emailVerified,
    this.aBHANumber,
    this.preferredAbhaAddress,
  });

  Accounts.fromJson(Map<String, dynamic> json) {
    mobile = json['mobile'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    name = json['name'];
    yearOfBirth = json['yearOfBirth'];
    dayOfBirth = json['dayOfBirth'];
    monthOfBirth = json['monthOfBirth'];
    gender = json['gender'];
    email = json['email'];
    profilePhoto = json['profilePhoto'];
    status = json['status'];
    stateCode = json['stateCode'];
    districtCode = json['districtCode'];
    subDistrictCode = json['subDistrictCode'];
    villageCode = json['villageCode'];
    townCode = json['townCode'];
    wardCode = json['wardCode'];
    pincode = json['pincode'];
    address = json['address'];
    kycPhoto = json['kycPhoto'];
    stateName = json['stateName'];
    districtName = json['districtName'];
    subdistrictName = json['subdistrictName'];
    villageName = json['villageName'];
    townName = json['townName'];
    wardName = json['wardName'];
    authMethods = json['authMethods'].cast<String>();
    kycVerified = json['kycVerified'];
    verificationStatus = json['verificationStatus'];
    verificationType = json['verificationType'];
    emailVerified = json['emailVerified'];
    aBHANumber = json['ABHANumber'];
    preferredAbhaAddress = json['preferredAbhaAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobile'] = mobile;
    data['firstName'] = firstName;
    data['middleName'] = middleName;
    data['lastName'] = lastName;
    data['name'] = name;
    data['yearOfBirth'] = yearOfBirth;
    data['dayOfBirth'] = dayOfBirth;
    data['monthOfBirth'] = monthOfBirth;
    data['gender'] = gender;
    data['email'] = email;
    data['profilePhoto'] = profilePhoto;
    data['status'] = status;
    data['stateCode'] = stateCode;
    data['districtCode'] = districtCode;
    data['subDistrictCode'] = subDistrictCode;
    data['villageCode'] = villageCode;
    data['townCode'] = townCode;
    data['wardCode'] = wardCode;
    data['pincode'] = pincode;
    data['address'] = address;
    data['kycPhoto'] = kycPhoto;
    data['stateName'] = stateName;
    data['districtName'] = districtName;
    data['subdistrictName'] = subdistrictName;
    data['villageName'] = villageName;
    data['townName'] = townName;
    data['wardName'] = wardName;
    data['authMethods'] = authMethods;
    data['kycVerified'] = kycVerified;
    data['verificationStatus'] = verificationStatus;
    data['verificationType'] = verificationType;
    data['emailVerified'] = emailVerified;
    data['ABHANumber'] = aBHANumber;
    data['preferredAbhaAddress'] = preferredAbhaAddress;
    return data;
  }
}

class Tokens {
  String? token;
  int? expiresIn;
  String? refreshToken;
  int? refreshExpiresIn;

  Tokens({
    this.token,
    this.expiresIn,
    this.refreshToken,
    this.refreshExpiresIn,
  });

  Tokens.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiresIn = json['expiresIn'];
    refreshToken = json['refreshToken'];
    refreshExpiresIn = json['refreshExpiresIn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['expiresIn'] = expiresIn;
    data['refreshToken'] = refreshToken;
    data['refreshExpiresIn'] = refreshExpiresIn;
    return data;
  }
}
