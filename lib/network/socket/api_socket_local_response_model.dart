import 'package:abha/network/api_keys.dart';

class ApiSocketLocalResponseModel {
  String? data;

  ApiSocketLocalResponseModel({
    this.data,
  });

  ApiSocketLocalResponseModel.fromJson(Map<String, dynamic> json) {
    data = json[ApiKeys.responseKeys.data];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData[ApiKeys.responseKeys.data] = data;
    return jsonData;
  }
}
