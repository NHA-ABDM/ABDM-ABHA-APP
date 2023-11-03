import 'package:abha/export_packages.dart';

abstract class SplashRepo {
  // Future<Map> callRefreshApiHeaderToken();
}

class SplashRepoImpl extends BaseRepo implements SplashRepo {
  SplashRepoImpl() : super(SplashRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  // @override
  // Future<Map> callRefreshApiHeaderToken() async {
  //   Response response = await apiProvider.request(
  //     method: APIMethod.get,
  //     url: ApiPath.refreshApiHeaderToken,
  //   );
  //   return Future.value(response.data);
  // }

}
