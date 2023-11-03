import 'package:abha/export_packages.dart';

abstract class NotificationRepo {
  Future<dynamic> callGetNotification({
    required int limit,
    required int offset,
  });

  Future<dynamic> readNotification(int notificationId);
}

class NotificationRepoImpl extends BaseRepo implements NotificationRepo {
  NotificationRepoImpl() : super(NotificationRepoImpl);

  ApiProvider apiProvider = abhaSingleton.getApiProvider;

  @override
  Future<dynamic> callGetNotification({
    required int limit,
    required int offset,
  }) async {
    Response? response = await apiProvider.request(
      method: APIMethod.get,
      url: ApiPath.notificationsApi,
      dataPayload: {
        ApiKeys.requestKeys.offset: offset,
        ApiKeys.requestKeys.limit: limit,
      },
    );
    return Future.value(response?.data ?? {});
  }

  @override
  Future<dynamic> readNotification(int notificationId) async {
    Response? response = await apiProvider.request(
      method: APIMethod.post,
      url: ApiPath.notificationsReadApi,
      dataPayload: [
        {
          ApiKeys.requestKeys.id: notificationId,
          ApiKeys.requestKeys.isNotificationRead: true,
        }
      ],
    );
    return Future.value(response?.data ?? {});
  }
}
