import 'dart:io';

import 'package:abha/app/health_record/controller/health_records_data_save_controller.dart';
import 'package:abha/export_packages.dart';

class HealthRecordApiFetchController {
  /*
* This status is useful to optimise the data call.
* When user requested their health record consent manager(CM)  will connect to
* HIU raise the request for the user health records or reports.
* Health reports wont be available immediately right after the consent request created
* so following status are health data status at the CM
* */
  final String _processing = 'PROCESSING';
  final String _requested = 'REQUESTED';
  final String _succeeded = 'SUCCEEDED';
  final String _received = 'RECEIVED';
  final String _partial = 'PARTIAL';
  final String _errored = 'ERRORED';

  late HealthRecordRepo _healthRecordRepo;
  bool _isTimeOver = false;
  final bool _isReloadConsent = true;
  final List<String> _hISRequestIds = [];
  final List<String> _hIFRequestIds = [];
  final List<String> _hIPRequestIds = [];
  final List<String> _hIERequestIds = [];
  final List<String> _hIShIPId = [];
  final List<String> _hIPIdFailed = [];
  Map healthRecordStatusResp = {};
  String errorMsg = '';
  String dataLoadingMsg = LocalizationHandler.of().fetchingRecord;
  String dataSyncingMsg = LocalizationHandler.of().syncingRecords;
  Timer? _timer;
  final FileService _fileService = FileServiceImpl();
  late HealthRecordDataSaveController _healthRecordDataSaveController;
  bool isHipLinkEmpty = false;
  dynamic responseData;

  HealthRecordApiFetchController(
    HealthRecordRepoImpl repo,
    HealthRecordDataSaveController hRDSController,
  ) {
    _healthRecordRepo = repo;
    _healthRecordDataSaveController = hRDSController;
  }

  void _init() {
    errorMsg = '';
    _isTimeOver = false;
  }

  Future<void> callPatientLinkedHip() async {
    responseData = await _healthRecordRepo.callPatientsLinkedHip();
    String tempData = jsonEncode(responseData[ApiKeys.responseKeys.patient]);
    List hipLinksData =
        List.from(jsonDecode(tempData)[ApiKeys.responseKeys.links]);
    if (Validator.isNullOrEmpty(hipLinksData)) {
      isHipLinkEmpty = true;
      _setHealthErrorInfo(LocalizationHandler.of().noLinkedHips);
    } else {
      await _healthRecordDataSaveController
          .saveLinkedHipDataLocally(hipLinksData);
      await getConsentRequest(hipLinksData);
    }
  }

  Future<void> getConsentRequest(List hipLinksData) async {
    responseData = await _healthRecordRepo
        .callConsentRequest(_consentRequestData(hipLinksData));
    if (Validator.isNullOrEmpty(responseData)) {
      _setHealthErrorInfo(LocalizationHandler.of().consentDataNotFound);
    } else {
      await _healthRecordDataSaveController
          .saveConsentDataLocally(responseData);
      await startHealthInformationStatusAndFetch();
    }
  }

  List getAllHipExceptErrored(
    Map localConsentData,
    List hipErroredRequestIdList,
  ) {
    List tempAllHipIdExceptErrored = [];
    for (var key in localConsentData.keys) {
      tempAllHipIdExceptErrored.add(key);
    }
    for (var key in localConsentData.keys) {
      if (!Validator.isNullOrEmpty(hipErroredRequestIdList)) {
        for (var value in hipErroredRequestIdList) {
          if (key == value) {
            tempAllHipIdExceptErrored.remove(value);
          }
        }
      }
    }
    return tempAllHipIdExceptErrored;
  }

  List<Map> getAllErroredHip(
    Map localConsentData,
    List hipErroredRequestIdDataList,
  ) {
    var tempErrorHipReq = <Map>[];
    for (var key in localConsentData.keys) {
      if (!Validator.isNullOrEmpty(hipErroredRequestIdDataList)) {
        for (var value in hipErroredRequestIdDataList) {
          if (key == value) {
            tempErrorHipReq.add({
              ApiKeys.responseKeys.hip: {ApiKeys.responseKeys.id: value}
            });
          }
        }
      }
    }
    return tempErrorHipReq;
  }

  Future<void> startHealthInformationStatusAndFetch() async {
    _setExpiryTimeForHISApi();
    _init();
    _hISRequestData();
    await _getHealthInformationStatus(seconds: 0);
    await _getHealthInformationFetch();
    await _setErroredHip();
    await _showFailedHips();
    _timer?.cancel();
  }

  Future<void> _getHealthInformationStatus({int seconds = 10}) async {
    await Future.delayed(Duration(seconds: seconds), () async {
      var hISRequestData = {ApiKeys.requestKeys.requestIds: _hISRequestIds};
      healthRecordStatusResp =
          await _healthRecordRepo.callHealthInformationStatus(hISRequestData);
    });
    await _hISResponseHandler();
    _hISRequestIds.clear();
  }

  Future<void> _getHealthInformationFetch() async {
    // Comment below hardcoded code once fetch api is available.
    // String hIFEncodedData = await DefaultAssetBundle.of(navKey.currentState!.context).loadString('assets/json/healthRecord.json');
    // final healthRecordModel = healthRecordFromMap(hIFEncodedData);
    // await _healthRecordDataSaveController.initLocalDbProcess(hRModel: healthRecordModel);
    // _hIFRequestIds.clear();

    if (!Validator.isNullOrEmpty(_hIFRequestIds)) {
      Map hIFRespData =
          await _healthRecordRepo.callHealthInformationFetch(_hIFRequestData());
      String hIFEncodedData = jsonEncode(hIFRespData);
      final healthRecordModel = healthRecordFromMap(hIFEncodedData);
      await _healthRecordDataSaveController.initLocalDbProcess(
        hRModel: healthRecordModel,
      );
      _hIFRequestIds.clear();
    }
  }

