import 'package:abha/export_packages.dart';

class StateEntry extends LocalSearch {
  StateEntry({
    required this.stateCode,
    this.stateName,
  });

  String? stateName;
  int stateCode;

  factory StateEntry.fromMap(Map<String, dynamic> json) => StateEntry(
        stateName: json['stateName'],
        stateCode: json['stateCode'],
      );

  Map<String, dynamic> toMap() => {
        'stateName': stateName,
        'stateCode': stateCode,
      };

  @override
  String toString() {
    return '${stateName?.toTitleCase()}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StateEntry &&
          runtimeType == other.runtimeType &&
          stateName == other.stateName;

  @override
  int get hashCode => stateName.hashCode;

  @override
  int get id => stateCode;

  @override
  String get title => '${stateName?.toTitleCase()}';
}

class DistrictEntry extends LocalSearch {
  DistrictEntry({
    required this.districtCode,
    this.districtName,
  });

  String? districtName;
  int districtCode;

  factory DistrictEntry.fromMap(Map<String, dynamic> json) => DistrictEntry(
        districtName: json['districtName'],
        districtCode: json['districtCode'],
      );

  Map<String, dynamic> toMap() => {
        'districtName': districtName,
        'districtCode': districtCode,
      };

  @override
  int get id => districtCode;

  @override
  String get title => '${districtName?.toTitleCase()}';

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is DistrictEntry &&
            runtimeType == other.runtimeType &&
            (districtName?.toLowerCase() == other.districtName?.toLowerCase() || districtCode == other.districtCode );
  }

  @override
  String toString() {
    return '${districtName?.toTitleCase()}';
  }

  @override
  int get hashCode {
    return districtName.hashCode;
  }
}

class RegistrationAbhaAuthModesEntry {
  RegistrationAbhaAuthModesEntry({
    this.authMethods,
    this.blockedAuthMethods,
    this.healthIdNumber,
    this.status,
  });

  List<String>? authMethods;
  List<String>? blockedAuthMethods;
  String? healthIdNumber;
  String? status;

  factory RegistrationAbhaAuthModesEntry.fromMap(Map<String, dynamic> json) =>
      RegistrationAbhaAuthModesEntry(
        authMethods: json['authMethods'],
        blockedAuthMethods: json['blockedAuthMethods'],
        healthIdNumber: json['healthIdNumber'],
        status: json['status'],
      );

  Map<String, dynamic> toMap() => {
        'authMethods': authMethods,
        'blockedAuthMethods': blockedAuthMethods,
        'healthIdNumber': healthIdNumber,
        'status': status,
      };
}

abstract class LocalSearch {
  late int _id;
  late String _title;

  LocalSearch({String? id, String? title});

  String get title => _title;

  int get id => _id;
}
