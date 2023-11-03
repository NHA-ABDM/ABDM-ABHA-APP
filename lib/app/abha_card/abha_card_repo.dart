import 'package:abha/export_packages.dart';

/// Here is the  abstract class [AbhaCardRepo] declared the abstract method
abstract class AbhaCardRepo {
  Future<dynamic> callAbhaCard();
}

/// @Here the class [AbhaCardRepoImpl] extends  [BaseRepo] and implements [AbhaCardRepo].
/// This Repo class is used to define the override method callAbhaCard() and call the api
/// which returns the response of Future<dynamic> type
class AbhaCardRepoImpl extends BaseRepo implements AbhaCardRepo {
  AbhaCardRepoImpl() : super(AbhaCardRepoImpl);

  /// initialize the instance of ApiProvider
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  /// @Here is the override method callAbhaCard() method used to fetch the
  /// response by calling api. And returns the response.
  @override
  Future<dynamic> callAbhaCard() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.profileAbhaCard,
      options: Options(
        responseType: ResponseType.bytes,
      ),
    );
    return Future.value(response?.data ?? {});
  }
}