  Future<void> _setErroredHip() async {
    await _healthRecordDataSaveController
        .saveErroredHipDataLocally(_hIERequestIds);
    _hIERequestIds.clear();
  }

  Future<void> _hISResponseHandler() async {
    String tempData = jsonEncode(healthRecordStatusResp);
    List statusesData = jsonDecode(tempData)[ApiKeys.responseKeys.statuses];
    if (Validator.isNullOrEmpty(statusesData)) {
      _setHealthErrorInfo(LocalizationHandler.of().unableToFetchHealthRecord);
      _hIERequestIds.clear();
      for (var key in responseData.keys) {
        _hIERequestIds.add(key);
      }
    } else {
      List hipIdDataList = List.from(statusesData);
      _hIShIPId.clear();
      _hISRequestIds.clear();
      for (var data in hipIdDataList) {
        String hipIdData = data[ApiKeys.responseKeys.hipId];
        String requestIdData = data[ApiKeys.responseKeys.requestId];
        String statusData = data[ApiKeys.responseKeys.status];
        if (statusData == _processing || statusData == _requested) {
          _hISRequestIds.add(requestIdData);
          _hIShIPId.add(hipIdData);
        } else if (statusData == _succeeded || statusData == _received) {
          _hIFRequestIds.add(requestIdData);
        } else if (statusData == _partial) {
          _hIPRequestIds.add(requestIdData);
          _hIPIdFailed.add(hipIdData);
        } else if (statusData == _errored) {
          _hIERequestIds.add(hipIdData);
          _hIPIdFailed.add(hipIdData);
        } else {}
      }
      // for retrying to check the status of the record
      if (_isTimeOver) {
        _hIPIdFailed.addAll(_hIShIPId);
      } else if (!Validator.isNullOrEmpty(_hISRequestIds)) {
        await _getHealthInformationStatus();
      }
    }
  }

  Future<void> _showFailedHips() async {
    if (!Validator.isNullOrEmpty(_hIPIdFailed)) {
      Map? hipLinkedData =
          _healthRecordDataSaveController.linkedHipBox.values.firstOrNull;
      if (!Validator.isNullOrEmpty(hipLinkedData)) {
        List<String> hipName = [];
        int i = 0;
        for (var key in hipLinkedData!.keys) {
          if (_hIPIdFailed.contains(key)) {
            i++;
            hipName.add('${i.toString()} - ${hipLinkedData[key]}\n');
          }
        }
        String failedHips = '';
        if (!Validator.isNullOrEmpty(hipName)) {
          failedHips = hipName.reduce((value, element) {
            return value + element;
          });
        }
        String timeout = '';
        String msg = '';
        if (_isTimeOver) {
          timeout = '${LocalizationHandler.of().timeOut},';
        }
        if (Validator.isNullOrEmpty(
          _healthRecordDataSaveController.healthRecordBox.values,
        )) {
          msg = LocalizationHandler.of().noRecordForHips;
        } else {
          msg = LocalizationHandler.of().noNewRecordForHips;
        }
        _setHealthErrorInfo(
          '$timeout\n$msg. \n\n$failedHips',
        );
      }
      _hIPIdFailed.clear();
    }
  }

  void _setExpiryTimeForHISApi() {
    _timer = Timer(const Duration(minutes: 1), () {
      _isTimeOver = true;
    });
  }

  void _setHealthErrorInfo(String msg) {
    errorMsg = msg;
  }

  Future<void> downloadFile(
    String consentId,
    String urlPath,
    String fName,
    String contentType,
  ) async {
    String fileName = contentType.contains('pdf') ? '$fName.pdf' : '$fName.png';
    List<int> response =
        await _healthRecordRepo.callDownloadFile(consentId, urlPath);
    Uint8List? bytes = Uint8List.fromList(response);

    File? file = await _fileService.writeToStorage(
      fileName: fileName,
      data: bytes,
      directoryType: DirectoryType.download,
    );
    try {
      OpenFile.open(file?.path);
    } catch (e) {
      abhaLog.e(e.toString());
    }
  }

  //  ---------------------------REQUEST DATA BODY -----------------------------------

  Map _consentRequestData(List hipLinksData) {
    Set<String> hipIds = {};
    for (var hipData in hipLinksData) {
      String hipId = hipData[ApiKeys.responseKeys.hip][ApiKeys.responseKeys.id];
      hipIds.add(hipId);
    }
    var consentData = {
      ApiKeys.requestKeys.hipIds: List<String>.from(hipIds),
      ApiKeys.requestKeys.reloadConsent: _isReloadConsent,
    };
    return consentData;
  }

  void _hISRequestData() {
    for (var key in responseData.keys) {
      _hISRequestIds.add(responseData[key]);
    }
  }

  Map _hIFRequestData() {
    var hIFData = {
      ApiKeys.requestKeys.limit: 200,
      ApiKeys.requestKeys.offset: 0,
      ApiKeys.requestKeys.requestIds: _hIFRequestIds
    };
    return hIFData;
  }
}
