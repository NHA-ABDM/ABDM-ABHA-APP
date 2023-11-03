import 'package:abha/app/dashboard/dashboard_controller.dart';
import 'package:abha/app/health_record/view/desktop/health_record_desktop_view.dart';
import 'package:abha/app/health_record/view/mobile/health_record_mobile_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class HealthRecordView extends StatefulWidget {
  final bool fromDashBoard;
  final bool isWeb;

  const HealthRecordView({
    super.key,
    this.fromDashBoard = true,
    this.isWeb = false,
  });

  @override
  HealthRecordViewState createState() => HealthRecordViewState();
}

class HealthRecordViewState extends State<HealthRecordView> {
  late HealthRecordController _healthRecordController;
  late DashboardController _dashboardController;

  @override
  void initState() {
    _init();
    _onStart();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _dashboardController = Get.find<DashboardController>();
    _healthRecordController =
        Get.put(HealthRecordController(HealthRecordRepoImpl()));
  }

  void _onStart() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Validator.isNullOrEmpty(_dashboardController.hIpIdDataPullRecord)) {
        _onHealthInformationFetchForPullRecord();
      } else if (!_healthRecordController.isHealthRecordCalledOnce || kIsWeb) {
        _onHealthInformationFetch();
      }
    });
  }

  Future<void> _onHealthInformationFetchForPullRecord() async {
    abhaSingleton.getAppData.setHealthRecordFetched(false);
    List? hIpIds = _dashboardController.hIpIdDataPullRecord ?? [];
    _dashboardController.setLinkedFacilityPullRecord(null);
    await _healthRecordController.functionHandler(
      function: () =>
          _healthRecordController.getDataOnPullRecords(hIpIds, context),
      isUpdateUi: true,
      isUpdateUiOnLoading: true,
      isUpdateUiOnError: true,
      isShowError: false,
    );
    abhaSingleton.getAppData.setHealthRecordFetched(true);
    // _showErrorMsgSnackBar();
  }

  Future<void> _onHealthInformationFetch() async {
    abhaSingleton.getAppData.setHealthRecordFetched(false);
    await _healthRecordController.functionHandler(
      function: () => _healthRecordController.getUserHealthRecords(),
      isUpdateUi: true,
      isUpdateUiOnLoading: true,
      isUpdateUiOnError: true,
      isShowError: false,
    );
    // If no hip Link data available send boolean true to Dashboard
    _dashboardController.onLinkFacilityEmpty(_healthRecordController.getEmptyHip());
    abhaSingleton.getAppData.setHealthRecordFetched(true);
    // _showErrorMsgSnackBar();
  }

  Future<void> _pullRefresh() async {
    if (abhaSingleton.getAppData.getHealthRecordFetched()) {
      _onHealthInformationFetch();
    }
  }

  void _onSearchHealthRecord(String searchHealthRecord) {
    _healthRecordController.functionHandler(
      function: () => _healthRecordController
          .searchHealthRecord(searchHealthRecord.toLowerCase().trim()),
      isUpdateUi: true,
    );
  }

  // void _showErrorMsgSnackBar() {
  //   abhaSingleton.getSharedPref
  //       .get(SharedPref.isLogin, defaultValue: false)
  //       .then((isLogin) {
  //     if (isLogin == true) {
  //       MessageBar.showDefaultSnackBar(
  //         LocalizationHandler.of().checkHealthRecordStatus,
  //       );
  //     }
  //   });
  // }

  // void _showErrorMsgDialog() {
  //   if (!Validator.isNullOrEmpty(_healthRecordApiFetchController.errorMsg)) {
  //     CustomDialog.showPopupDialog(
  //       _healthRecordApiFetchController.errorMsg,
  //       mContext: context,
  //       onPositiveButtonPressed: () =>
  //           CustomDialog.dismissDialog(mContext: context),
  //       title: LocalizationHandler.of().info,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return widget.isWeb
        ? HealthRecordDesktopView(
            onHealthInformationFetch: _onHealthInformationFetch,
            onSearchHealthRecord: _onSearchHealthRecord,
          )
        : RefreshIndicator(
            onRefresh: () => _pullRefresh(),
            child: HealthRecordMobileView(
              fromDashBoard: widget.fromDashBoard,
              onHealthInformationFetch: _onHealthInformationFetch,
              onSearchHealthRecord: _onSearchHealthRecord,
            ),
    );
  }
}
