import 'package:abha/export_packages.dart';

/// @Here is the Abstract class FacilityRepo declared the
/// method of type Future of Map.
abstract class FacilityRepo {
  Future<Map> callFacilityLink();
}

/// @Here is the Class LinkedFacilityRepoImpl [extends] BaseRepo and
/// [implements] FacilityRepo abstract class.
class LinkedFacilityRepoImpl extends BaseRepo implements FacilityRepo {
  LinkedFacilityRepoImpl() : super(LinkedFacilityRepoImpl);

  /// initialize the instance of ApiProvider
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  /// @Here is the override method callFacilityLink() method used to fetch the
  /// response by calling api. And get returns the response.
  @override
  Future<Map> callFacilityLink() async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.linkFacilityApi,
    );
    return Future.value(response?.data ?? {});
  }
}
