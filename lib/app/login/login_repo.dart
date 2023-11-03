import 'package:abha/export_packages.dart';

abstract class LoginRepo {
  Future<Map> onOtpGenerate(Map mobileEmailAuthInitData);
  Future<Map> onVerifyData(Map otpVerifyData);
  Future<Map> onVerifyUser(Map data);
  Future<Map> onSearchAbhaAddress(Map abhaAddressAuthConfirmData);
}

class LoginRepoImpl extends BaseRepo implements LoginRepo {
  LoginRepoImpl() : super(LoginRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<Map> onOtpGenerate(Map mobileEmailAuthInitData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.otpGenApi,
      dataPayload: mobileEmailAuthInitData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onVerifyData(Map data) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.verifyApi,
      dataPayload: data,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onVerifyUser(Map verifyAbhaAddressUserData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.loginVerifyUserApi,
      dataPayload: verifyAbhaAddressUserData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onSearchAbhaAddress(Map abhaAddressAuthConfirmData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.loginSearchAbhaAddressApi,
      dataPayload: abhaAddressAuthConfirmData,
    );
    return Future.value(response?.data ?? {});
  }
}
