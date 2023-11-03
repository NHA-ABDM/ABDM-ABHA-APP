import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/app/health_record/widget/health_record_type_desktop_view.dart';
import 'package:abha/database/local_db/hive/boxes.dart';
import 'package:abha/export_packages.dart';
import 'package:abha/reusable_widget/common/common_background_card.dart';
import 'package:abha/reusable_widget/drawer/custom_drawer_desktop_view.dart';

class HealthRecordDetailDesktopView extends StatefulWidget {
  final List<HealthRecordLocalModel> healthDataEntryList;
  final int currentPage;

  const HealthRecordDetailDesktopView({
    required this.healthDataEntryList,
    required this.currentPage,
    super.key,
  });

  @override
  HealthRecordDetailDesktopViewState createState() =>
      HealthRecordDetailDesktopViewState();
}

class HealthRecordDetailDesktopViewState
    extends State<HealthRecordDetailDesktopView> {
  List<HealthRecordLocalModel> _healthDataEntryList = [];
  int _currentPage = 0;
  String consentId = '';
  late HealthRecordController _healthRecordController;
  final box = HiveBoxes().getHealthRecords();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _init() {
    _healthRecordController = Get.find<HealthRecordController>();
    _healthDataEntryList = widget.healthDataEntryList;
    _currentPage = widget.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    EncounterLocalModel? encounterLocalModel =
        _healthDataEntryList.elementAt(_currentPage).encounterLocalModel;
    List<HealthRecordTypeLocalModel> healthRecordTypes =
        _healthDataEntryList.elementAt(_currentPage).healthRecordType ?? [];
    consentId = _healthDataEntryList[_currentPage].consentRequestId ?? '';
    String hipName = _healthDataEntryList.elementAt(_currentPage).hipName ?? '';
    String date = _healthDataEntryList.elementAt(_currentPage).date ?? '';
    List<List<HealthRecordTypeLocalModel>> recordTypesToRender = [];
    int chunkSize = 3;
    for (var i = 0; i < healthRecordTypes.length; i += chunkSize) {
      recordTypesToRender.add(
        healthRecordTypes.sublist(
          i,
          i + chunkSize > healthRecordTypes.length
              ? healthRecordTypes.length
              : i + chunkSize,
        ),
      );
    }

    return CustomDrawerDesktopView(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocalizationHandler.of().healthRecord.toTitleCase(),
            style: CustomTextStyle.titleLarge(context)?.apply(
              color: AppColors.colorAppBlue,
              fontWeightDelta: 2,
            ),
          ).marginOnly(bottom: Dimen.d_20),
          CommonBackgroundCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: WidgetUtility.childrenBuilder((children) {
                if (!Validator.isNullOrEmpty(encounterLocalModel)) {
                  children.add(
                    _getHospitalDetailView(
                      encounterLocalModel,
                      hipName,
                      date,
                    ),
                  );
                }
                children.add(
                  SizedBox(
                    height: Dimen.d_16,
                  ),
                );
                for (var element in recordTypesToRender) {
                  children.add(
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: element.map((record) {
                        return Flexible(
                          child: _getHealthRecordTypeView(record)
                              .marginOnly(left: Dimen.d_20),
                        );
                      }).toList(),
                    ),
                  );
                }
              }),
            ),
          ),
        ],
      ).marginAll(Dimen.d_20),
    );
  }

  Widget _getHospitalDetailView(
    EncounterLocalModel? encounterLocalModel,
    String hipName,
    String date,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: WidgetUtility.spreadWidgets(
        [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomSvgImageView(
                  ImageLocalAssets.hospital,
                  width: Dimen.d_23,
                  height: Dimen.d_16,
                ).marginOnly(right: Dimen.d_10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hipName,
                      style: CustomTextStyle.bodySmall(context)?.apply(
                        color: AppColors.colorBlack,
                        fontWeightDelta: 1,
                        fontSizeDelta: 1,
                      ),
                    ),
                    Text(
                      encounterLocalModel?.status ?? '',
                      style: CustomTextStyle.labelLarge(context)?.apply(
                        color: AppColors.colorGreyDark5,
                        fontSizeDelta: -1,
                        fontWeightDelta: -1,
                      ),
                    ).marginOnly(top: Dimen.d_5),
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const CustomSvgImageView(
                ImageLocalAssets.calendar,
              ).marginOnly(right: Dimen.d_10),
              Text(
                Validator.isNullOrEmpty(date) ? '-' : date.formatDDMMMMYYYY,
                style: CustomTextStyle.labelLarge(context)?.apply(
                  color: AppColors.colorGreyDark5,
                  fontSizeDelta: -1,
                  fontWeightDelta: -1,
                ),
              ).marginOnly(right: Dimen.d_10),
              const CustomSvgImageView(
                ImageLocalAssets.time,
              ).marginOnly(right: Dimen.d_10),
              Text(
                Validator.isNullOrEmpty(date) ? '-' : date.formatHHMMA,
                style: CustomTextStyle.labelLarge(context)?.apply(
                  color: AppColors.colorGreyDark5,
                  fontSizeDelta: -1,
                  fontWeightDelta: -1,
                ),
              ),
            ],
          )
        ],
        interItemSpace: 10,
        flowHorizontal: false,
      ),
    );
  }

  Widget _getHealthRecordTypeView(HealthRecordTypeLocalModel healthRecordType) {
    String? resourceType = healthRecordType.resourceType;
    ResourceType resourceTypeEnum =
        _healthRecordController.getResourceType(resourceType);

    switch (resourceTypeEnum) {
      case ResourceType.procedure:
        return HealthRecordTypeDesktopView.procedure(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          data: healthRecordType.codeText ?? '',
          date: healthRecordType.performedDateTime ?? '',
        );
      case ResourceType.condition:
        return HealthRecordTypeDesktopView.condition(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          description: healthRecordType.codeText ?? '',
        );
      case ResourceType.documentreference:
        return HealthRecordTypeDesktopView.document(
          context,
          title: healthRecordType.codingDisplay ??
              resourceType.toString().convertPascalCaseString,
          contentAttachment:
              healthRecordType.healthRecordContentAttachment ?? [],
          onClick: (contentData, contentType, url) {
            String fileName = healthRecordType.codingDisplay ??
                resourceType.toString().convertPascalCaseString;
            _healthRecordController.showAttachment(
              context,
              consentId,
              contentData,
              url,
              contentType,
              fileName,
            );
          },
        );

      case ResourceType.medicationrequest:
        return HealthRecordTypeDesktopView.medicationRequest(
          context,
          title: healthRecordType.medicationCodeAbleConceptText ??
              resourceType.toString().convertPascalCaseString,
          data: healthRecordType.dosageInstruction ?? [],
        );

      case ResourceType.allergyintolerance:
        return HealthRecordTypeDesktopView.allergyIntolerance(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          notes: healthRecordType.notes,
        );

      case ResourceType.careplan:
        return HealthRecordTypeDesktopView.carePlan(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          intent: healthRecordType.intent ?? '',
          description: healthRecordType.description ?? '',
          entry: healthRecordType.dataEntry ?? [],
        );

      case ResourceType.diagnosticreport:
        return HealthRecordTypeDesktopView.diagnosticReport(
          context,
          title: healthRecordType.codeText ??
              resourceType.toString().convertPascalCaseString,
          data: healthRecordType.conclusion ?? '',
          presentedForm: healthRecordType.presentedForm ?? [],
          onClick: (contentData, contentType, url) {
            String fileName = healthRecordType.codeText ??
                resourceType.toString().convertPascalCaseString;
            _healthRecordController.showAttachment(
              context,
              consentId,
              contentData,
              url,
              contentType,
              fileName,
            );
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
