import 'package:abha/export_packages.dart';

abstract class LinkUnlinkRepo {
  // Future<Map> onAbhaNumberAuthSearch(Map abhaNumberSearchData);
  Future<Map> onAbhaNumberAuthInit(Map abhaNumberInitData);
  Future<Map> onAbhaNumberOtpVerify(Map otpVerifyData);
  // Future<Map> onResendOtp(Map resendOtpData);
  // Future<Map> onAbhaNumberLinkUnlink(Map mobileEmailAuthConfirmData);
  Future<Map> onAbhaNumberLink(Map mobileEmailAuthConfirmData);
  Future<Map> onAbhaNumberDeLink(Map mobileEmailAuthConfirmData);
}

class LinkUnlinkRepoImpl extends BaseRepo implements LinkUnlinkRepo {
  LinkUnlinkRepoImpl() : super(LinkUnlinkRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  // @override
  // Future<Map> onAbhaNumberAuthSearch(Map abhaNumberSearchData) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.abhaAuthModeApi,
  //     dataPayload: abhaNumberSearchData,
  //   );
  //   return Future.value(response?.data ?? {});
  // }

  @override
  Future<Map> onAbhaNumberAuthInit(Map abhaNumberInitData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.profileEmailMobileOtpReq,
      dataPayload: abhaNumberInitData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onAbhaNumberOtpVerify(
    Map mobileEmailOtpVerifyData,
  ) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.profileEmailMobileOtpVerify,
      dataPayload: mobileEmailOtpVerifyData,
    );
    return Future.value(response?.data ?? {});
  }

  // @override
  // Future<Map> onResendOtp(Map resendOtpData) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.resendOtpApi,
  //     dataPayload: resendOtpData,
  //   );
  //   return Future.value(response?.data ?? {});
  // }

  // @override
  // Future<Map> onAbhaNumberLinkUnlink(Map mobileEmailAuthConfirmData) async {
  //   Response? response = await apiProvider.request(
  //     method: APIMethod.post,
  //     url: ApiPath.linkUnlinkApi,
  //     dataPayload: mobileEmailAuthConfirmData,
  //   );
  //   return Future.value(response?.data ?? {});
  // }

  @override
  Future<Map> onAbhaNumberLink(Map mobileEmailAuthConfirmData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.linkApi,
      dataPayload: mobileEmailAuthConfirmData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> onAbhaNumberDeLink(Map mobileEmailAuthConfirmData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.deLinkApi,
      dataPayload: mobileEmailAuthConfirmData,
    );
    return Future.value(response?.data ?? {});
  }
}
