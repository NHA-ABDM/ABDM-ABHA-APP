import 'package:abha/export_packages.dart';

abstract class AbhaNumberRepo extends BaseRepo {
  AbhaNumberRepo(super.type);

  Future<Map> onGenerateOtp(Map data);
  Future<Map> onVerifyOtp(Map data);
  Future<Map> onVerifyFaceAuth(Map data);
  Future<dynamic> onaAbhaNumberCard(Map headerData, String authToken);

  // forget ABHA Number Api's
  Future<Map> onGenerateOtpViaAadhaarOrMobile(Map data);
  Future<Map> onOtpVerify(Map data);
}

class AbhaNumberRepoImpl extends BaseRepo implements AbhaNumberRepo {
  AbhaNumberRepoImpl() : super(AbhaNumberRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<Map> onGenerateOtp(Map data) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaNumberCreateRequestOtp,
      dataPayload: data,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onVerifyOtp(Map data) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaNumberCreateVerifyOtp,
      dataPayload: data,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onVerifyFaceAuth(Map data) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaNumberCreateVerifyOtp,
      dataPayload: data,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<dynamic> onaAbhaNumberCard(Map headerData, String authToken) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      options: Options(
        responseType: ResponseType.bytes,
        headers: {
          ApiKeys.headersKeys.authorization: null,
          ApiKeys.headersKeys.xToken:
              'Bearer ${headerData[ApiKeys.responseKeys.tokens][ApiKeys.responseKeys.token]}',
        },
      ),
      url: ApiPath.abhaNumberCard,
    );
    return Future.value(response?.data);
  }

  @override
  Future<Map> onGenerateOtpViaAadhaarOrMobile(Map data) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaNumberForgetRequestOtp,
      dataPayload: data,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onOtpVerify(Map data) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.abhaNumberForgetVerifyOtp,
      dataPayload: data,
    );
    return Future.value(response?.data ?? {});
  }
}
