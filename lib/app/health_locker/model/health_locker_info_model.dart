// To parse this JSON data, do
//
//     final healthLockerInfoModel = healthLockerInfoModelFromMap(jsonString);

import 'dart:convert';

HealthLockerInfoModel healthLockerInfoModelFromMap(String str) {
  Map<String, dynamic> data = json.decode(str);
  if (data.isEmpty) {
    return HealthLockerInfoModel();
  } else {
    return HealthLockerInfoModel.fromMap(data);
  }
}

String healthLockerInfoModelToMap(HealthLockerInfoModel data) =>
    json.encode(data.toMap());

class HealthLockerInfoModel {
  HealthLockerInfoModel({
    this.lockerId,
    this.lockerName,
    this.active,
    this.dateCreated,
    this.authorizations,
    this.subscriptions,
    this.autoApprovals,
  });

  String? lockerId;
  String? lockerName;
  bool? active;
  DateTime? dateCreated;
  List<Authorization>? authorizations;
  List<Subscription>? subscriptions;
  List<AutoApproval>? autoApprovals;

  factory HealthLockerInfoModel.fromMap(Map<String, dynamic> json) =>
      HealthLockerInfoModel(
        lockerId: json['lockerId'],
        lockerName: json['lockerName'],
        active: json['active'],
        dateCreated: DateTime.parse(json['dateCreated']),
        // authorizations: List<Authorization>.from(
        //   json['authorizations'].map((x) => Authorization.fromMap(x)),
        // ),
        subscriptions: List<Subscription>.from(
          json['subscriptions'].map((x) => Subscription.fromMap(x)),
        ),
        autoApprovals: json['autoApprovals'] == null
            ? null
            : List<AutoApproval>.from(
                json['autoApprovals'].map((x) => AutoApproval.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'lockerId': lockerId,
        'lockerName': lockerName,
        'active': active,
        'dateCreated': dateCreated?.toIso8601String(),
        'authorizations':
            List<dynamic>.from(authorizations!.map((x) => x.toMap())),
        'subscriptions': subscriptions == null
            ? null
            : List<dynamic>.from(subscriptions!.map((x) => x.toMap())),
        'autoApprovals':
            List<dynamic>.from(autoApprovals!.map((x) => x.toMap())),
      };
}

class Authorization {
  Authorization({
    this.requestId,
    this.patientId,
    this.status,
    this.purpose,
    this.authMode,
    this.requester,
    this.createdAt,
    this.lastUpdated,
  });

  String? requestId;
  String? patientId;
  String? status;
  AuthorizationPurpose? purpose;
  String? authMode;
  Requester? requester;
  DateTime? createdAt;
  DateTime? lastUpdated;

  factory Authorization.fromMap(Map? json) => Authorization(
        requestId: json?['requestId'],
        patientId: json?['patientId'],
        status: json?['status'],
        purpose: AuthorizationPurpose.fromMap(json?['purpose']),
        authMode: json?['authMode'],
        requester: Requester.fromMap(json?['requester']),
        createdAt: json?['createdAt'] == null
            ? null
            : DateTime.parse(json?['createdAt'] ?? ''),
        lastUpdated: json?['lastUpdated'] == null
            ? null
            : DateTime.parse(json?['lastUpdated'] ?? ''),
      );

  Map<String, dynamic> toMap() => {
        'requestId': requestId,
        'patientId': patientId,
        'status': status,
        'purpose': purpose?.toMap(),
        'authMode': authMode,
        'requester': requester?.toMap(),
        'createdAt': createdAt?.toIso8601String(),
        'lastUpdated': lastUpdated?.toIso8601String(),
      };
}

class AuthorizationPurpose {
  AuthorizationPurpose({
    this.code,
    this.text,
  });

  String? code;
  String? text;

  factory AuthorizationPurpose.fromMap(Map<String, dynamic>? json) =>
      AuthorizationPurpose(
        code: json?['code'],
        text: json?['text'],
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'text': text,
      };
}

class Requester {
  Requester({
    this.type,
    this.id,
    this.name,
  });

  String? type;
  String? id;
  String? name;

  factory Requester.fromMap(Map<String, dynamic>? json) => Requester(
        type: json?['type'],
        id: json?['id'],
        name: json?['name'],
      );

  Map<String, dynamic> toMap() => {
        'type': type,
        'id': id,
        'name': name,
      };
}

class AutoApproval {
  AutoApproval({
    this.id,
    this.autoApprovalId,
    this.active,
    this.patient,
    this.hiu,
    this.includedSources,
    this.excludedSources,
    this.dateCreated,
  });

  int? id;
  String? autoApprovalId;
  bool? active;
  Patient? patient;
  Hiu? hiu;
  List<AutoApprovalIncludedSource>? includedSources;
  List<dynamic>? excludedSources;
  DateTime? dateCreated;

  factory AutoApproval.fromMap(Map<String, dynamic> json) => AutoApproval(
        id: json['id'],
        autoApprovalId: json['autoApprovalId'],
        active: json['active'],
        patient:
            json['patient'] == null ? null : Patient.fromMap(json['patient']),
        hiu: json['hiu'] == null ? null : Hiu.fromMap(json['hiu']),
        includedSources: json['includedSources'] == null
            ? null
            : List<AutoApprovalIncludedSource>.from(
                json['includedSources']
                    .map((x) => AutoApprovalIncludedSource.fromMap(x)),
              ),
        excludedSources: json['excludedSources'] == null
            ? null
            : List<dynamic>.from(json['excludedSources'].map((x) => x)),
        dateCreated: json['dateCreated'] == null
            ? null
            : DateTime.parse(json['dateCreated']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'autoApprovalId': autoApprovalId,
        'active': active,
        'patient': patient?.toMap(),
        'hiu': hiu?.toMap(),
        'includedSources': includedSources == null
            ? null
            : List<dynamic>.from(includedSources!.map((x) => x.toMap())),
        'excludedSources': excludedSources == null
            ? null
            : List<dynamic>.from(excludedSources!.map((x) => x)),
        'dateCreated': dateCreated?.toIso8601String(),
      };
}

class Hiu {
  Hiu({
    this.id,
    this.name,
    this.type,
  });

  String? id;
  String? name;
  String? type;

  factory Hiu.fromMap(Map<String, dynamic> json) => Hiu(
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

class AutoApprovalIncludedSource {
  AutoApprovalIncludedSource({
    this.hiTypes,
    this.purpose,
    this.hip,
    this.period,
  });

  List<String>? hiTypes;
  IncludedSourcePurpose? purpose;
  Hiu? hip;
  PeriodHealthLocker? period;

  factory AutoApprovalIncludedSource.fromMap(Map<String, dynamic> json) =>
      AutoApprovalIncludedSource(
        hiTypes: List<String>.from(json['hiTypes'].map((x) => x)),
        purpose: IncludedSourcePurpose.fromMap(json['purpose']),
        hip: json['hip'] == null ? null : Hiu.fromMap(json['hip']),
        period: PeriodHealthLocker.fromMap(json['period']),
      );

  Map<String, dynamic> toMap() => {
        'hiTypes': List<dynamic>.from(hiTypes!.map((x) => x)),
        'purpose': purpose?.toMap(),
        'hip': hip,
        'period': period?.toMap(),
      };
}

class PeriodHealthLocker {
  PeriodHealthLocker({
    this.from,
    this.to,
  });

  DateTime? from;
  DateTime? to;

  factory PeriodHealthLocker.fromMap(Map<String, dynamic> json) =>
      PeriodHealthLocker(
        from: DateTime.parse(json['from']),
        to: DateTime.parse(json['to']),
      );

  Map<String, dynamic> toMap() => {
        'from': from?.toUtc().toIso8601String(),
        'to': to?.toUtc().toIso8601String(),
      };
}

class IncludedSourcePurpose {
  IncludedSourcePurpose({
    this.code,
    this.text,
    this.refUri,
  });

  String? code;
  String? text;
  String? refUri;

  factory IncludedSourcePurpose.fromMap(Map<String, dynamic> json) =>
      IncludedSourcePurpose(
        code: json['code'],
        text: json['text'],
        refUri:(json['refUri'] != null)  ? json['refUri'] : 'www.abdm.gov.in',
      );

  Map<String, dynamic> toMap() => {
        'code': code,
        'text': text,
        'refUri': (refUri == null) ? 'www.abdm.gov.in' : refUri,
      };
}

class Patient {
  Patient({
    this.id,
  });

  String? id;

  factory Patient.fromMap(Map<String, dynamic> json) => Patient(
        id: json['id'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
      };
}

class Subscription {
  Subscription({
    this.subscriptionId,
    this.purpose,
    this.dateCreated,
    this.status,
    this.dateGranted,
    this.patient,
    this.requester,
    this.includedSources,
  });

  String? subscriptionId;
  IncludedSourcePurpose? purpose;
  DateTime? dateCreated;
  String? status;
  DateTime? dateGranted;
  Patient? patient;
  Requester? requester;
  List<SubscriptionIncludedSource>? includedSources;

  factory Subscription.fromMap(Map? json) => Subscription(
        subscriptionId: json?['subscriptionId'],
        purpose: json?['purpose'] == null
            ? null
            : IncludedSourcePurpose.fromMap(json?['purpose']),
        dateCreated: json?['dateCreated'] == null
            ? null
            : DateTime.parse(json?['dateCreated']),
        status: json?['status'],
        dateGranted: json?['dateGranted'] == null
            ? null
            : DateTime.parse(json?['dateGranted']),
        patient:
            json?['patient'] == null ? null : Patient.fromMap(json?['patient']),
        requester: json?['requester'] == null
            ? null
            : Requester.fromMap(json?['requester']),
        includedSources: json?['includedSources'] == null
            ? null
            : List<SubscriptionIncludedSource>.from(
                json?['includedSources']
                    .map((x) => SubscriptionIncludedSource.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'subscriptionId': subscriptionId,
        'purpose': purpose?.toMap(),
        'dateCreated': dateCreated?.toIso8601String(),
        'status': status,
        'dateGranted': dateGranted?.toIso8601String(),
        'patient': patient?.toMap(),
        'requester': requester?.toMap(),
        'includedSources': includedSources == null
            ? null
            : List<dynamic>.from(includedSources!.map((x) => x.toMap())),
      };
}

class SubscriptionIncludedSource {
  SubscriptionIncludedSource({
    this.hip,
    this.categories,
    // this.categoriesUi,
    this.hiTypes,
    this.period,
    this.status,
    this.purpose,
  });

  Hiu? hip;
  List<String>? categories;

  // List<String>? categoriesUi;
  List<String>? hiTypes;
  PeriodHealthLocker? period;
  String? status;
  IncludedSourcePurpose? purpose;

  factory SubscriptionIncludedSource.fromMap(Map<String, dynamic> json) =>
      SubscriptionIncludedSource(
        hip: json['hip'] != null ? Hiu.fromMap(json['hip']) : null,
        categories: json['categories'] != null
            ? List<String>.from(json['categories'].map((x) => x))
            : null,
        hiTypes: json['hiTypes'] != null
            ? List<String>.from(json['hiTypes'].map((x) => x))
            : null,
        period: json['period'] != null
            ? PeriodHealthLocker.fromMap(json['period'])
            : null,
        status: json['status'],
        purpose: json['purpose'] == null
            ? null
            : IncludedSourcePurpose.fromMap(json['purpose']),
      );

  Map<String, dynamic> toMap() => {
        'hip': hip?.toMap(),
        'categories': List<dynamic>.from(categories!.map((x) => x)),
        'hiTypes': List<dynamic>.from(hiTypes!.map((x) => x)),
        'period': period?.toMap(),
        'status': status,
        'purpose': purpose == null ? null : purpose!.toMap(),
      };
}

enum Category { link, data }

final categoryValues =
    EnumValues({'DATA': Category.data, 'LINK': Category.link});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map?.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class SubscriptionRequest {
  String? requestId;
  String? subscriptionId;
  String? patientId;
  String? requesterType;
  String? status;
  Details? details;
  String? dateCreated;
  String? dateModified;

  SubscriptionRequest({
    this.requestId,
    this.subscriptionId,
    this.patientId,
    this.requesterType,
    this.status,
    this.details,
    this.dateCreated,
    this.dateModified,
  });

  SubscriptionRequest.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    subscriptionId = json['subscriptionId'];
    patientId = json['patientId'];
    requesterType = json['requesterType'];
    status = json['status'];
    details =
        json['details'] != null ? Details.fromJson(json['details']) : null;
    dateCreated = json['dateCreated'];
    dateModified = json['dateModified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['subscriptionId'] = subscriptionId;
    data['patientId'] = patientId;
    data['requesterType'] = requesterType;
    data['status'] = status;
    if (details != null) {
      data['details'] = details!.toJson();
    }
    data['dateCreated'] = dateCreated;
    data['dateModified'] = dateModified;
    return data;
  }
}

class Details {
  String? subscriptionRequestId;
  IncludedSourcePurpose? purpose;
  Patient? patient;
  Hiu? hiu;
  Hiu? hips;
  List<String>? categories;
  PeriodHealthLocker? period;

  Details({
    this.subscriptionRequestId,
    this.purpose,
    this.patient,
    this.hiu,
    this.hips,
    this.categories,
    this.period,
  });

  Details.fromJson(Map<String, dynamic> json) {
    subscriptionRequestId = json['subscriptionRequestId'];
    purpose = json['purpose'] != null
        ? IncludedSourcePurpose.fromMap(json['purpose'])
        : null;
    patient = json['patient'] != null ? Patient.fromMap(json['patient']) : null;
    hiu = json['hiu'] != null ? Hiu.fromMap(json['hiu']) : null;
    hips = json['hips'];
    categories = json['categories'].cast<String>();
    period = json['period'] != null
        ? PeriodHealthLocker.fromMap(json['period'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscriptionRequestId'] = subscriptionRequestId;
    if (purpose != null) {
      data['purpose'] = purpose!.toMap();
    }
    if (patient != null) {
      data['patient'] = patient!.toMap();
    }
    if (hiu != null) {
      data['hiu'] = hiu!.toMap();
    }
    data['hips'] = hips;
    data['categories'] = categories;
    if (period != null) {
      data['period'] = period!.toMap();
    }
    return data;
  }
}
