import 'package:abha/export_packages.dart';

abstract class RegistrationRepo {
  Future<Map> onMobileEmailGenerateOtp(Map mobileEmailGenerateOtpData);
  Future<Map> onMobileEmailValidateOtp(Map mobileEmailValidateOtpData);
  Future<List> onGetStates();
  Future<List> onGetDistricts(String stateCode);
  Future<Map> onGetSuggestedAbhaAddress(Map getSuggestedAbhaAddressData);
  Future<dynamic> onIsAbhaExist(String abhaAddress);
  Future<Map> onRegistrationAbhaFormSubmission(
    Map registrationAbhaFormSubmissionData,
  );
  Future<Map> onAbhaRequestOtp(Map abhaOtpRequestData);
  Future<Map> onAbhaVerifyOtp(Map abhaOtpVerifyData);
  Future<Map> onLoginFromRegistrationAbha(
    Map abhaAddressData,
  );
}

class RegistrationRepoImpl extends BaseRepo implements RegistrationRepo {
  RegistrationRepoImpl() : super(RegistrationRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<Map> onMobileEmailGenerateOtp(Map mobileEmailGenerateOtpData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.mobileEmailGenerateOtpApi,
      dataPayload: mobileEmailGenerateOtpData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onMobileEmailValidateOtp(Map mobileEmailValidateOtpData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.mobileEmailValidateOtpApi,
      dataPayload: mobileEmailValidateOtpData,
    );
    return Future.value(response?.data ?? {});
  }

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
  Future<Map> onGetSuggestedAbhaAddress(Map getSuggestedAbhaAddressData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaAddressSuggestionApi,
      dataPayload: getSuggestedAbhaAddressData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<dynamic> onIsAbhaExist(String abhaAddress) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: '${ApiPath.isAbhaExistsApi}=$abhaAddress',
    );
    return Future.value(response?.data ?? true);
  }

  @override
  Future<Map> onRegistrationAbhaFormSubmission(
    Map registrationAbhaFormSubmissionData,
  ) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.enrollAbhaAddressApi,
      dataPayload: registrationAbhaFormSubmissionData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onAbhaRequestOtp(Map<dynamic, dynamic> abhaOtpRequestData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaRequestOtpApi,
      dataPayload: abhaOtpRequestData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onAbhaVerifyOtp(Map<dynamic, dynamic> abhaOtpVerifyData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaVerifyOtpApi,
      dataPayload: abhaOtpVerifyData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onLoginFromRegistrationAbha(Map abhaAddressData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.loginVerifyUserApi,
      dataPayload: abhaAddressData,
    );
    return Future.value(response?.data ?? {});
  }
}
