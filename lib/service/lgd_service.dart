import 'package:abha/export_packages.dart';

abstract class LGDService {
  Future<List> onGetStates();

  Future<List> onGetDistricts(String stateCode);

  Future<dynamic> validateLGDDetails(String pinCode);
}

class LGDServiceImpl extends LGDService {
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<List> onGetStates() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.statesApi,
    );
    return Future.value(response?.data ?? []);
  }

  @override
  Future<List> onGetDistricts(String stateCode) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.districtsApi,
      dataPayload: {ApiKeys.requestKeys.stateCode: stateCode},
    );
    return Future.value(response?.data ?? []);
  }

  @override
  Future<dynamic> validateLGDDetails(String pinCode) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.validatePinCodeApi,
      dataPayload: {ApiKeys.requestKeys.pinCode: pinCode},
    );
    return Future.value(response?.data[0]);
  }
}

class LGDDetails {
  int? pinCode;
  int? districtCode;
  String? districtName;
  int? stateCode;
  String? stateName;

  LGDDetails({this.pinCode, this.districtCode, this.districtName, this.stateCode, this.stateName});

  LGDDetails.fromJson(Map<String, dynamic> json) {
    pinCode = json['pinCode'];
    districtCode = json['districtCode'];
    districtName = json['districtName'];
    stateCode = json['stateCode'];
    stateName = json['stateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pinCode'] = pinCode;
    data['districtCode'] = districtCode;
    data['districtName'] = districtName;
    data['stateCode'] = stateCode;
    data['stateName'] = stateName;
    return data;
  }
}
