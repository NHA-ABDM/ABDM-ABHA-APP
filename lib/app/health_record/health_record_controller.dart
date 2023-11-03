import 'dart:io';
import 'package:abha/app/health_record/controller/health_records_api_fetch_controller.dart';
import 'package:abha/app/health_record/controller/health_records_data_save_controller.dart';
import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;

enum HealthRecordUpdateUiBuilderIds {
  healthRecordDetails,
}

class HealthRecordController extends BaseController {
  late HealthRecordApiFetchController _healthRecordApiFetchController;
  late HealthRecordDataSaveController _healthRecordDataSaveController;
  List<HealthRecordLocalModel> healthDataEntry = [];
  bool isHealthRecordCalledOnce = false;

  HealthRecordController(HealthRecordRepoImpl repo)
      : super(HealthRecordController) {
    _healthRecordDataSaveController = HealthRecordDataSaveController();
    _healthRecordApiFetchController =
        HealthRecordApiFetchController(repo, _healthRecordDataSaveController);
    _getHealthRecordsEntries();
  }

  void _getHealthRecordsEntries() {
    healthDataEntry = _healthRecordDataSaveController.healthRecordBox.values
        .toList()
        .cast<HealthRecordLocalModel>();
  }

  bool getEmptyHip() {
    return _healthRecordApiFetchController.isHipLinkEmpty;
  }

  Future<void> getDataOnPullRecords(
    List hIPIdList,
    BuildContext context,
  ) async {
    _healthRecordApiFetchController.isHipLinkEmpty = true;
    await _healthRecordDataSaveController.saveLinkedHipDataLocally(hIPIdList);
    // await getUserHealthRecords();
    // or
    await _healthRecordApiFetchController.getConsentRequest(hIPIdList);
    _getHealthRecordsEntries();
  }

  Future<void> getUserHealthRecords() async {
    isHealthRecordCalledOnce = true;
    Map? hipLinkedData =
        _healthRecordDataSaveController.linkedHipBox.values.firstOrNull;
    Map? hipConsentData =
        _healthRecordDataSaveController.hipConsentBox.values.firstOrNull;

    if (Validator.isNullOrEmpty(hipLinkedData)) {
      // STEP-1 We do not have linked hip details.
      await _healthRecordApiFetchController.callPatientLinkedHip();
    } else if (Validator.isNullOrEmpty(hipConsentData)) {
      // STEP-2 We have linked hip details in local db but we do not have linked hip consent data.
      List<Map> hipIdDataList = [];
      for (var key in hipLinkedData!.keys) {
        hipIdDataList.add({
          ApiKeys.responseKeys.hip: {ApiKeys.responseKeys.id: key}
        });
      }
      await _healthRecordApiFetchController.getConsentRequest(hipIdDataList);
    } else {
      // STEP-3 We have linked hip details and linked hip consent data in local db.
      List erroredHipIdList =
          _healthRecordDataSaveController.erroredHipBox.values.firstOrNull ??
              [];
      List allHipIdExceptErrored = _healthRecordApiFetchController
          .getAllHipExceptErrored(hipConsentData!, erroredHipIdList);
      List<Map> allErrorHipId = _healthRecordApiFetchController
          .getAllErroredHip(hipConsentData, erroredHipIdList);
      if (!Validator.isNullOrEmpty(allHipIdExceptErrored)) {
        Map allHipExceptErroredReq = {};
        for (var element in allHipIdExceptErrored) {
          allHipExceptErroredReq[element] = hipConsentData[element];
        }
        _healthRecordApiFetchController.responseData = allHipExceptErroredReq;
        await _healthRecordApiFetchController
            .startHealthInformationStatusAndFetch();
      }
      // STEP-4 Call consent request for errored hip
      if (!Validator.isNullOrEmpty(allErrorHipId)) {
        await _healthRecordApiFetchController.getConsentRequest(allErrorHipId);
      }
    }
    _getHealthRecordsEntries();
  }

