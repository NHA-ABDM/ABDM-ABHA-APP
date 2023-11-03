import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:abha/database/local_db/hive/boxes.dart';
import 'package:abha/export_packages.dart';
import 'package:hive/hive.dart';

class HealthRecordDataSaveController {
  Box<HealthRecordLocalModel> healthRecordBox = HiveBoxes().getHealthRecords();
  Box<Map> linkedHipBox = HiveBoxes().getLinkedHipBox();
  Box<Map> hipConsentBox = HiveBoxes().getHipConsentData();
  Box<List> erroredHipBox = HiveBoxes().getErroredHipBox();
  late List<HealthDataEntries> healthDataEntries;

  Future<void> initLocalDbProcess({HealthRecordModel? hRModel}) async {
    if (!healthRecordBox.isOpen) {
      return;
    }
    healthDataEntries = hRModel?.healthDataEntries ?? [];
    _deleteSameData();
    await _addHealthRecordLocally();
  }

  void _deleteSameData() {
    List hipIds = [];
    for (var healthDataEntries in healthDataEntries) {
      hipIds.add(healthDataEntries.hipId ?? healthDataEntries.docOriginId);
    }
    var healthRecordLocalModelList = healthRecordBox.values.toList();
    if (!Validator.isNullOrEmpty(healthRecordLocalModelList)) {
      for (var element in healthRecordLocalModelList) {
        if (hipIds.contains(element.hipId)) {
          healthRecordBox.deleteAt(healthRecordLocalModelList.indexOf(element));
          healthRecordLocalModelList = healthRecordBox.values.toList();
        }
      }
    }
  }

  Future<void> _addHealthRecordLocally() async {
    for (var healthDataEntry in healthDataEntries) {
      List<DataEntry> dataEntry = healthDataEntry.bundleData?.entry ?? [];
      final healthRecordTypeLocalModel =
          _setUpHealthRecordTypeLocalModel(dataEntry);
      final encounterLocalModel = _setUpEncounterLocalModel(dataEntry);
      await _saveHealthRecordLocalModel(
        dataEntry,
        healthDataEntry,
        encounterLocalModel,
        healthRecordTypeLocalModel,
      );
    }
  }

  List<HealthRecordTypeLocalModel> _setUpHealthRecordTypeLocalModel(
    List<DataEntry> dataEntry,
  ) {
    List<HealthRecordTypeLocalModel> healthRecordTypeLocalModelList = [];
    // List<Section> healthSectionObjList = _getHealthDataSection(dataEntry);
    for (var entry in dataEntry) {
      // DataEntry tempEntry = dataEntry.firstWhere(
      //   (entry) => entry.fullUrl == section.entry?.first.reference,
      // );
      Resource? resource = entry.resource;
      final dataEntryLocalModel =
          _setUpDataEntryLocalModel(resource, dataEntry);
      final presentedFormLocalModel = _setUpPresentedFormLocalModel(resource);
      final contentDocumentFormLocalModel =
          _setUpContentDocumentLocalModel(resource);

      final healthRecordTypeLocalModel = HealthRecordTypeLocalModel()
        ..resourceType = resource?.resourceType
        ..title = resource?.title
        ..medicationCodeAbleConceptText = resource?.medicationCodeableConcept?.text
        ..dosageInstruction = resource?.dosageInstruction?.map((e) => e.text ?? '').toList()
        ..codeText = resource?.code?.text
        ..conclusion = resource?.conclusion
        ..codingDisplay = resource?.type?.coding?.first.display
        ..notes = resource?.note?.map((e) => e.text ?? '').toList()
        ..performedDateTime = resource?.performedDateTime
        ..intent = resource?.intent
        ..description = resource?.description
        ..dataEntry = dataEntryLocalModel
        ..presentedForm = presentedFormLocalModel
        ..healthRecordContentAttachment = contentDocumentFormLocalModel;
      healthRecordTypeLocalModelList.add(healthRecordTypeLocalModel);
    }
    return healthRecordTypeLocalModelList;
  }

  // List<Section> _getHealthDataSection(List<DataEntry> dataEntry) {
  //   List<Section> healthSectionObjList = [];
  //   for (int i = 0; i < dataEntry.length; i++) {
  //     List<Section> section = dataEntry[i].resource?.section ?? [];
  //     for (int j = 0; j < section.length; j++) {
  //       healthSectionObjList.add(section[j]);
  //     }
  //   }
  //   return healthSectionObjList;
  // }

  List<DataEntryLocalModel>? _setUpDataEntryLocalModel(
    Resource? resource,
    List<DataEntry> allDataEntry,
  ) {
    List<DataEntryLocalModel> dataEntryLocalModelList = [];
    if (resource?.activity != null) {
      List<DataEntry> entry = allDataEntry
          .where(
            (element) =>
                element.fullUrl ==
                resource?.activity?.first.outcomeReference?.first.reference,
          )
          .toList();
      if (!Validator.isNullOrEmpty(entry)) {
        for (var data in entry) {
          final dataEntryLocalModel = DataEntryLocalModel()
            ..fullUrl = data.fullUrl
            ..startDate = data.resource?.start
            ..endDate = data.resource?.end;
          dataEntryLocalModelList.add(dataEntryLocalModel);
        }
      }
    }
    return dataEntryLocalModelList;
  }

