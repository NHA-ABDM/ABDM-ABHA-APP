import 'package:abha/export_packages.dart';
import 'package:get/get_utils/get_utils.dart';

class ConsentSubscriptionRequestModel {
  String? status;
  String? createdAt;
  Purpose? purpose;
  Hiu? hiu;
  String? requesterType;
  String lastUpdated = '';
  List<String>? categories;
  Period? period;
  String? subscriptionId;

  ConsentSubscriptionRequestModel({
    required this.lastUpdated,
    this.status,
    this.createdAt,
    this.purpose,
    this.hiu,
    this.requesterType,
    this.categories,
    this.period,
    this.subscriptionId,
  });

  ConsentSubscriptionRequestModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdAt = json['createdAt'];
    purpose =
        json['purpose'] != null ? Purpose.fromJson(json['purpose']) : null;

    hiu = json['hiu'] != null ? Hiu.fromJson(json['hiu']) : null;
    if (json['categories'] != null) {
      categories = <String>[];
      json['categories'].forEach((v) {
        categories!.add(v);
      });
    }

    period = json['period'] != null ? Period.fromJson(json['period']) : null;
    lastUpdated = json['lastUpdated'];
    subscriptionId = json['subscriptionId'];
    requesterType = json['requesterType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['createdAt'] = createdAt;
    if (purpose != null) {
      data['purpose'] = purpose!.toJson();
    }

    if (hiu != null) {
      data['hiu'] = hiu!.toJson();
    }

    data['lastUpdated'] = lastUpdated;
    data['subscriptionId'] = subscriptionId;
    return data;
  }
}

class ConsentRequestModel {
  String? id;
  String? status;
  String? createdAt;
  Purpose? purpose;
  Patient? patient;
  Hip? hip;
  Hiu? hiu;
  late List<CareContexts> careContexts;
  Requester? requester;
  List<HealthInfoTypes>? hiTypes;
  Permission? permission;
  late String lastUpdated;
  Period? period;
  String? requesterType;
  String? subscriptionId;
  String? patientId;
  late List<LinkFacilityLinkedData>? links;

  ConsentRequestModel({
    this.id,
    this.status,
    this.createdAt,
    this.purpose,
    this.patient,
    this.hip,
    this.hiu,
    this.careContexts = const [],
    this.requester,
    this.hiTypes,
    this.permission,
    this.lastUpdated = '',
    this.period,
    this.requesterType,
    this.subscriptionId,
    this.patientId,
    this.links = const [],
  });

  ConsentRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? json['requestId'];
    status = json['status'];
    createdAt = json['createdAt'];
    purpose =
        json['purpose'] != null ? Purpose.fromJson(json['purpose']) : null;
    patient = json['patient'] != null ? Patient.fromMap(json['patient']) : null;
    hip = json['hip'] != null ? Hip.fromMap(json['hip']) : null;
    hiu = json['hiu'] != null ? Hiu.fromJson(json['hiu']) : null;
    careContexts = <CareContexts>[];
    if (json['careContexts'] != null) {
      careContexts = <CareContexts>[];
      json['careContexts'].forEach((v) {
        careContexts.add(CareContexts.fromJson(v));
      });
    }
    requester = json['requester'] != null
        ? Requester.fromJson(json['requester'])
        : null;
    if (json['hiTypes'] != null) {
      hiTypes = <HealthInfoTypes>[];
      json['hiTypes'].forEach((v) {
        hiTypes!.add(HealthInfoTypes.fromType(v));
      });
    }
    permission = json['permission'] != null
        ? Permission.fromJson(json['permission'])
        : null;
    period = json['period'] != null ? Period.fromJson(json['period']) : null;
    lastUpdated = json['lastUpdated'];
    requesterType = json['requesterType'];
    subscriptionId = json['subscriptionId'];
    patientId = json['patientId'];
    links = <LinkFacilityLinkedData>[];
    if (json['links'] != null) {
      links = <LinkFacilityLinkedData>[];
      json['links'].forEach((v) {
        links!.add(LinkFacilityLinkedData.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['createdAt'] = createdAt;
    if (purpose != null) {
      data['purpose'] = purpose!.toJson();
    }
    if (patient != null) {
      data['patient'] = patient!.toMap();
    }
    data['hip'] = hip;
    if (hiu != null) {
      data['hiu'] = hiu!.toJson();
    }
    data['careContexts'] = careContexts.map((v) => v.toJson()).toList();
    if (requester != null) {
      data['requester'] = requester!.toJson();
    }
    data['hiTypes'] = hiTypes;
    if (permission != null) {
      data['permission'] = permission!.toJson();
    }
    if (period != null) {
      data['period'] = period!.toJson();
    }
    data['lastUpdated'] = lastUpdated;
    data['requesterType'] = requesterType;
    data['subscriptionId'] = subscriptionId;
    data['patientId'] = patientId;
    data['links'] = links!.map((v) => v.toMap()).toList();
    return data;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsentRequestModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class Purpose {
  String? text;
  String? code;
  String? refUri;

  Purpose({this.text, this.code, this.refUri});

  Purpose.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    code = json['code'];
    refUri = json['refUri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['code'] = code;
    data['refUri'] = refUri;
    return data;
  }
}

class Hiu {
  String? id;
  String? name;

  Hiu({this.id, this.name});

  Hiu.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Requester {
  String? name;
  Identifier? identifier;
  String? type;
  String? id;

  Requester({this.name, this.identifier, this.type, this.id});

  Requester.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    id = json['id'];
    identifier = json['identifier'] != null
        ? Identifier.fromJson(json['identifier'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['id'] = id;
    if (identifier != null) {
      data['identifier'] = identifier!.toJson();
    }
    return data;
  }
}

class Identifier {
  String? value;
  String? name;
  String? system;

  Identifier({this.value, this.name, this.system});

  Identifier.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    name = json['name'];
    system = json['system'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    data['name'] = name;
    data['system'] = system;
    return data;
  }
}

class Permission {
  String? accessMode;
  DateRange? dateRange;
  String? dataEraseAt;
  Frequency? frequency;

  Permission({
    this.accessMode,
    this.dateRange,
    this.dataEraseAt,
    this.frequency,
  });

  Permission.fromJson(Map<String, dynamic> json) {
    accessMode = json['accessMode'];
    dateRange = json['dateRange'] != null
        ? DateRange.fromJson(json['dateRange'])
        : null;
    dataEraseAt = json['dataEraseAt'];
    frequency = json['frequency'] != null
        ? Frequency.fromJson(json['frequency'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accessMode'] = accessMode;
    if (dateRange != null) {
      data['dateRange'] = dateRange!.toJson();
    }
    data['dataEraseAt'] =
        DateTime.parse(dataEraseAt!).toUtc().toIso8601String();
    if (frequency != null) {
      data['frequency'] = frequency!.toJson();
    }
    return data;
  }
}

class DateRange {
  String? from;
  String? to;

  DateRange({this.from, this.to});

  DateRange.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = DateTime.parse(from!).toUtc().toIso8601String();
    data['to'] = DateTime.parse(to!).toUtc().toIso8601String();
    return data;
  }
}

class Frequency {
  String? unit;
  int? value;
  int? repeats;

  Frequency({this.unit, this.value, this.repeats});

  Frequency.fromJson(Map<String, dynamic> json) {
    unit = json['unit'];
    value = json['value'];
    repeats = json['repeats'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['unit'] = unit;
    data['value'] = value;
    data['repeats'] = repeats;
    return data;
  }
}

class HealthInfoTypes {
  String? type;
  late bool check;
  String? name;

  HealthInfoTypes({this.type, this.check = true, this.name});

  HealthInfoTypes.fromType(String data) {
    type = data.camelCase;
    check = true;
    name = data;
  }

  HealthInfoTypes.copy(HealthInfoTypes healthType)
      : type = healthType.type,
        check = healthType.check,
        name = healthType.name;
}

class CareContexts {
  String? patientReference;
  String? careContextReference;

  CareContexts({this.patientReference, this.careContextReference});

  CareContexts.fromJson(Map<String, dynamic> json) {
    patientReference = json['patientReference'];
    careContextReference = json['careContextReference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['patientReference'] = patientReference;
    data['careContextReference'] = careContextReference;
    return data;
  }
}

class Period {
  String? from;
  String? to;

  Period({this.from, this.to});

  Period.fromJson(Map<String, dynamic> json) {
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['from'] = from;
    data['to'] = to;
    return data;
  }
}
