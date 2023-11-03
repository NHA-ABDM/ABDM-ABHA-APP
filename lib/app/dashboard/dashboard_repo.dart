import 'package:abha/export_packages.dart';

abstract class DashboardRepo {
  dynamic onSession(Map sessionData);

  Future<Map> onXToken();

  Future<Map> onXAuthToken(Map userData);

  Future<Map> onSetConsentAutoApprovalPolicy(Map autoApprovalPolicyData);

  Future<Map> onSendDeviceToken(Map deviceTokenData);

  Future<Map> onLogout();

  Future<Map> onRefreshXToken();
}

class DashboardRepoImpl extends BaseRepo implements DashboardRepo {
  DashboardRepoImpl() : super(DashboardRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  dynamic onSession(Map sessionData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.sessionApi,
      options: Options(),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onXToken() async {
    Response response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.refreshApiHeaderToken,
    );
    return Future.value(response.data);
  }

  @override
  Future<Map> onXAuthToken(Map userData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.xAuthToken,
      options: Options(
        headers: {
          ApiKeys.headersKeys.requesterId:
              abhaSingleton.getAppConfig.getConfigData()[AppConfig.requesterId],
        },
      ),
      dataPayload: userData,
    );
    return Future.value(response?.data ?? []);
  }

  @override
  Future<Map> onSetConsentAutoApprovalPolicy(Map autoApprovalPolicyData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.consentAutoApproveForHiuApi,
      dataPayload: autoApprovalPolicyData,
    );
    return Future.value(response?.data ?? []);
  }

  @override
  Future<Map> onSendDeviceToken(Map deviceTokenData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.deviceToken,
      dataPayload: deviceTokenData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onLogout() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.logout,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onRefreshXToken() async {
    String rToken = await abhaSingleton.getSharedPref
        .get(SharedPref.apiRHeaderToken, defaultValue: '');
    Response response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.refreshApiHeaderToken,
      options: Options(headers: {ApiKeys.headersKeys.rToken: 'Bearer $rToken'}),
    );
    return Future.value(response.data);
  }
}
