import 'package:abha/export_packages.dart';

abstract class ProfileRepo {
  Future<Map> onMyProfile();
  Future<Map> onEmailMobileOtpGen(Map emailUpdateData);
  Future<Map> onEmailMobileOtpVerify(Map emailUpdateData);
  // Future<Map> onMobileEmailResentOtp(Map mobileEmailResentOtpData);
  Future<List> onGetStates();
  Future<Map> onGetSwitchAccountUsers();
  Future<Map> onVerifySwitchUser(Map switchUser, String tToken);
  Future<List> onGetDistricts(String stateCode);
  Future<Map> onUpdateUserProfile(Map updateProfileData);
  Future<dynamic> onDownloadQrCode();
}

class ProfileRepoImpl extends BaseRepo implements ProfileRepo {
  ProfileRepoImpl() : super(ProfileRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<Map> onMyProfile() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.profileMeApi,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onEmailMobileOtpGen(Map emailUpdateData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.profileEmailMobileOtpReq,
      dataPayload: emailUpdateData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onEmailMobileOtpVerify(Map data) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.profileEmailMobileOtpVerify,
      dataPayload: data,
    );
    return Future.value(response?.data ?? {});
  }

  // @override
  // Future<Map> onMobileEmailResentOtp(Map mobileEmailResentOtpData) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.mobileEmailResendOtpApi,
  //     dataPayload: mobileEmailResentOtpData,
  //   );
  //   return Future.value(response?.data??{});
  // }

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
  Future<Map> onUpdateUserProfile(Map updateProfileData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.profileUpdate,
      dataPayload: updateProfileData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<dynamic> onDownloadQrCode() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.profileQrCodeApi,
      options: Options(responseType: ResponseType.bytes),
    );
    return Future.value(response?.data);
  }

  @override
  Future<Map> onGetSwitchAccountUsers() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.switchProfile,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onVerifySwitchUser(Map switchUser, String tToken) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.verifySwitchProfileUser,
      dataPayload: switchUser,
      options: Options(headers: {ApiKeys.headersKeys.tToken: 'Bearer $tToken'}),
    );
    return Future.value(response?.data ?? {});
  }
}