  List<PresentedFormLocalModel>? _setUpPresentedFormLocalModel(
    Resource? resource,
  ) {
    List<PresentedFormLocalModel> presentedFormLocalModelList = [];
    List<PresentedForm> presentedForm = resource?.presentedForm ?? [];
    if (!Validator.isNullOrEmpty(presentedForm)) {
      for (var data in presentedForm) {
        final presentedFormLocalModel = PresentedFormLocalModel()
          ..contentType = data.contentType
          ..contentData = data.data
          ..language = data.language
          ..url = data.url;
        presentedFormLocalModelList.add(presentedFormLocalModel);
      }
    }
    return presentedFormLocalModelList;
  }

  List<ContentAttachmentLocalModel>? _setUpContentDocumentLocalModel(
    Resource? resource,
  ) {
    List<ContentAttachmentLocalModel> contentAttachmentLocalModelList = [];
    List<Content> content = resource?.content ?? [];
    if (!Validator.isNullOrEmpty(content)) {
      for (var data in content) {
        final contentAttachmentLocalModel = ContentAttachmentLocalModel()
          ..contentType = data.attachment?.contentType
          ..language = data.attachment?.language
          ..url = data.attachment?.url
          ..size = data.attachment?.size
          ..title = data.attachment?.title
          ..creation = data.attachment?.creation
          ..contentData = data.attachment?.data;
        contentAttachmentLocalModelList.add(contentAttachmentLocalModel);
      }
    }
    return contentAttachmentLocalModelList;
  }

  EncounterLocalModel _setUpEncounterLocalModel(List<DataEntry> dataEntry) {
    Resource? initialResource = dataEntry.first.resource;
    Resource? encounter;
    if (initialResource?.encounter != null) {
      encounter = dataEntry
          .firstWhere(
            (entry) => entry.fullUrl == initialResource?.encounter?.reference,
          )
          .resource;
    }
    Custodian? custodian = initialResource?.custodian;
    final encounterLocalModel = EncounterLocalModel()
      ..custodianName = custodian?.display
      ..status = encounter?.classCode?.display
      ..date = encounter?.period?.start;
    return encounterLocalModel;
  }

  Future<String> _getHipName(String? hipId) async {
    if (!Validator.isNullOrEmpty(hipId)) {
      Response? response = await abhaSingleton.getApiProvider.request(
        method: APIMethod.get,
        url: '${ApiPath.hipProvidersApi}/$hipId',
      );
      Map data = response?.data;
      String hipName =
          data[ApiKeys.responseKeys.identifier][ApiKeys.responseKeys.name];
      return Future.value(hipName);
    } else {
      return Future.value('');
    }
  }

  // save health record in local db
  Future<void> _saveHealthRecordLocalModel(
    List<DataEntry> dataEntry,
    HealthDataEntries healthDataEntry,
    EncounterLocalModel encounterLocalModel,
    List<HealthRecordTypeLocalModel> healthRecordTypeLocalModelList,
  ) async {
    final hRLocalModel = HealthRecordLocalModel()
      ..date = healthDataEntry.bundleData?.timestamp
      ..hipName = await _getHipName(
        healthDataEntry.hipId ?? healthDataEntry.docOriginId,
      )
      ..hipId = healthDataEntry.hipId ?? healthDataEntry.docOriginId
      ..consentRequestId = healthDataEntry.consentRequestId
      ..consentArtefactId = healthDataEntry.consentArtefactId
      ..status = healthDataEntry.status
      ..encounterLocalModel = encounterLocalModel
      ..healthRecordType = healthRecordTypeLocalModelList;
    int key = await healthRecordBox.add(hRLocalModel);
  }

  // save linked hip ids in local db
  Future<void> saveLinkedHipDataLocally(List hipLinksData) async {
    Map hipData = {};
    for (var data in hipLinksData) {
      String hipId = data[ApiKeys.responseKeys.hip][ApiKeys.responseKeys.id];
      String hipName =
          data[ApiKeys.responseKeys.hip][ApiKeys.responseKeys.name];
      hipData[hipId] = hipName;
    }
    Map hipLinkedData = linkedHipBox.values.firstOrNull ?? {};
    hipLinkedData.addAll(hipData);
    await linkedHipBox.clear();
    await linkedHipBox.add(hipLinkedData);
  }

  // save consent ids of linked hips ids in local db
  Future<void> saveConsentDataLocally(Map consentData) async {
    Map hipConsentData = hipConsentBox.values.firstOrNull ?? {};
    hipConsentData.addAll(consentData);
    await hipConsentBox.clear();
    await hipConsentBox.add(hipConsentData);
  }

  // save consent ids which got error status of linked hips ids in local db
  Future<void> saveErroredHipDataLocally(List<String> hIERequestIds) async {
    List erroredHipList = erroredHipBox.values.firstOrNull ?? [];
    erroredHipList.addAll(hIERequestIds);
    await erroredHipBox.clear();
    await erroredHipBox.add(erroredHipList);
  }
}
