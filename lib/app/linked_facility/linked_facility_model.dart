// To parse this JSON data, do
//
//     final linkFacilityModel = linkFacilityModelFromMap(jsonString);

import 'dart:convert';

LinkedFacilityModel linkFacilityModelFromMap(String str) {
  Map<String, dynamic> data = json.decode(str);
  if (data.isEmpty) {
    return LinkedFacilityModel();
  } else {
    return LinkedFacilityModel.fromMap(data);
  }
}

String linkFacilityModelToMap(LinkedFacilityModel data) =>
    json.encode(data.toMap());

class LinkedFacilityModel {
  LinkedFacilityModel({
    this.patient,
  });

  Patient? patient;

  factory LinkedFacilityModel.fromMap(Map<String, dynamic> json) =>
      LinkedFacilityModel(
        patient: Patient.fromMap(json['patient']),
      );

  Map<String, dynamic> toMap() => {
        'patient': patient?.toMap(),
      };
}

class Patient {
  Patient({
    this.id,
    this.links,
  });

  String? id;
  List<LinkFacilityLinkedData>? links;

  factory Patient.fromMap(Map<String, dynamic> json) => Patient(
        id: json['id'],
        links: json['links'] != null
            ? List<LinkFacilityLinkedData>.from(
                json['links'].map((x) => LinkFacilityLinkedData.fromMap(x)),
              )
            : null,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'links': List<dynamic>.from(links!.map((x) => x.toMap())),
      };
}

class LinkFacilityLinkedData {
  LinkFacilityLinkedData({
    this.hip,
    this.referenceNumber,
    this.display,
    this.careContexts,
  });

  Hip? hip;

  String? referenceNumber;
  String? display;
  List<LinkFacilityCareContext>? careContexts;

  factory LinkFacilityLinkedData.fromMap(Map<String, dynamic> json) =>
      LinkFacilityLinkedData(
        hip: Hip.fromMap(json['hip']),
        referenceNumber: json['referenceNumber'],
        display: json['display'],
        careContexts: List<LinkFacilityCareContext>.from(
          json['careContexts'].map((x) => LinkFacilityCareContext.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
        'hip': hip?.toMap(),
        'referenceNumber': referenceNumber,
        'display': display,
        'careContexts': List<dynamic>.from(careContexts!.map((x) => x.toMap())),
      };

  String? get hipId => hip?.id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is LinkFacilityLinkedData &&
            runtimeType == other.runtimeType &&
            hip == other.hip;
  }

  @override
  int get hashCode => hip.hashCode;
}

class LinkFacilityCareContext {
  LinkFacilityCareContext({
    this.referenceNumber,
    this.display,
  });

  String? referenceNumber;
  String? display;

  factory LinkFacilityCareContext.fromMap(Map<String, dynamic> json) =>
      LinkFacilityCareContext(
        referenceNumber: json['referenceNumber'],
        display: json['display'],
      );

  Map<String, dynamic> toMap() => {
        'referenceNumber': referenceNumber,
        'display': display,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Hip && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
