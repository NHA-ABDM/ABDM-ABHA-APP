import 'package:abha/export_packages.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';
import 'package:abha/network/socket/api_stomp_socket_connection.dart';

abstract class DiscoveryLinkingRepo {
  Future<List> callGovtProgram();
  Future<List> callSearchHip(Map searchHipData);
  void callDiscoverHip(
    Map discoverHipData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  );
  void callLinkHip(
    Map linkHipData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  );
  void callLinkConfirmHip(
    Map linkConfirmHipData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  );
  // Future<Map> onResendOtp(Map resendOtpData);
}

class DiscoveryLinkingRepoImpl extends BaseRepo
    implements DiscoveryLinkingRepo {
  DiscoveryLinkingRepoImpl() : super(DiscoveryLinkingRepoImpl);
  final ApiProvider _apiProvider = abhaSingleton.getApiProvider;
  final ApiStompSocketConnection _stompSocketConnection =
      ApiStompSocketConnection();

  @override
  Future<List> callGovtProgram() async {
    Response? response = await _apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.govtProgramsApi,
    );
    return Future.value(response?.data ?? []);
  }

  @override
  Future<List> callSearchHip(Map searchHipData) async {
    Response? response = await _apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.hipProvidersApi,
      dataPayload: searchHipData,
    );
    return Future.value(response?.data ?? []);
  }

  @override
  void callDiscoverHip(
    Map discoverHipData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) {
    _stompSocketConnection.initConnection(
      reqId: requestId,
      publishApiCall: ApiPath.discoverHipApi,
      subscribeApiCall: ApiPath.onDiscoverHipApi,
      reqBody: discoverHipData,
      callBack: (responseModel) => callBackFunc(responseModel),
    );
  }

  // @override
  // Future<Map> callDiscoverHip(Map discoverHipData,String requestId) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.discoverHipApi,
  //     options: Options(headers: {
  //       ApiKeys.headersKeys.xHiuId : 'M_HIU',
  //       ApiKeys.headersKeys.requestId : requestId
  //     }),
  //     dataPayload: discoverHipData,
  //   );
  //   return Future.value(response?.data ?? {});
  // }

  @override
  void callLinkHip(
    Map linkHipData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) {
    _stompSocketConnection.initConnection(
      reqId: requestId,
      publishApiCall: ApiPath.linkHipApi,
      subscribeApiCall: ApiPath.onLinkHipApi,
      reqBody: linkHipData,
      callBack: (responseModel) => callBackFunc(responseModel),
    );
  }

  // @override
  // Future<Map> callLinkHip(Map linkHipData) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.linkHipApi,
  //     dataPayload: linkHipData,
  //   );
  //   return Future.value(response?.data ?? {});
  // }

  @override
  void callLinkConfirmHip(
    Map linkConfirmHipData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) {
    _stompSocketConnection.initConnection(
      reqId: requestId,
      publishApiCall: ApiPath.linkConfirmHipApi,
      subscribeApiCall: ApiPath.onLinkConfirmHipApi,
      reqBody: linkConfirmHipData,
      callBack: (responseModel) => callBackFunc(responseModel),
    );
  }

  // @override
  // Future<Map> callLinkConfirmHip(
  //   Map linkConfirmHipData,
  // ) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.linkConfirmHipApi,
  //     dataPayload: linkConfirmHipData,
  //   );
  //   return Future.value(response?.data ?? {});
  // }

  // @override
  // Future<Map> onResendOtp(Map resendOtpData) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.resendOtpApi,
  //     dataPayload: resendOtpData,
  //   );
  //   return Future.value(response?.data ?? {});
  // }
}
