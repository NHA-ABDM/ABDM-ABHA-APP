import 'package:abha/export_packages.dart';

abstract class TokenRepo {
  Future<List> onHipTokenDetails();
}

class TokenRepoImpl extends BaseRepo implements TokenRepo {
  TokenRepoImpl() : super(TokenRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<List> onHipTokenDetails() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.hipTokenDetails,
    );
    return Future.value(response?.data ?? []);
  }
}
