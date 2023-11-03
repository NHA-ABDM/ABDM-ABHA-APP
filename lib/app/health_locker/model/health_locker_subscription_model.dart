// To parse this JSON data, do
//
//     final subscriptionModel = subscriptionModelFromMap(jsonString);

import 'dart:convert';

import 'package:abha/app/health_locker/model/health_locker_info_model.dart';

HealthLockerSubscriptionModel subscriptionModelFromMap(String str) =>
    HealthLockerSubscriptionModel.fromMap(json.decode(str));

String subscriptionModelToMap(HealthLockerSubscriptionModel data) =>
    json.encode(data.toMap());

class HealthLockerSubscriptionModel {
  HealthLockerSubscriptionModel({
    this.hiuId,
    this.subscriptionEditAndApprovalRequest,
  });

  String? hiuId;
  SubscriptionEditAndApprovalRequest? subscriptionEditAndApprovalRequest;

  factory HealthLockerSubscriptionModel.fromMap(Map<String, dynamic> json) =>
      HealthLockerSubscriptionModel(
        hiuId: json['hiuId'],
        subscriptionEditAndApprovalRequest:
            json['subscriptionEditAndApprovalRequest'] == null
                ? null
                : SubscriptionEditAndApprovalRequest.fromMap(
                    json['subscriptionEditAndApprovalRequest'],
                  ),
      );

  Map<String, dynamic> toMap() => {
        'hiuId': hiuId,
        'subscriptionEditAndApprovalRequest':
            subscriptionEditAndApprovalRequest == null
                ? null
                : subscriptionEditAndApprovalRequest!.toMap(),
      };
}

class SubscriptionEditAndApprovalRequest {
  SubscriptionEditAndApprovalRequest({
    this.excludedSources,
    this.includedSources,
    this.isApplicableForAllHiPs,
  });

  List<dynamic>? excludedSources;
  List<SubscriptionIncludedSource>? includedSources;
  bool? isApplicableForAllHiPs;

  factory SubscriptionEditAndApprovalRequest.fromMap(
    Map<String, dynamic> json,
  ) =>
      SubscriptionEditAndApprovalRequest(
        excludedSources: json['excludedSources'] == null
            ? null
            : List<dynamic>.from(json['excludedSources'].map((x) => x)),
        includedSources: json['includedSources'] == null
            ? null
            : List<SubscriptionIncludedSource>.from(
                json['includedSources']
                    .map((x) => SubscriptionIncludedSource.fromMap(x)),
              ),
        isApplicableForAllHiPs: json['isApplicableForAllHIPs'],
      );

  Map<String, dynamic> toMap() => {
        'excludedSources': excludedSources == null
            ? null
            : List<dynamic>.from(excludedSources!.map((x) => x)),
        'includedSources': includedSources == null
            ? null
            : List<dynamic>.from(includedSources!.map((x) => x.toMap())),
        'isApplicableForAllHIPs': isApplicableForAllHiPs,
      };
}

class Hip {
  Hip({
    this.id,
    this.name,
    this.type,
  });

  String? id;
  String? name;
  String? type;

  factory Hip.fromMap(Map<String, dynamic> json) => Hip(
        id: json['id'],
        name: json['name'],
        type: json['type'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': type,
      };
}

class SubscriptionPeriod {
  SubscriptionPeriod({
    this.from,
    this.to,
  });

  DateTime? from;
  DateTime? to;

  factory SubscriptionPeriod.fromMap(Map<String, dynamic> json) =>
      SubscriptionPeriod(
        from: json['from'] == null ? null : DateTime.parse(json['from']),
        to: json['to'] == null ? null : DateTime.parse(json['to']),
      );

  Map<String, dynamic> toMap() => {
        'from': from == null ? null : from!.toIso8601String(),
        'to': to == null ? null : to!.toIso8601String(),
      };
}

class Purpose {
  Purpose({
    this.code,
    this.refUri,
    this.text,
  });

  String? code;
  String? refUri;
  String? text;

  factory Purpose.fromMap(Map<String, dynamic> json) => Purpose(
        code: json['code'],
        refUri: json['refUri'],
        text: json['text'],
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'refUri': refUri,
        'text': text,
      };
}
