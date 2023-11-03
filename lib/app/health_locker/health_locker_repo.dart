import 'package:abha/export_packages.dart';

abstract class HealthLockerRepo {
  Future<List> callConnectedLockerList();
  Future<List> callAllLockerList();
  Future<Map> callIndividualLockerInfoAPI(String lockerId);
  Future<dynamic> fetchLinks();
  Future<dynamic> addLocker();
  Future<dynamic> changeAutoApprovalPolicy(String autoApprovalId, bool enable);
  Future<Map> getAuthorizationDetail(String authRequestId);
  Future<Map> getRevokedAuthRequest(String revokedRequestId);
  Future<Map> getSubscriptionDetail(String subscriptionRequestId);
  Future<dynamic> updateSubscriptionDetail(
    String subscriptionID, {
    required Map request,
  });
}

class HealthLockerRepoImpl extends BaseRepo implements HealthLockerRepo {
  HealthLockerRepoImpl() : super(HealthLockerRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<List> callConnectedLockerList() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.lockerConnectedListApi,
    );
    return Future.value(response?.data ?? []);
  }

  @override
  Future<List> callAllLockerList() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.lockerListApi,
    );
    return Future.value(response?.data ?? []);
  }

  @override
  Future<Map> callIndividualLockerInfoAPI(String lockerId) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: '${ApiPath.lockerIndividualInfoApi}$lockerId',
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<dynamic> fetchLinks() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.lockerLinkHipApi,
    );
    return Future.value(response?.data);
  }

  @override
  Future<dynamic> addLocker() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.lockerToAdd,
      options: Options(
        headers: {
          ApiKeys.headersKeys.authorization: 'Bearer ${abhaSingleton.getAppData.getAccessToken()}',
        },
      ),
    );
    return Future.value(response?.data);
  }


  @override
  Future<dynamic> changeAutoApprovalPolicy(
    String autoApprovalId,
    bool enable,
  ) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: enable
          ? ApiPath.lockerEnableApi(autoApprovalId)
          : ApiPath.lockerDisableApi(autoApprovalId),
    );
    return Future.value(response?.data ?? '');
  }

  @override
  Future<Map> getAuthorizationDetail(String authRequestId) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.getAuthorizationRequest(authRequestId),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> getRevokedAuthRequest(String revokedRequestId) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.getRevokedRequest(revokedRequestId),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> getSubscriptionDetail(String subscriptionRequestId) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.getSubscriptionRequest(subscriptionRequestId),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<dynamic> updateSubscriptionDetail(
    String subscriptionID, {
    required Map request,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.put,
      url: ApiPath.updateSubscriptionDetail(subscriptionID),
      dataPayload: request,
    );
    return response?.data ?? {};
  }
}
