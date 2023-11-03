import 'package:abha/network/api_keys.dart';

class RouteParam {
  static const String consentIdParamKey = 'consentId';
  static const String healthLockerIdParamKey = 'healthLockerId';
  static const String uhiIdParamKey = 'uhiId';
}

class RouteQueryParam {
  static String counterIdKey = ApiKeys.responseKeys.counterId;
  static String hipIdKey = ApiKeys.responseKeys.hip_id;
}
