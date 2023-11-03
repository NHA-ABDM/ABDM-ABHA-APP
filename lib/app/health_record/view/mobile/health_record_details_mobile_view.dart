import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/app/health_record/widget/health_record_type_view.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

class HealthRecordDetailMobileView extends StatefulWidget {
  final List<HealthRecordLocalModel> healthDataEntryList;
  final int currentPage;

  const HealthRecordDetailMobileView({
    required this.healthDataEntryList,
    required this.currentPage,
    super.key,
  });

  @override
  HealthRecordDetailMobileViewState createState() =>
      HealthRecordDetailMobileViewState();
}

class HealthRecordDetailMobileViewState
    extends State<HealthRecordDetailMobileView> {
  late HealthRecordController _healthRecordController;
  List<HealthRecordLocalModel> _healthDataEntryList = [];
  int _currentPage = 0;
  String consentId = '';
  final PageController _pageController = PageController();

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.jumpToPage(_currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? _dashboardDetailWidget().sizedBox(height: Dimen.d_500)
        : _dashboardDetailWidget();
  }

  Widget _dashboardDetailWidget() {
    return Column(
      children: [
        PageView.builder(
          itemCount: _healthDataEntryList.length,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (page) {},
          itemBuilder: (context, position) {
            EncounterLocalModel? encounterLocalModel =
                _healthDataEntryList.elementAt(position).encounterLocalModel;
            List<HealthRecordTypeLocalModel> healthRecordTypes =
                _healthDataEntryList.elementAt(position).healthRecordType ?? [];
            consentId = _healthDataEntryList[position].consentRequestId ?? '';
            String hipName =
                _healthDataEntryList.elementAt(position).hipName ?? '';
            String date = _healthDataEntryList.elementAt(position).date ?? '';
            return SingleChildScrollView(
              child: Column(
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
                  if (!Validator.isNullOrEmpty(healthRecordTypes)) {
                    for (var element in healthRecordTypes) {
                      children.add(_getHealthRecordTypeView(element));
                    }
                  }
                }),
              ),
            );
          },
        ).expand(),
        _pageChangeWidget()
      ],
    ).paddingSymmetric(horizontal: Dimen.d_15, vertical: Dimen.d_15);
  }

  Widget _getHospitalDetailView(
    EncounterLocalModel? encounterLocalModel,
    String hipName,
    String date,
  ) {
    abhaLog.i('Date is $date');
    return Container(
      decoration: abhaSingleton.getBorderDecoration.getRectangularBorder(
        borderColor: AppColors.colorPurple3,
        size: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: WidgetUtility.spreadWidgets(
          [
            Row(
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
                        // color: AppColors.colorAppBlue,
                        fontWeightDelta: 2,
                      ),
                    ),
                    Text(
                      encounterLocalModel?.status ?? '',
                      style: CustomTextStyle.labelMedium(context)?.apply(
                        color: AppColors.colorGreyDark7,
                        fontWeightDelta: 1,
                      ),
                    ).marginOnly(top: Dimen.d_5),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CustomSvgImageView(
                  ImageLocalAssets.calendar,
                ).marginOnly(right: Dimen.d_10),
                Text(
                  Validator.isNullOrEmpty(date) ? '-' : date.formatDDMMMMYYYY,
                  style: CustomTextStyle.labelMedium(context)?.apply(
                    color: AppColors.colorGreyDark7,
                    fontWeightDelta: 1,
                  ),
                ).marginOnly(right: Dimen.d_10),
                const CustomSvgImageView(
                  ImageLocalAssets.time,
                ).marginOnly(right: Dimen.d_10),
                Text(
                  Validator.isNullOrEmpty(date) ? '-' : date.formatHHMMA,
                  style: CustomTextStyle.labelMedium(context)?.apply(
                    color: AppColors.colorGreyDark7,
                    fontWeightDelta: 1,
                  ),
                ),
              ],
            )
          ],
          interItemSpace: 10,
          flowHorizontal: false,
        ),
      ).paddingSymmetric(
        horizontal: Dimen.d_18,
        vertical: Dimen.d_18,
      ),
    ).marginOnly(bottom: Dimen.d_10);
  }

  Widget _getHealthRecordTypeView(HealthRecordTypeLocalModel healthRecordType) {
    String? resourceType = healthRecordType.resourceType;
    ResourceType resourceTypeEnum =
        _healthRecordController.getResourceType(resourceType);
    switch (resourceTypeEnum) {
      case ResourceType.procedure:
        return HealthRecordTypeView.procedure(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          data: healthRecordType.codeText ?? '',
          date: healthRecordType.performedDateTime ?? '',
        );
      case ResourceType.condition:
        return HealthRecordTypeView.condition(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          description: healthRecordType.codeText ?? '',
        );
      case ResourceType.documentreference:
        return HealthRecordTypeView.document(
          context,
          title: healthRecordType.codingDisplay ??
              resourceType.toString().convertPascalCaseString,
          contentAttachment:
              healthRecordType.healthRecordContentAttachment ?? [],
          onClick: (contentData, contentType, String url) {
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
        return HealthRecordTypeView.medicationRequest(
          context,
          title: healthRecordType.medicationCodeAbleConceptText ??
              resourceType.toString().convertPascalCaseString,
          data: healthRecordType.dosageInstruction ?? [],
        );

      case ResourceType.allergyintolerance:
        return HealthRecordTypeView.allergyIntolerance(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          notes: healthRecordType.notes,
        );

      case ResourceType.careplan:
        return HealthRecordTypeView.carePlan(
          context,
          title: healthRecordType.title ??
              resourceType.toString().convertPascalCaseString,
          intent: healthRecordType.intent ?? '',
          description: healthRecordType.description ?? '',
          entry: healthRecordType.dataEntry ?? [],
        );

      case ResourceType.diagnosticreport:
        return HealthRecordTypeView.diagnosticReport(
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

  Widget _pageChangeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            if (_currentPage != 0 &&
                _currentPage < _healthDataEntryList.length) {
              _currentPage--;
              _pageController.jumpToPage(_currentPage);
              _healthRecordController.update();
            }
          },
          icon: const Icon(
            IconAssets.navigatePrv,
          ),
        ),
        GetBuilder<HealthRecordController>(
          builder: (_) {
            return Text(
              '${_currentPage + 1}/${_healthDataEntryList.length}',
              style: CustomTextStyle.bodySmall(context)?.apply(),
            );
          },
        ),
        IconButton(
          onPressed: () {
            if (_currentPage < _healthDataEntryList.length - 1) {
              _currentPage++;
              _pageController.jumpToPage(_currentPage);
              _healthRecordController.update();
            }
          },
          icon: const Icon(
            IconAssets.navigateNext,
          ),
        ),
      ],
    ).paddingSymmetric(vertical: Dimen.d_5);
  }
}
