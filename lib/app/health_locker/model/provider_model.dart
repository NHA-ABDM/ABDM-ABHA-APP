// To parse this JSON data, do
//
//     final providerModel = providerModelFromMap(jsonString);

import 'dart:convert';

List<ProviderModel> providerModelFromMap(String str) =>
    List<ProviderModel>.from(
      json.decode(str).map((x) => ProviderModel.fromMap(x)),
    );

String providerModelToMap(List<ProviderModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ProviderModel {
  Identifier identifier;
  List<String> facilityType;
  bool? isHip;
  bool? isGovtEntity;
  // Attributes? attributes;
  Endpoints? endpoints;

  ProviderModel({
    required this.identifier,
    required this.facilityType,
    required this.isHip,
    required this.isGovtEntity,
    // this.attributes,
    this.endpoints,
  });

  factory ProviderModel.fromMap(Map<String, dynamic> json) => ProviderModel(
        identifier: Identifier.fromMap(json['identifier']),
        facilityType: List<String>.from(json['facilityType'].map((x) => x)),
        isHip: json['isHIP'],
        isGovtEntity: json['isGovtEntity'],
        // attributes: json['attributes'] == null
        //     ? null
        //     : Attributes.fromMap(json['attributes']),
        endpoints: json['endpoints'] != null
            ? Endpoints.fromJson(json['endpoints'])
            : null,
      );

  Map<String, dynamic> toMap() => {
        'identifier': identifier.toMap(),
        'facilityType': List<dynamic>.from(facilityType.map((x) => x)),
        'isHIP': isHip,
        'isGovtEntity': isGovtEntity,
        // 'attributes': attributes?.toMap(),
        'endpoints': endpoints!.toJson(),
      };
}

class Attributes {
  HipAttributes? hipAttributes;

  Attributes({
    this.hipAttributes,
  });

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
        hipAttributes: json['hipAttributes'] == null
            ? null
            : HipAttributes.fromMap(json['hipAttributes']),
      );

  Map<String, dynamic> toMap() => {
        'hipAttributes': hipAttributes?.toMap(),
      };
}

class HipAttributes {
  String? discoveryAdditionalFieldLabel;

  HipAttributes({
    this.discoveryAdditionalFieldLabel,
  });

  factory HipAttributes.fromMap(Map<String, dynamic> json) => HipAttributes(
        discoveryAdditionalFieldLabel: json['discoveryAdditionalFieldLabel'],
      );

  Map<String, dynamic> toMap() => {
        'discoveryAdditionalFieldLabel': discoveryAdditionalFieldLabel,
      };
}

class Identifier {
  String name;
  String id;

  Identifier({
    required this.name,
    required this.id,
  });

  factory Identifier.fromMap(Map<String, dynamic> json) => Identifier(
        name: json['name'],
        id: json['id'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };
}

class Endpoints {
  List<HealthLockerEndpoints>? healthLockerEndpoints;

  Endpoints({this.healthLockerEndpoints});

  Endpoints.fromJson(Map<String, dynamic> json) {
    if (json['healthLockerEndpoints'] != null) {
      healthLockerEndpoints = <HealthLockerEndpoints>[];
      json['healthLockerEndpoints'].forEach((v) {
        healthLockerEndpoints!.add(HealthLockerEndpoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (healthLockerEndpoints != null) {
      data['healthLockerEndpoints'] =
          healthLockerEndpoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class HealthLockerEndpoints {
  String? use;
  String? connectionType;
  String? address;

  HealthLockerEndpoints({this.use, this.connectionType, this.address});

  HealthLockerEndpoints.fromJson(Map<String, dynamic> json) {
    use = json['use'];
    connectionType = json['connectionType'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['use'] = use;
    data['connectionType'] = connectionType;
    data['address'] = address;
    return data;
  }
}
