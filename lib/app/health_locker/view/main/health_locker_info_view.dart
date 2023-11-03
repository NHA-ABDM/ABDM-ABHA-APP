import 'package:abha/app/health_locker/view/desktop/health_locker_info_desktop_view.dart';
import 'package:abha/app/health_locker/view/mobile/health_locker_info_mobile_view.dart';
import 'package:abha/export_packages.dart';

class HealthLockerInfoView extends StatefulWidget {
  final Map arguments;

  const HealthLockerInfoView({required this.arguments, super.key});

  @override
  State<HealthLockerInfoView> createState() => _HealthLockerInfoViewState();
}

class _HealthLockerInfoViewState extends State<HealthLockerInfoView> {
  late HealthLockerController healthLockerController;
  late ScrollController scrollController;
  late String _screenTitle = '';
  late String _fromScreenString;

  @override
  void initState() {
    _fromScreenString = widget.arguments[IntentConstant.fromScreen];
    healthLockerController = Get.find<HealthLockerController>();
    scrollController = ScrollController();
    super.initState();
  }

  void initScreenTitleText() {
    if (_fromScreenString == StringConstants.forSubscription) {
      _screenTitle =
          LocalizationHandler.of().active_subscription_requests.toTitleCase();
    } else if (_fromScreenString == StringConstants.forAuthorization) {
      _screenTitle =
          LocalizationHandler.of().active_authorisation_requests.toTitleCase();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initScreenTitleText();
    return BaseView(
      title: _screenTitle,
      type: HealthLockerInfoView,
      bodyMobile: HealthLockerInfoMobileView(
        arguments: widget.arguments,
      ),
      bodyDesktop: HealthLockerInfoDesktopView(
        arguments: widget.arguments,
      ),
    );
  }
}
