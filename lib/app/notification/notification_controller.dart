import 'package:abha/export_packages.dart';

class NotificationController extends BaseController {
  late NotificationRepo _notificationRepo;
  List<NotificationModel> notificationsData = [];
  ValueNotifier<bool> isRequestInProgress = ValueNotifier(false);
  ValueNotifier<bool> isShowLoadMore = ValueNotifier(false);

  // var notificationCount = 50;

  NotificationController(NotificationRepoImpl repo)
      : super(NotificationController) {
    _notificationRepo = repo;
  }

  /// @Here is the method getNotificationFetch() gets the tempResponseData by calling the
  /// callGetNotification() method which is define inside the NotificationRepoImpl class.
  Future<void> getNotificationFetch(bool clearData) async {
    try {
      if (!isRequestInProgress.value) {
        isShowLoadMore.value = false;
        isRequestInProgress.value = true;
        int offset = 0;
        int limit = 10;
        if (clearData) notificationsData.clear();
        if (notificationsData.isNotEmpty) {
          offset = notificationsData.length + 1;
        }
        tempResponseData = await _notificationRepo.callGetNotification(
          limit: limit,
          offset: offset,
        );
        String tempData = jsonEncode(tempResponseData);
        List<NotificationModel> tempListNotifications =
            notificationModelFromMap(tempData);
        isShowLoadMore.value = true;
        if (tempListNotifications.length < limit) {
          isShowLoadMore.value = false;
        }
        // isShowLoadMore.value = tempListNotifications.isNotEmpty;
        notificationsData.addAll(tempListNotifications);

        isRequestInProgress.value = false;
      }
    } catch (e) {
      isShowLoadMore.value = true;
    } finally {
      isRequestInProgress.value = false;
    }
  }

  /// @Here is the method readNotification() marks the Notification as read by calling
  /// the readNotification() as passing notification id as argument in the method
  /// which is define inside the NotificationRepoImpl class.
  Future<void> readNotification(int id) async {
    tempResponseData = await _notificationRepo.readNotification(id);
  }

  /// @Here function return true if timestamp month and year matches to current
  /// Datetime month and year.
  /// param [timestamp] DateTime.
// bool checkCurrentDate(DateTime? timestamp) {
//   var currentTimeStamp = DateTime.now();
//   if (timestamp?.month == currentTimeStamp.month && timestamp?.year == currentTimeStamp.year) {
//     return true;
//   }
//   return false;
// }

// void setNotificationCountOnStart(List<NotificationModel> notificationsList) {
//   if (notificationsList.length < 100) {
//     notificationCount = notificationsList.length;
//   }
// }

// void setNotificationCountOnScroll(List<NotificationModel> notificationsList, {Timer? timer}) {
//   notificationCount += 20;
//   if (notificationCount > notificationsList.length) {
//     notificationCount -= notificationsList.length;
//     if (timer != null) {
//       timer.cancel();
//     }
//   }
// }
}
