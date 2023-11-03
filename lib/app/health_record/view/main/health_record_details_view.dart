import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/app/health_record/view/desktop/health_record_details_desktop_view.dart';
import 'package:abha/app/health_record/view/mobile/health_record_details_mobile_view.dart';
import 'package:abha/database/local_db/hive/boxes.dart';
import 'package:abha/export_packages.dart';

class HealthRecordDetailView extends StatefulWidget {
  final Map arguments;

  const HealthRecordDetailView({required this.arguments, super.key});

  @override
  HealthRecordDetailViewState createState() => HealthRecordDetailViewState();
}

class HealthRecordDetailViewState extends State<HealthRecordDetailView> {
  List<HealthRecordLocalModel> _healthDataEntryList = [];
  int _currentPage = 0;
  final box = HiveBoxes().getHealthRecords();
  late String _selectedHealthEntryDate;

  @override
  void initState() {
    _init();
    _getHealthData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _selectedHealthEntryDate =
        widget.arguments[IntentConstant.healthBundleDate];
    _currentPage = widget.arguments[IntentConstant.healthEntryPosition];
  }

  void _getHealthData() {
    _healthDataEntryList = box.values
        .where((element) => element.date == _selectedHealthEntryDate)
        .toList()
        .cast<HealthRecordLocalModel>();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      paddingValueMobile: Dimen.d_0,
      title: LocalizationHandler.of().healthRecord,
      type: HealthRecordDetailView,
      bodyMobile: HealthRecordDetailMobileView(
        healthDataEntryList: _healthDataEntryList,
        currentPage: _currentPage,
      ),
      bodyDesktop: HealthRecordDetailDesktopView(
        healthDataEntryList: _healthDataEntryList,
        currentPage: _currentPage,
      ),
    );
  }
}
