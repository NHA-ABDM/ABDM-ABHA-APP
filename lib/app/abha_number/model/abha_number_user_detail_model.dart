import 'dart:convert';

AbhaNumberUserDetailModel userAbhaNumbeDetailModelFromMap(String str) =>
    AbhaNumberUserDetailModel.fromMap(json.decode(str));
String userAbhaNumbeDetailModelToMap(AbhaNumberUserDetailModel data) =>
    json.encode(data.toMap());

class AbhaNumberUserDetailModel {
  String? txnId;
  String? authResult;
  String? message;
  String? token;
  int? expiresIn;
  List<Account>? accounts;

  AbhaNumberUserDetailModel({
    this.txnId,
    this.authResult,
    this.message,
    this.token,
    this.expiresIn,
    this.accounts,
  });

  factory AbhaNumberUserDetailModel.fromMap(Map<String, dynamic> json) =>
      AbhaNumberUserDetailModel(
        txnId: json['txnId'],
        authResult: json['authResult'],
        message: json['message'],
        token: json['token'],
        expiresIn: json['expiresIn'],
        accounts: json['accounts'] == null
            ? []
            : List<Account>.from(
                json['accounts']!.map((x) => Account.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'txnId': txnId,
        'authResult': authResult,
        'message': message,
        'token': token,
        'expiresIn': expiresIn,
        'accounts': accounts == null
            ? []
            : List<dynamic>.from(accounts!.map((x) => x.toMap())),
      };
}

class Account {
  String? abhaNumber;
  String? preferredAbhaAddress;
  String? name;
  String? gender;
  String? dob;
  String? status;
  String? profilePhoto;
  bool? kycVerified;

  Account({
    this.abhaNumber,
    this.preferredAbhaAddress,
    this.name,
    this.gender,
    this.dob,
    this.status,
    this.profilePhoto,
    this.kycVerified,
  });

  factory Account.fromMap(Map<String, dynamic> json) => Account(
        abhaNumber: json['ABHANumber'],
        preferredAbhaAddress: json['preferredAbhaAddress'],
        name: json['name'],
        gender: json['gender'],
        dob: json['dob'],
        status: json['status'],
        profilePhoto: json['profilePhoto'],
        kycVerified: json['kycVerified'],
      );

  Map<String, dynamic> toMap() => {
        'ABHANumber': abhaNumber,
        'preferredAbhaAddress': preferredAbhaAddress,
        'name': name,
        'gender': gender,
        'dob': dob,
        'status': status,
        'profilePhoto': profilePhoto,
        'kycVerified': kycVerified,
      };
}
