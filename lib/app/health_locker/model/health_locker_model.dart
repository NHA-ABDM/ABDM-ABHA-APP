// To parse this JSON data, do
//
//     final healthLockerModel = healthLockerModelFromMap(jsonString);

import 'dart:convert';

HealthLockerModel healthLockerModelFromMap(String str) {
  Map<String, dynamic> data = json.decode(str);
  if (data.isEmpty) {
    return HealthLockerModel();
  } else {
    return HealthLockerModel.fromMap(data);
  }
}

String healthLockerModelToMap(HealthLockerModel data) =>
    json.encode(data.toMap());

class HealthLockerModel {
  HealthLockerModel({
    this.offset,
    this.limit,
    this.size,
    this.services,
  });

  int? offset;
  int? limit;
  int? size;
  List<Service>? services;

  factory HealthLockerModel.fromMap(Map<String, dynamic> json) =>
      HealthLockerModel(
        offset: json['offset'],
        limit: json['limit'],
        size: json['size'],
        services:
            List<Service>.from(json['services'].map((x) => Service.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'offset': offset,
        'limit': limit,
        'size': size,
        'services': List<dynamic>.from(services!.map((x) => x.toMap())),
      };
}

class Service {
  Service({
    this.id,
    this.name,
    this.type,
    this.active,
    this.endpoints,
  });

  String? id;
  String? name;
  LockerType? type;
  bool? active;
  List<Endpoint>? endpoints;

  factory Service.fromMap(Map<String, dynamic> json) => Service(
        id: json['id'],
        name: json['name'],
        type: typeValues.map[json['type']],
        active: json['active'],
        endpoints: json['endpoints'] == null
            ? null
            : List<Endpoint>.from(
                json['endpoints'].map((x) => Endpoint.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'type': typeValues.reverse?[type],
        'active': active,
        'endpoints': endpoints == null
            ? null
            : List<dynamic>.from(endpoints!.map((x) => x.toMap())),
      };
}

class Endpoint {
  Endpoint({
    this.use,
    this.connectionType,
    this.address,
  });

  Use? use;
  ConnectionType? connectionType;
  String? address;

  factory Endpoint.fromMap(Map<String, dynamic> json) => Endpoint(
        use: useValues.map[json['use']],
        connectionType: connectionTypeValues.map[json['connectionType']],
        address: json['address'],
      );

  Map<String, dynamic> toMap() => {
        'use': useValues.reverse![use],
        'connectionType': connectionTypeValues.reverse![connectionType],
        'address': address,
      };
}

enum ConnectionType { https, app }

final connectionTypeValues =
    EnumValues({'APP': ConnectionType.app, 'HTTPS': ConnectionType.https});

enum Use { registration, dataUpload }

final useValues = EnumValues(
  {'data-upload': Use.dataUpload, 'registration': Use.registration},
);

enum LockerType { healthLocker }

final typeValues = EnumValues({'HEALTH_LOCKER': LockerType.healthLocker});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap;
    return reverseMap;
  }
}

List<HealthLockerConnectedModel> healthLockerConnectedModelFromMap(
  String str,
) {
  List data = json.decode(str);
  if (data.isEmpty) {
    return [];
  } else {
    return List<HealthLockerConnectedModel>.from(
      json.decode(str).map((x) => HealthLockerConnectedModel.fromMap(x)),
    );
  }
}

String healthLockerConnectedModelToMap(List<HealthLockerConnectedModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class HealthLockerConnectedModel {
  HealthLockerConnectedModel({
    this.patientId,
    this.lockerId,
    this.lockerName,
    this.active,
    this.dateCreated,
    this.dateModified,
    this.endpoints,
  });

  String? patientId;
  String? lockerId;
  String? lockerName;
  bool? active;
  DateTime? dateCreated;
  DateTime? dateModified;
  List<Endpoint>? endpoints;

  factory HealthLockerConnectedModel.fromMap(Map<String, dynamic> json) =>
      HealthLockerConnectedModel(
        patientId: json['patientId'],
        lockerId: json['lockerId'],
        lockerName: json['lockerName'],
        active: json['active'],
        dateCreated: DateTime.parse(json['dateCreated']),
        dateModified: DateTime.parse(json['dateModified']),
        endpoints: json['endpoints'] == null
            ? null
            : List<Endpoint>.from(
                json['endpoints'].map((x) => Endpoint.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'patientId': patientId,
        'lockerId': lockerId,
        'lockerName': lockerName,
        'active': active,
        'dateCreated': dateCreated!.toIso8601String(),
        'dateModified': dateModified!.toIso8601String(),
        'endpoints': endpoints == null
            ? null
            : List<dynamic>.from(endpoints!.map((x) => x.toMap())),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthLockerConnectedModel &&
          runtimeType == other.runtimeType &&
          lockerId == other.lockerId;

  @override
  int get hashCode => lockerId.hashCode;
}
