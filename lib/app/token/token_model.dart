import 'dart:convert';

List<TokenModel> dashboardTokenModelFromMap(String str) {
  dynamic data = json.decode(str);
  if (data.isEmpty) {
    return <TokenModel>[];
  } else {
    return List<TokenModel>.from(
      json.decode(str).map((x) => TokenModel.fromMap(x)),
    );
  }
}

String tokenDetailModelToMap(List<TokenModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class TokenModel {
  TokenModel({
    this.id,
    this.patientId,
    this.tokenNumber,
    this.hipId,
    this.clientId,
    this.expiresIn,
    this.dateCreated,
    this.currentDateTime,
  });

  int? id;
  String? patientId;
  String? tokenNumber;
  String? hipId;
  String? clientId;
  double? expiresIn;
  DateTime? dateCreated;
  DateTime? currentDateTime;

  factory TokenModel.fromMap(Map<String, dynamic> json) => TokenModel(
        id: json['id'],
        tokenNumber: json['tokenNumber'],
        hipId: json['hipId'],
        clientId: json['clientId'],
        expiresIn: 1800, /// TO-IMPLEMENT: added 1800 sec hardcoded as Atik told we have to set expiry for 30 min
            // json['expiresIn'] == null
            //     ? null
            //     : json['expiresIn'] is double ? json['expiresIn'] : double.parse(json['expiresIn']),
        dateCreated: json['dateCreated'] == null
            ? null
            : DateTime.parse(json['dateCreated']),//.add(DateTime.now().timeZoneOffset),
        currentDateTime: DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'tokenNumber': tokenNumber,
        'hipId': hipId,
        'clientId': clientId,
        'expiresIn': expiresIn,
        'dateCreated':
            dateCreated == null ? null : dateCreated!.toIso8601String(),
        'currentDateTime':
            currentDateTime == null ? null : currentDateTime!.toIso8601String(),
      };
}
