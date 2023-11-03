import 'dart:convert';

import 'package:abha/app/abha_app.dart';

ProfileModel profileFromMap(String str) {
  Map<String, dynamic> data = json.decode(str);
  return data.isEmpty ? ProfileModel() : ProfileModel.fromMap(json.decode(str));
}

String profileToMap(ProfileModel data) => json.encode(data.toMap());

class ProfileModel {
  ProfileModel({
    this.abhaAddress,
    this.fullName,
    this.name,
    this.gender,
    this.dateOfBirth,
    this.hasTransactionPin,
    this.abhaNumber,
    this.address,
    this.stateName,
    this.stateCode,
    this.districtCode,
    this.districtName,
    this.pinCode,
    this.aadhaarVerified,
    this.profilePhoto,
    this.authMethods,
    this.email,
    this.mobile,
    this.kycPhoto,
    this.phrAddress,
    // this.tags,
    // this.linkedPhrAddess,
    // this.kycVerified,
    this.status,
    // this.verificationType,
    this.townName,
    this.emailVerified,
    this.mobileVerified,
    // this.kycDocumentType,
    this.kycStatus,
    this.countryName,
    this.abhaLinkedCount,
  });

  String? abhaAddress;
  String? fullName;
  Name? name;
  String? gender;
  DateOfBirth? dateOfBirth;
  bool? hasTransactionPin;
  String? abhaNumber;
  String? address;
  String? stateName;
  String? stateCode;
  String? districtCode;
  String? districtName;
  String? pinCode;
  bool? aadhaarVerified;
  String? profilePhoto;
  List<String>? authMethods;
  String? email;
  String? mobile;
  String? kycPhoto;
  List<String>? phrAddress;
  // ProfileTags? tags;
  // int? linkedPhrAddess;
  // String? kycVerified;
  dynamic status;
  // dynamic verificationType;
  String? townName;
  bool? emailVerified;
  bool? mobileVerified;
  // dynamic kycDocumentType;
  String? kycStatus;
  String? countryName;
  String? abhaLinkedCount;

  factory ProfileModel.fromMap(Map<String, dynamic> json) {
    try {
      return ProfileModel(
        abhaAddress: json['abhaAddress'],
        fullName: json['fullName'],
        name: Name.fromV3ProfileMap(json),
        gender: json['gender'],
        dateOfBirth: DateOfBirth.fromV3ProfileMap(json),
        hasTransactionPin: json.containsKey('hasTransactionPin')
            ? json['hasTransactionPin'] ?? false
            : false,
        abhaNumber: json.containsKey('abhaNumber')
            ? json['abhaNumber'] ?? json['healthId'] ?? ''
            : null,
        address: json['address'],
        stateName: json['stateName'],
        stateCode: json['stateCode'],
        districtCode: json['districtCode'],
        districtName: json['districtName'],
        pinCode: json['pinCode'],
        aadhaarVerified: json.containsKey('aadhaarVerified')
            ? json['aadhaarVerified']
            : null,
        profilePhoto:
            json.containsKey('profilePhoto') ? json['profilePhoto'] : null,
        authMethods: json['authMethods'] != null
            ? List<String>.from(json['authMethods'].map((x) => x))
            : [],
        email: json['email'],
        mobile: json['mobile'],
        kycPhoto: json.containsKey('kycPhoto') ? json['kycPhoto'] : null,
        phrAddress: json.containsKey('phrAddress') && json['phrAddress'] != null
            ? List<String>.from(json['phrAddress'].map((x) => x))
            : [],
        // tags: json['tags'] != null ? ProfileTags.fromMap(json['tags']) : ProfileTags(),
        // linkedPhrAddess: json['linkedPhrAddess'],
        // kycVerified: json['kycVerified'],
        status: json['status'],
        // verificationType: json['verificationType'],
        townName: json.containsKey('townName') ? json['townName'] : null,
        emailVerified: json.containsKey('emailVerified')
            ? json['emailVerified'].toString().toLowerCase() == 'true'
            : false,
        mobileVerified: json.containsKey('mobileVerified')
            ? json['mobileVerified'].toString().toLowerCase() == 'true'
            : false,
        // kycDocumentType: json['kycDocumentType'],
        kycStatus: json['kycStatus'],
        countryName: json.containsKey('countryName')
            ? json['countryName'] ?? 'INDIA'
            : 'INDIA',
        abhaLinkedCount: json.containsKey('abhaLinkedCount')
            ? json['abhaLinkedCount']
            : null,
      );
    } catch (e) {
      abhaLog.d('Create profile model exception is $e');
      return ProfileModel();
    }
  }

  factory ProfileModel.fromMappedUserMap(Map<String, dynamic> json) {
    try {
      return ProfileModel(
        abhaAddress: json['abhaAddress'],
        fullName: json['fullName'],
        name: Name.fromV3ProfileMap(json),
        abhaNumber: json.containsKey('abhaNumber')
            ? json['abhaNumber'] ?? json['healthId'] ?? ''
            : null,
        aadhaarVerified: json.containsKey('aadhaarVerified')
            ? json['aadhaarVerified']
            : null,
        profilePhoto:
            json.containsKey('profilePhoto') ? json['profilePhoto'] : null,
        kycPhoto: json.containsKey('kycPhoto') ? json['kycPhoto'] : null,
        status: json['status'],
        kycStatus: json['kycStatus'],
      );
    } catch (e) {
      abhaLog.d('Create profile model exception is $e');
      return ProfileModel();
    }
  }

