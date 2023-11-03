import 'package:abha/export_packages.dart';
import 'package:abha/network/socket/api_socket_local_response_model.dart';
import 'package:abha/network/socket/api_stomp_socket_connection.dart';

abstract class ShareProfileRepo {
  Future<dynamic> callProviderDetailFetch(String hipId);
  void callPatientProfileShare(
    Map shareProfileData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  );
}

class ShareProfileRepoImpl extends BaseRepo implements ShareProfileRepo {
  ShareProfileRepoImpl() : super(ShareProfileRepoImpl);
  final ApiProvider _apiProvider = abhaSingleton.getApiProvider;
  final ApiStompSocketConnection _stompSocketConnection =
      ApiStompSocketConnection();

  /// @Here call api to fetch the User details.
  /// Params required [hipId] of type String.
  @override
  Future<dynamic> callProviderDetailFetch(String hipId) async {
    Response? response = await _apiProvider.request(
      method: APIMethod.get,
      url: '${ApiPath.shareProfileHipProvidersApi}/$hipId',
    );
    return Future.value(response?.data ?? '');
  }

  /// @Here call api to share the users detail information.
  /// Params [shareProfileData] of type Map request.

  @override
  void callPatientProfileShare(
    Map shareProfileData,
    String requestId,
    Function(ApiSocketLocalResponseModel responseModel) callBackFunc,
  ) {
    _stompSocketConnection.initConnection(
      reqId: requestId,
      publishApiCall: ApiPath.sharePatientsProfileApi,
      subscribeApiCall: ApiPath.onSharePatientsProfileApi,
      reqBody: shareProfileData,
      callBack: (responseModel) => callBackFunc(responseModel),
    );
  }

  // @override
  // Future<dynamic> callPatientProfileShare(Map shareProfileData) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.patientsProfileShareApi,
  //     dataPayload: shareProfileData,
  //   );
  //   return Future.value(response?.data??{});
  // }
}
