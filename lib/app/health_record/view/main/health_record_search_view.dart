import 'package:abha/export_packages.dart';

class HealthRecordSearchView extends StatefulWidget {
  const HealthRecordSearchView({super.key});

  @override
  HealthRecordSearchViewState createState() => HealthRecordSearchViewState();
}

class HealthRecordSearchViewState extends State<HealthRecordSearchView> {
  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BaseView(
        paddingValueMobile: Dimen.d_0,
        type: HealthRecordSearchView,
        title: LocalizationHandler.of().myHealthRecords.toTitleCase(),
        mobileBackgroundColor: AppColors.colorWhite4,
        bodyMobile: const HealthRecordView(
          fromDashBoard: false,
        ),
      ),
    );
  }
}