  Map<String, dynamic> toMap() => {
        'abhaAddress': abhaAddress,
        'fullName': fullName,
        'name': name?.toMap(),
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toMap(),
        'abhaNumber': abhaNumber,
        'address': address,
        'stateName': stateName,
        'stateCode': stateCode,
        'districtCode': districtCode,
        'districtName': districtName,
        'pinCode': pinCode,
        'aadhaarVerified': aadhaarVerified,
        'profilePhoto': profilePhoto,
        'authMethods': List<dynamic>.from(authMethods!.map((x) => x)),
        'email': email,
        'mobile': mobile,
        'kycPhoto': kycPhoto,
        'phrAddress': List<dynamic>.from(phrAddress!.map((x) => x)),
        // 'tags': tags?.toMap(),
        // 'linkedPhrAddess': linkedPhrAddess,
        // 'kycVerified': kycVerified,
        'status': status,
        // 'verificationType': verificationType,
        'townName': townName,
        'emailVerified': emailVerified.toString(),
        'mobileVerified': mobileVerified.toString(),
        'kycStatus': kycStatus,
      };

  Map<String, dynamic> toUpdateProfileMap() {
    String? dayOfBirth = dateOfBirth?.date?.toString() ?? '';
    String? monthOfBirth = dateOfBirth?.month?.toString() ?? '';

    if (dateOfBirth != null &&
        dateOfBirth!.date != null &&
        dateOfBirth!.date! < 10) {
      dayOfBirth = '0${dateOfBirth?.date}';
    }
    if (dateOfBirth != null &&
        dateOfBirth!.month != null &&
        dateOfBirth!.month! < 10) {
      monthOfBirth = '0${dateOfBirth?.month}';
    }

    return {
      // 'abhaAddress': abhaAddress,
      // 'abhaNumber': abhaNumber ?? '',
      'firstName': name?.firstName ?? '',
      'middleName': name?.middleName ?? '',
      'lastName': name?.lastName ?? '',
      'dayOfBirth': dayOfBirth,
      'monthOfBirth': monthOfBirth,
      'yearOfBirth': dateOfBirth?.year?.toString() ?? '',
      'gender': gender ?? '',
      'address': address,
      'stateName': stateName,
      'stateCode': stateCode,
      'districtCode': districtCode,
      'districtName': districtName,
      'pinCode': pinCode,
      'profilePhoto': profilePhoto ?? '',
    };
  }
}

class DateOfBirth {
  DateOfBirth({
    this.date,
    this.month,
    this.year,
  });

  int? date;
  int? month;
  int? year;

  factory DateOfBirth.fromMap(Map<String, dynamic> json) => DateOfBirth(
        date: json['date'],
        month: json['month'],
        year: json['year'],
      );

  factory DateOfBirth.fromV3ProfileMap(Map<String, dynamic> json) =>
      DateOfBirth(
        date: int.tryParse(json['dayOfBirth']),
        month: int.tryParse(json['monthOfBirth']),
        year: int.tryParse(json['yearOfBirth']),
      );

  Map<String, dynamic> toMap() => {
        'date': date,
        'month': month,
        'year': year,
      };

  Map<String, dynamic> toV3ProfileMap() => {
        'dayOfBirth': date?.toString(),
        'monthOfBirth': month?.toString(),
        'yearOfBirth': year?.toString(),
      };
}

class Name {
  Name({
    this.firstName,
    this.middleName,
    this.lastName,
  });

  String? firstName;
  String? middleName;
  String? lastName;

  factory Name.fromMap(Map<String, dynamic> json) => Name(
        firstName: json['firstName'] ?? json['first'] ?? '',
        middleName: json['middleName'] ?? json['middle'] ?? '',
        lastName: json['lastName'] ?? json['last'] ?? '',
      );

  factory Name.fromV3ProfileMap(Map<String, dynamic> json) => Name(
        firstName: json['firstName'] ?? '',
        middleName: json['middleName'] ?? '',
        lastName: json['lastName'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'firstName': firstName,
        'middleName': middleName,
        'lastName': lastName,
      };
}

class ProfileTags {
  ProfileTags({
    this.additionalProp1,
    this.additionalProp2,
    this.additionalProp3,
  });

  String? additionalProp1;
  String? additionalProp2;
  String? additionalProp3;

  factory ProfileTags.fromMap(Map<String, dynamic> json) => ProfileTags(
        additionalProp1: json['additionalProp1'],
        additionalProp2: json['additionalProp2'],
        additionalProp3: json['additionalProp3'],
      );

  Map<String, dynamic> toMap() => {
        'additionalProp1': additionalProp1,
        'additionalProp2': additionalProp2,
        'additionalProp3': additionalProp3,
      };
}
