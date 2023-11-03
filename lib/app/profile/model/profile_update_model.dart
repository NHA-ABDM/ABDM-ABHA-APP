import 'package:abha/export_packages.dart';

class ProfileUpdateModel {
  UserName? name;
  DateOfBirth? dateOfBirth;
  String? gender;
  int? stateCode;
  int? districtCode;
  int? pinCode;
  String? address;
  String? profilePhoto;

  ProfileUpdateModel({
    this.name,
    this.dateOfBirth,
    this.gender,
    this.stateCode,
    this.districtCode,
    this.pinCode,
    this.address,
    this.profilePhoto,
  });

  ProfileUpdateModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] != null ? UserName.fromMap(json['name']) : null;
    dateOfBirth = json['dateOfBirth'] != null
        ? DateOfBirth.fromMap(json['dateOfBirth'])
        : null;
    gender = json['gender'];
    stateCode = json['stateCode'];
    districtCode = json['districtCode'];
    pinCode = json['pinCode'];
    address = json['address'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data['name'] = name?.toMap();
    }
    if (dateOfBirth != null) {
      data['dateOfBirth'] = dateOfBirth?.toMap();
    }
    data['gender'] = gender;
    data['stateCode'] = stateCode;
    data['districtCode'] = districtCode;
    data['pinCode'] = pinCode;
    data['address'] = address;
    data['profilePhoto'] =
        profilePhoto?.isNotEmpty == true ? profilePhoto : null;
    return data;
  }
}

class UserName {
  UserName({
    this.firstName,
    this.middleName,
    this.lastName,
  });

  String? firstName;
  String? middleName;
  String? lastName;

  factory UserName.fromMap(Map<String, dynamic> json) => UserName(
        firstName: json['firstName'] ?? json['first'] ?? '',
        middleName: json['middleName'] ?? json['middle'] ?? '',
        lastName: json['lastName'] ?? json['last'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'first': firstName,
        'middle': middleName,
        'last': lastName,
      };
}
