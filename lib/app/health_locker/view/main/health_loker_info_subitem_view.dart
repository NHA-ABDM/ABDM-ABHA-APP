import 'package:abha/app/health_locker/view/desktop/health_loker_info_subitem_desktop_view.dart';
import 'package:abha/app/health_locker/view/mobile/health_loker_info_subitem_mobile_view.dart';
import 'package:abha/export_packages.dart';

class HealthLockerInfoSubItemView extends StatefulWidget {
  final Map arguments;

  const HealthLockerInfoSubItemView({required this.arguments, super.key});

  @override
  HealthLockerInfoSubItemViewState createState() =>
      HealthLockerInfoSubItemViewState();
}

class HealthLockerInfoSubItemViewState
    extends State<HealthLockerInfoSubItemView> {
  late HealthLockerController _healthLockerController;
  late String lockerId;
  late String lockerType;

  @override
  void initState() {
    _healthLockerController = Get.find<HealthLockerController>();
    lockerId = widget.arguments[IntentConstant.lockerId];
    lockerType = widget.arguments[IntentConstant.lockerName];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Validator.isNullOrEmpty(lockerId)) {
        _onFetchLockerInfo(lockerId);
      }
    });

    super.initState();
  }

  Future<void> _onFetchLockerInfo(String lockerId) async {
    await _healthLockerController.functionHandler(
      function: () => _healthLockerController.getLockerInfo(lockerId),
      isUpdateUi: true,
      isLoaderReq: true,
      updateUiBuilderIds: [UpdateLockerBuilderIds.healthLockerInfoSubItem],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().drawer_healthlocker.toTitleCase(),
      type: HealthLockerInfoSubItemView,
      bodyMobile: HealthLockerInfoSubItemMobileView(
        arguments: widget.arguments,
        onFetchLockerInfo: _onFetchLockerInfo,
      ),
      bodyDesktop: HealthLockerInfoSubItemDesktopView(
        arguments: widget.arguments,
        onFetchLockerInfo: _onFetchLockerInfo,
      ),
    );
  }
}
