import 'dart:convert';
import 'package:hive/hive.dart';
part 'health_record_local_model.g.dart';

@HiveType(typeId: 0)
class HealthRecordLocalModel extends HiveObject {
  @HiveField(0)
  String? date;
  @HiveField(1)
  String? hipName;
  @HiveField(2)
  String? hipId;
  @HiveField(3)
  String? consentRequestId;
  @HiveField(4)
  String? consentArtefactId;
  @HiveField(5)
  String? status;
  @HiveField(6)
  EncounterLocalModel? encounterLocalModel;
  @HiveField(7)
  List<HealthRecordTypeLocalModel>? healthRecordType;

  @override
  String toString() {
    return jsonEncode({
      'date': date,
      'hipName': hipName,
      'hipId': hipId,
      'consentRequestId': consentRequestId,
      'consentArtefactId': consentArtefactId,
      'status': status,
      'encounterData': encounterLocalModel?.toJson(),
      'healthRecordType': healthRecordType?.toList(),
    });
  }
}

@HiveType(typeId: 1)
class EncounterLocalModel extends HiveObject {
  @HiveField(0)
  String? custodianName;
  @HiveField(1)
  String? status;
  @HiveField(2)
  DateTime? date;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['custodianName'] = custodianName;
    data['status'] = status;
    data['date'] = date.toString();
    return data;
  }

  @override
  String toString() {
    return jsonEncode({
      'custodianName': custodianName,
      'status': status,
      'date': date.toString(),
    });
  }
}

@HiveType(typeId: 2)
class HealthRecordTypeLocalModel extends HiveObject {
  @HiveField(0)
  String? resourceType;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? medicationCodeAbleConceptText;
  @HiveField(3)
  String? codeText;
  @HiveField(4)
  List<String>? notes;
  @HiveField(5)
  List<String>? dosageInstruction;
  @HiveField(6)
  String? performedDateTime;
  @HiveField(7)
  String? intent;
  @HiveField(8)
  String? description;
  @HiveField(9)
  List<DataEntryLocalModel>? dataEntry;
  @HiveField(10)
  List<PresentedFormLocalModel>? presentedForm;
  @HiveField(11)
  List<ContentAttachmentLocalModel>? healthRecordContentAttachment;
  @HiveField(12)
  String? conclusion;
  @HiveField(13)
  String? codingDisplay;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['resourceType'] = resourceType;
    data['title'] = title;
    data['medicationCodeAbleConceptText'] = medicationCodeAbleConceptText;
    data['codeText'] = codeText;
    data['notes'] = notes;
    data['dosageInstruction'] = dosageInstruction;
    data['performedDateTime'] = performedDateTime;
    data['intent'] = intent;
    data['description'] = description;
    data['dataEntry'] = dataEntry?.toList();
    data['presentedForm'] = presentedForm?.toList();
    data['healthRecordContentAttachment'] = healthRecordContentAttachment?.toList();
    data['conclusion'] = conclusion;
    data['codingDisplay'] = codingDisplay;
    return data;
  }

  @override
  String toString() {
    return jsonEncode({
      'title': title,
      'medicationCodeAbleConceptText': medicationCodeAbleConceptText,
      'codeText': codeText,
      'notes': notes,
      'dosageInstruction': dosageInstruction,
      'performedDateTime': performedDateTime,
      'intent': intent,
      'description': description,
      'dataEntry': dataEntry,
      'presentedForm': presentedForm,
      'healthRecordContentAttachment': healthRecordContentAttachment,
      'conclusion': conclusion,
      'codingDisplay': codingDisplay,
    });
  }
}

@HiveType(typeId: 3)
class DataEntryLocalModel extends HiveObject {
  @HiveField(0)
  String? fullUrl;
  @HiveField(1)
  String? startDate;
  @HiveField(2)
  String? endDate;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullUrl'] = fullUrl;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    return data;
  }

  @override
  String toString() {
    return jsonEncode({
      'fullUrl': fullUrl,
      'startDate': startDate,
      'endDate': endDate,
    });
  }
}

@HiveType(typeId: 4)
class PresentedFormLocalModel extends HiveObject {
  @HiveField(0)
  String? contentType;
  @HiveField(1)
  String? contentData;
  @HiveField(2)
  String? language;
  @HiveField(3)
  String? url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentType'] = contentType;
    data['contentData'] = contentData;
    data['language'] = language;
    data['url'] = url;
    return data;
  }

  @override
  String toString() {
    return jsonEncode({
      'contentType': contentType,
      'contentData': contentData,
      'language': language,
      'url': url,
    });
  }
}

@HiveType(typeId: 5)
class ContentAttachmentLocalModel extends HiveObject {
  @HiveField(0)
  String? contentType;
  @HiveField(1)
  String? language;
  @HiveField(2)
  String? url;
  @HiveField(3)
  int? size;
  @HiveField(4)
  String? title;
  @HiveField(5)
  String? creation;
  @HiveField(6)
  String? contentData;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contentType'] = contentType;
    data['language'] = language;
    data['url'] = url;
    data['size'] = size;
    data['title'] = title;
    data['creation'] = creation;
    data['contentData'] = contentData;
    return data;
  }

  @override
  String toString() {
    return jsonEncode({
      'contentType': contentType,
      'language': language,
      'url': url,
      'size': size,
      'title': title,
      'creation': creation,
      'contentData': contentData,
    });
  }
}