  void searchHealthRecord(String searchValue) {
    if (Validator.isNullOrEmpty(searchValue)) {
      _getHealthRecordsEntries();
    } else {
      healthDataEntry = _healthRecordDataSaveController.healthRecordBox.values
          .where(
            (element) =>
                element.hipName?.toLowerCase().trim().contains(searchValue) ??
                false,
          )
          .toList()
          .cast<HealthRecordLocalModel>();
    }
  }

  Map<String, List<HealthRecordLocalModel>> getHealthRecordBasedOnDate() {
    Map<String, List<HealthRecordLocalModel>> healthRecordMap = {};
    if (!Validator.isNullOrEmpty(healthDataEntry)) {
      healthDataEntry.sort((a, b) {
        return b.date?.compareTo(a.date ?? '') ?? 0;
      });
      String date = healthDataEntry.elementAt(0).date.toString();
      List<HealthRecordLocalModel> tempHealthDataList = [];
      for (int i = 0; i < healthDataEntry.length; i++) {
        String tempDate = healthDataEntry[i].date.toString();
        if (date == tempDate) {
          tempHealthDataList.add(healthDataEntry[i]);
        } else {
          healthRecordMap[date] = tempHealthDataList;
          tempHealthDataList = [];
          date = tempDate;
          // to add the last value
          tempHealthDataList.add(healthDataEntry[i]);
          healthRecordMap[date] = tempHealthDataList;
        }
      }
      healthRecordMap[date] = tempHealthDataList;
    }
    return healthRecordMap;
  }

  Future<void> showAttachment(
    BuildContext context,
    String consentId,
    String contentData,
    String urlPath,
    String contentType,
    String fileName,
  ) async {
    if (!Validator.isNullOrEmpty(contentData)) {
      if (contentType.contains('pdf')) {
        _showPdf(contentData, fileName);
      } else {
        _showImage(context, contentData);
      }
    } else if (!Validator.isNullOrEmpty(urlPath)) {
      downloadAttachment(consentId, urlPath, fileName, contentType);
    } else {
      MessageBar.showToastSuccess(
        LocalizationHandler.of().unableToCompleteRequest,
      );
    }
  }

  Future<void> downloadAttachment(
    String consentId,
    String url,
    String fileName,
    String contentType,
  ) async {
    await functionHandler(
      function: () => _healthRecordApiFetchController.downloadFile(
        consentId,
        url,
        fileName,
        contentType,
      ),
      isLoaderReq: true,
    );
    // if (abhaSingleton.getAppData.getHealthRecordFetched()) {
    //
    // } else {
    //   MessageBar.showToastDialog(LocalizationHandler.of().pleaseWaitForRecord);
    // }
  }

  void _showImage(BuildContext context, String contentData) async {
    context.openDialog(
      CustomSimpleDialog(
        size: 10,
        title: LocalizationHandler.of().healthRecord,
        paddingLeft: Dimen.d_15,
        showCloseButton: true,
        child: Image.memory(
          base64Decode(contentData),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _showPdf(String contentData, String fName) async {
    CustomDialog.showCircularDialog();
    String fileName = '$fName.pdf';
    if (kIsWeb) {
      html.AnchorElement anchorElement =
          html.AnchorElement(href: 'data:application/pdf;base64,$contentData');
      anchorElement.download = fileName;
      anchorElement.click();
    } else {
      var bytes = base64Decode(contentData);
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$fileName');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      await OpenFile.open('${output.path}/$fileName');
    }
    CustomDialog.dismissDialog();
  }

  ResourceType getResourceType(String? resourceType) {
    ResourceType resourceTypeEnum = ResourceType.values.firstWhere(
      (e) => describeEnum(e) == resourceType?.toLowerCase(),
      orElse: () => ResourceType.defaultvalue,
    );
    return resourceTypeEnum;
  }
}
