import 'package:abha/export_packages.dart';

/// Here is the  abstract class [SettingsRepo] declared the abstract method.
abstract class SettingsRepo {
  Future<Map> callUpdatePassword(Map updatePasswordData);
  Future<Map> callSendFeedback(Map sendFeedbackData);
}

/// @Here the class [SettingsRepoImpl] extends  [BaseRepo] and implements [SettingsRepo].
/// This Repo class is used to define the override method callUpdatePassword() and call the api
/// which returns the response of Future<dynamic> type.
class SettingsRepoImpl extends BaseRepo implements SettingsRepo {
  SettingsRepoImpl() : super(SettingsRepoImpl);
  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  /// @Here is the override method callUpdatePassword() method used to fetch the
  /// response by calling api. And returns the response.
  @override
  Future<Map> callUpdatePassword(Map updatePasswordData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.profileUpdatePasswordApi,
      dataPayload: updatePasswordData,
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<Map> callSendFeedback(Map sendFeedbackData) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.sendFeedbackApi,
      dataPayload: sendFeedbackData,
    );
    return Future.value(response?.data ?? {});
  }
}
