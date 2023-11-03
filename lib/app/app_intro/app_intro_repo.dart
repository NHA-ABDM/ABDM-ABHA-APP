import 'package:abha/export_packages.dart';

abstract class AppIntroRepo {
  // Future<Map> callRefreshApiHeaderToken();
}

class AppIntroRepoImpl extends BaseRepo implements AppIntroRepo {
  AppIntroRepoImpl() : super(AppIntroRepoImpl);
  // ApiProvider apiProvider = abhaSingleton.getApiProvider;

  // @override
  // Future<Map> callRefreshApiHeaderToken() async {
  //   Response response = await apiProvider.request(
  //     method: APIMethod.get,
  //     url: ApiPath.refreshApiHeaderToken,
  //   );
  //   return Future.value(response.data);
  // }
}
