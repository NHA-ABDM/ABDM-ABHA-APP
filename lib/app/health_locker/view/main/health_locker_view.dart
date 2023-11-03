import 'package:abha/app/health_locker/view/desktop/health_locker_desktop_view.dart';
import 'package:abha/app/health_locker/view/mobile/health_locker_mobile_view.dart';
import 'package:abha/export_packages.dart';

class HealthLockerView extends StatefulWidget {
  final Map? arguments;

  const HealthLockerView({super.key, this.arguments});

  @override
  HealthLockerViewState createState() => HealthLockerViewState();
}

class HealthLockerViewState extends State<HealthLockerView> {
  late HealthLockerController _healthLockerController;
  late GlobalEnumNavigationType _navigateTo;
  late String _requestId;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    DeleteControllers().deleteHealthLocker();
    super.dispose();
  }

  void _init() {
    _healthLockerController =
        Get.put(HealthLockerController(HealthLockerRepoImpl()));
    _navigateTo = widget.arguments?[IntentConstant.navigateTo] ??
        GlobalEnumNavigationType.navDefault;
    _requestId = widget.arguments?[IntentConstant.data] ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _onFetchLocker();
      await _onFetchAndUpdateLinkedFacility();
      await _onFetchConnectedLocker();
    });
  }

  void _navHandle() {
    String routePath = '';
    Map arguments = {};
    if (_navigateTo == GlobalEnumNavigationType.healthLockerEditSubscription) {
      routePath = RoutePath.routeHealthLockerEditSubscription;
      arguments = {IntentConstant.subscriptionID: _requestId};
    } else if (_navigateTo ==
        GlobalEnumNavigationType.healthLockerAuthorizationRequest) {
      routePath = RoutePath.routeHealthLockerAuthorizationRequest;
      arguments = {IntentConstant.authorizationRequestId: _requestId};
    } else {}
    context.navigatePush(
      routePath,
      arguments: arguments,
    );
  }

  Future<void> _onFetchLocker() async {
    await _healthLockerController.functionHandler(
      function: () => _healthLockerController.getAllLockers(),
      isLoaderReq: true,
    );
  }

  Future<void> _onFetchAndUpdateLinkedFacility() async {
    await _healthLockerController.functionHandler(
      function: () => _healthLockerController.fetchLinkedFacility(),
      isLoaderReq: true,
    );
  }

  Future<void> _onFetchConnectedLocker() async {
    _healthLockerController.functionHandler(
      function: () async {
        await _healthLockerController.getConnectedLockers();
        _navigateTo != GlobalEnumNavigationType.navDefault
            ? _navHandle()
            : null;
      },
      isLoaderReq: true,
      isUpdateUi: true,
      isUpdateUiOnLoading: true,
      isUpdateUiOnError: true,
    );
  }

  void _onLockerClick(HealthLockerConnectedModel tempConnectedLocker) {
    var arguments = {
      IntentConstant.lockerId: tempConnectedLocker.lockerId,
      IntentConstant.lockerName: tempConnectedLocker.lockerName,
    };
    context.navigatePush(
      RoutePath.routeHealthLockerInfoSubItem,
      arguments: arguments,
    );
  }



  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: LocalizationHandler.of().drawer_healthlocker.toTitleCase(),
      type: HealthLockerView,
      bodyDesktop: HealthLockerDesktopView(
        onFetchConnectedLocker: _onFetchConnectedLocker,
        onLockerClick: _onLockerClick,
      ),
      bodyMobile: HealthLockerMobileView(
        onFetchConnectedLocker: _onFetchConnectedLocker,
        onLockerClick: _onLockerClick,
      ),
    );
  }

}
