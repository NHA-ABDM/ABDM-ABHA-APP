import 'package:abha/export_packages.dart';

abstract class ConsentRepo {
  Future<dynamic> getConsents({
    required int limit,
    required int offset,
    String? filters,
  });

  Future<void> denyConsent({required String requestId});

  Future<void> revokeConsent({required Map revokeConsentRequest});

  Future<dynamic> fetchConsentRequestById({required String requestId});

  Future<dynamic> fetchLinks();

  Future<dynamic> callProviderDetailFetch(String hipId);

  Future<dynamic> getConsentArtefacts({required String id});

  Future<void> approveConsent({
    required Map request,
    required String requestId,
  });

  Future<dynamic> fetchApprovedConsentById({
    required String requestId,
    required String subscriptionId,
  });

  Future<dynamic> fetchSubscription({
    required String subscriptionId,
  });

  Future<dynamic> fetchSubscriptionByRequestId({
    required String subscriptionRequestId,
  });

  Future<dynamic> getSubscriptions({
    required int limit,
    required int offset,
    String? filters,
  });
}

class ConsentRepoImpl extends BaseRepo implements ConsentRepo {
  ConsentRepoImpl() : super(ConsentRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<dynamic> getConsents({
    required int limit,
    required int offset,
    String? filters,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.consentRequestFetchApi,
      dataPayload: {'limit': limit, 'offset': offset, 'status': filters},
    );
    return response?.data ?? {};
  }

  @override
  Future<void> denyConsent({required String requestId}) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.consentDenyApi(requestId),
      dataPayload: {'reason': 'Successfully denied consent request.'},
    );
    return Future.value(response?.data);
  }

  @override
  Future<void> revokeConsent({
    required Map revokeConsentRequest,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.consentRevokeFetchApi,
      dataPayload: revokeConsentRequest,
    );
    return Future.value(response?.data);
  }

  @override
  Future<dynamic> fetchConsentRequestById({required String requestId}) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: '${ApiPath.consentRequests}/$requestId',
    );
    return Future.value(response?.data);
  }

  @override
  Future<dynamic> fetchLinks() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.consentRequestLinkHipApi,
    );
    return Future.value(response?.data);
  }

  @override
  Future callProviderDetailFetch(String hipId) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: '${ApiPath.consentHipProvidersApi}/$hipId',
    );
    return Future.value(response?.data);
  }

  /// Approve consent after pin verification / tempToken is required in header instead of authToken
  @override
  Future<void> approveConsent({
    required Map request,
    required String requestId,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.consentApproveApi(requestId),
      dataPayload: request,
    );
    return Future.value(response?.data);
  }

  @override
  Future getConsentArtefacts({required String id}) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.consentArtefactsApi(id),
    );
    return Future.value(response?.data);
  }

  @override
  Future fetchApprovedConsentById({
    required String requestId,
    required String subscriptionId,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.getSubscriptionRequest(subscriptionId),
    );
    return Future.value(response?.data);
  }

  @override
  Future fetchSubscription({required String subscriptionId}) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.getSubscriptionRequest(subscriptionId),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future fetchSubscriptionByRequestId({
    required String subscriptionRequestId,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.getSubscriptionByRequestId(subscriptionRequestId),
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future getSubscriptions({
    required int limit,
    required int offset,
    String? filters,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.subscriptionRequest,
      dataPayload: {
        'limit': limit,
        'offset': offset,
        'status': filters,
      },
    );
    return response?.data ?? {};
  }
}
