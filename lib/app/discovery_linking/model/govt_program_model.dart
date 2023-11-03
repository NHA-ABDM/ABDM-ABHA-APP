class GovtProgramModel {
  GovtProgramModel({
    this.identifier,
    // this.telephone,
    // this.city,
    // this.latitude,
    // this.longitude,
    // this.address,
    // this.districtCode,
    // this.stateCode,
    // this.pinCode,
    this.facilityType,
    this.isHip,
    this.isGovtEntity,
    this.attributes,
  });

  Identifier? identifier;
  // String? telephone;
  // String? city;
  // String? latitude;
  // String? longitude;
  // String? address;
  // String? districtCode;
  // String? stateCode;
  // String? pinCode;
  List<String>? facilityType;
  bool? isHip;
  bool? isGovtEntity;
  Attributes? attributes;

  factory GovtProgramModel.fromMap(Map<String, dynamic> json) =>
      GovtProgramModel(
        identifier: Identifier.fromMap(json['identifier']),
        // telephone: json['telephone'],
        // city: json['city'],
        // latitude: json['latitude'],
        // longitude: json['longitude'],
        // address: json['address'],
        // districtCode: json['districtCode'],
        // stateCode: json['stateCode'],
        // pinCode: json['pinCode'],
        facilityType: List<String>.from(json['facilityType'].map((x) => x)),
        isHip: json['isHIP'],
        isGovtEntity: json['isGovtEntity'],
        attributes: Attributes.fromMap(json['attributes']),
      );

  Map<String, dynamic> toMap() => {
        'identifier': identifier?.toMap(),
        // 'telephone': telephone,
        // 'city': city,
        // 'latitude': latitude,
        // 'longitude': longitude,
        // 'address': address,
        // 'districtCode': districtCode,
        // 'stateCode': stateCode,
        // 'pinCode': pinCode,
        'facilityType': List<dynamic>.from(facilityType?.map((x) => x) as List),
        'isHIP': isHip,
        'isGovtEntity': isGovtEntity,
        'attributes': attributes?.toMap(),
      };
}

class Attributes {
  Attributes({
    this.hipAttributes,
    this.hiuAttributes,
    this.healthLockerAttributes,
  });

  HipAttributes? hipAttributes;
  String? hiuAttributes;
  String? healthLockerAttributes;

  factory Attributes.fromMap(Map<String, dynamic> json) => Attributes(
        hipAttributes: json['hipAttributes'] == null
            ? null
            : HipAttributes.fromMap(json['hipAttributes']),
        hiuAttributes: json['hiuAttributes'],
        healthLockerAttributes: json['healthLockerAttributes'],
      );

  Map<String, dynamic> toMap() => {
        'hipAttributes': hipAttributes?.toMap(),
        'hiuAttributes': hiuAttributes,
        'healthLockerAttributes': healthLockerAttributes,
      };
}

class HipAttributes {
  HipAttributes({
    this.discoveryAdditionalFieldLabel,
  });

  String? discoveryAdditionalFieldLabel;

  factory HipAttributes.fromMap(Map<String, dynamic> json) => HipAttributes(
        discoveryAdditionalFieldLabel: json['discoveryAdditionalFieldLabel'],
      );

  Map<String, dynamic> toMap() => {
        'discoveryAdditionalFieldLabel': discoveryAdditionalFieldLabel,
      };
}

class Identifier {
  Identifier({
    this.name,
    this.id,
  });

  String? name;
  String? id;

  factory Identifier.fromMap(Map<String, dynamic> json) => Identifier(
        name: json['name'],
        id: json['id'],
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'id': id,
      };
}
