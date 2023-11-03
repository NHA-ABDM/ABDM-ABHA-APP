import 'package:abha/export_packages.dart';
import 'package:flutter/foundation.dart';

HealthRecordModel healthRecordFromMap(String str) =>
    HealthRecordModel.fromMap(json.decode(str));

String healthRecordToMap(HealthRecordModel data) => json.encode(data.toMap());

class HealthRecordModel {
  HealthRecordModel({
    this.size,
    this.limit,
    this.offset,
    this.healthDataEntries,
  });

  int? size;
  int? limit;
  int? offset;
  List<HealthDataEntries>? healthDataEntries;

  factory HealthRecordModel.fromMap(Map<String, dynamic> json) =>
      HealthRecordModel(
        size: json['size'],
        limit: json['limit'],
        offset: json['offset'],
        healthDataEntries: List<HealthDataEntries>.from(
          json['entries'].map((x) => HealthDataEntries.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
        'size': size,
        'limit': limit,
        'offset': offset,
        'entries': Validator.isNullOrEmpty(healthDataEntries)
            ? null
            : List<HealthDataEntries>.from(
                healthDataEntries!.map((x) => x.toMap()),
              ),
      };
}

class HealthDataEntries {
  HealthDataEntries({
    this.hipId,
    this.consentRequestId,
    this.consentArtefactId,
    this.status,
    this.bundleData,
    this.docId,
    this.docOriginId,
  });

  String? hipId;
  String? consentRequestId;
  String? consentArtefactId;
  String? status;
  BundleData? bundleData;
  String? docId;
  String? docOriginId;

  factory HealthDataEntries.fromMap(Map<String, dynamic> json) =>
      HealthDataEntries(
        hipId: json['hipId'],
        consentRequestId: json['consentRequestId'],
        consentArtefactId: json['consentArtefactId'],
        status: json['status'],
        bundleData: json['data'] == null ? null : BundleData.fromMap(json['data']),
        docId: json['docId'],
        docOriginId: json['docOriginId'],
      );

  Map<String, dynamic> toMap() => {
        'hipId': hipId,
        'consentRequestId': consentRequestId,
        'consentArtefactId': consentArtefactId,
        'status': status,
        'data': bundleData?.toMap(),
        'docId': docId,
        'docOriginId': docOriginId,
      };
}

class BundleData {
  BundleData({
    this.resourceType,
    this.id,
    this.meta,
    this.identifier,
    this.type,
    this.timestamp,
    this.entry,
  });

  String? resourceType;
  String? id;
  DataMeta? meta;
  IdentifierElement? identifier;
  String? type;
  String? timestamp;
  List<DataEntry>? entry;

  factory BundleData.fromMap(Map<String, dynamic> json) => BundleData(
        resourceType: json['resourceType'],
        id: json['id'],
        meta: json['meta'] == null ? null : DataMeta.fromMap(json['meta']),
        identifier: json['v'] == null
            ? null
            : IdentifierElement.fromMap(json['identifier']),
        type: json['type'],
        timestamp: json['timestamp'],
        entry: json['entry'] == null
            ? null
            : List<DataEntry>.from(
                json['entry'].map((x) => DataEntry.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'resourceType': resourceType,
        'id': id,
        'meta': meta?.toMap(),
        'identifier': identifier?.toMap(),
        'type': type,
        'timestamp': timestamp,
        'entry': Validator.isNullOrEmpty(entry)
            ? null
            : List<DataEntry>.from(entry!.map((x) => x.toMap())),
      };
}

class DataEntry {
  DataEntry({
    this.fullUrl,
    this.resource,
  });

  String? fullUrl;
  Resource? resource;

  factory DataEntry.fromMap(Map<String, dynamic> json) => DataEntry(
        fullUrl: json['fullUrl'],
        resource: Resource.fromMap(json['resource']),
      );

  Map<String, dynamic> toMap() => {
        'fullUrl': fullUrl,
        'resource': resource?.toMap(),
      };
}

class Resource {
  Resource({
    this.resourceTypeEnum,
    this.resourceType,
    this.id,
    this.meta,
    this.diagnosticText,
    this.language,
    this.identifier,
    this.status,
    this.type,
    this.subject,
    this.date,
    this.author,
    this.title,
    this.section,
    this.name,
    this.telecom,
    this.gender,
    this.birthDate,
    this.category,
    this.code,
    this.issued,
    this.performer,
    this.resultsInterpreter,
    this.conclusion,
    this.presentedForm,
    this.encounter,
    this.custodian,
    this.resourceClass,
    this.docStatus,
    this.content,
    this.clinicalStatus,
    this.patient,
    this.note,
    this.intent,
    this.medicationCodeableConcept,
    this.dosageInstruction,
    this.confidentiality,
    this.period,
    this.start,
    this.end,
    this.created,
    this.participant,
    this.description,
    this.activity,
    this.performedDateTime,
    this.classCode,
  });

  ResourceType? resourceTypeEnum;
  String? resourceType;
  String? id;
  ResourceMeta? meta;
  DiagnosticText? diagnosticText;
  String? language;
  dynamic identifier;
  String? status;
  HealthType? type;
  Custodian? subject;
  Encounter? encounter;
  String? date;
  List<Encounter>? author;
  String? title;
  List<Section>? section;
  dynamic name;
  List<Telecom>? telecom;
  String? gender;
  String? birthDate;
  List<Category>? category;
  ResourceCode? code;
  String? issued;
  List<Custodian>? performer;
  List<Encounter>? resultsInterpreter;
  String? conclusion;
  List<PresentedForm>? presentedForm;
  Custodian? custodian;
  Tag? resourceClass;
  String? docStatus;
  List<Content>? content;
  ClinicalStatus? clinicalStatus;
  Encounter? patient;
  List<ResourceCode>? note;
  String? intent;
  ResourceCode? medicationCodeableConcept;
  List<DosageInstruction>? dosageInstruction;
  String? confidentiality;
  Period? period;
  String? start;
  String? end;
  String? created;
  List<Participant>? participant;
  String? description;
  List<Activity>? activity;
  String? performedDateTime;
  Class? classCode;

  factory Resource.fromMap(Map<String, dynamic> json) => Resource(
        resourceTypeEnum: convertToResourceTypeEnum(json['resourceType']),
        resourceType: json['resourceType'],
        id: json['id'],
        meta: json['meta'] == null ? null : ResourceMeta.fromMap(json['meta']),
        diagnosticText: json['text'] == null ? null : DiagnosticText.fromMap(json['text']),
        language: json['language'],
        identifier: json['identifier'],
        status: json['status'],
        type: json['type'] == null ? null : HealthType.fromMap(json['type']),
        subject:
            json['subject'] == null ? null : Custodian.fromMap(json['subject']),
        date: json['date'],
        author: json['author'] == null
            ? null
            : List<Encounter>.from(
                json['author'].map((x) => Encounter.fromMap(x)),
              ),
        title: json['title'],
        section: json['section'] == null
            ? null
            : List<Section>.from(
                json['section'].map((x) => Section.fromMap(x)),
              ),
        name: json['name'],
        telecom: json['telecom'] == null
            ? null
            : List<Telecom>.from(
                json['telecom'].map((x) => Telecom.fromMap(x)),
              ),
        gender: json['gender'],
        birthDate: json['birthDate'],
        category: json['category'] == null
            ? null
            : List<Category>.from(
                json['category'].map((x) => Category.fromMap(x)),
              ),
        code: json['code'] == null ? null : ResourceCode.fromMap(json['code']),
        issued: json['issued'],
        performer: json['performer'] == null
            ? null
            : List<Custodian>.from(
                json['performer'].map((x) => Custodian.fromMap(x)),
              ),
        resultsInterpreter: json['resultsInterpreter'] == null
            ? null
            : List<Encounter>.from(
                json['resultsInterpreter'].map((x) => Encounter.fromMap(x)),
              ),
        conclusion: json['conclusion'],
        presentedForm: json['presentedForm'] == null
            ? null
            : List<PresentedForm>.from(
                json['presentedForm'].map((x) => PresentedForm.fromMap(x)),
              ),
        encounter: json['encounter'] == null
            ? null
            : Encounter.fromMap(json['encounter']),
        custodian: json['custodian'] == null
            ? null
            : Custodian.fromMap(json['custodian']),
        resourceClass:
            json['class'] == null ? null : Tag.fromMap(json['class']),
        docStatus: json['docStatus'],
        content: json['content'] == null
            ? null
            : List<Content>.from(
                json['content'].map((x) => Content.fromMap(x)),
              ),
        clinicalStatus: json['clinicalStatus'] == null
            ? null
            : ClinicalStatus.fromMap(json['clinicalStatus']),
        patient:
            json['patient'] == null ? null : Encounter.fromMap(json['patient']),
        note: json['note'] == null
            ? null
            : List<ResourceCode>.from(
                json['note'].map((x) => ResourceCode.fromMap(x)),
              ),
    dosageInstruction: json['dosageInstruction'] == null
        ? null
        : List<DosageInstruction>.from(
      json['dosageInstruction'].map((x) => DosageInstruction.fromMap(x)),
    ),
        intent: json['intent'],
        medicationCodeableConcept: json['medicationCodeableConcept'] == null
            ? null
            : ResourceCode.fromMap(json['medicationCodeableConcept']),
        confidentiality: json['confidentiality'],
        period: json['period'] == null ? null : Period.fromMap(json['period']),
        start: json['start'],
        end: json['end'],
        created: json['created'],
        participant: json['participant'] == null
            ? null
            : List<Participant>.from(
                json['participant'].map((x) => Participant.fromMap(x)),
              ),
        description: json['description'],
        activity: json['activity'] == null
            ? null
            : List<Activity>.from(
                json['activity'].map((x) => Activity.fromMap(x)),
              ),
        performedDateTime: json['performedDateTime'],
        classCode: json['class'] == null ? null : Class.fromMap(json['class']),
      );

  Map<String, dynamic> toMap() => {
        'resourceType': resourceType,
        'id': id,
        'meta': meta?.toMap(),
        'diagnosticText': diagnosticText?.toMap(),
        'language': language,
        'identifier': identifier,
        'status': status,
        'type': type?.toMap(),
        'subject': subject?.toMap(),
        'date': date,
        'author': Validator.isNullOrEmpty(author)
            ? null
            : List<Encounter>.from(author!.map((x) => x.toMap())),
        'title': title,
        'section': Validator.isNullOrEmpty(section)
            ? null
            : List<Section>.from(section!.map((x) => x.toMap())),
        'name': name,
        'telecom': Validator.isNullOrEmpty(telecom)
            ? null
            : List<Telecom>.from(telecom!.map((x) => x.toMap())),
        'gender': gender,
        'birthDate': birthDate,
        'category': Validator.isNullOrEmpty(category)
            ? null
            : List<Category>.from(category!.map((x) => x.toMap())),
        'code': code?.toMap(),
        'issued': issued,
        'performer': Validator.isNullOrEmpty(performer)
            ? null
            : List<Custodian>.from(performer!.map((x) => x.toMap())),
        'resultsInterpreter': Validator.isNullOrEmpty(resultsInterpreter)
            ? null
            : List<Encounter>.from(
                resultsInterpreter!.map((x) => x.toMap()),
              ),
        'conclusion': conclusion,
        'presentedForm': Validator.isNullOrEmpty(presentedForm)
            ? null
            : List<PresentedForm>.from(
                presentedForm!.map((x) => x.toMap()),
              ),
        'encounter': encounter?.toMap(),
        'custodian': custodian?.toMap(),
        'class': resourceClass?.toMap(),
        'docStatus': docStatus,
        'content': Validator.isNullOrEmpty(content)
            ? null
            : List<Content>.from(content!.map((x) => x.toMap())),
        'clinicalStatus': clinicalStatus?.toMap(),
        'patient': patient?.toMap(),
        'note': Validator.isNullOrEmpty(note)
            ? null
            : List<ResourceCode>.from(note!.map((x) => x.toMap())),
        'intent': intent,
        'medicationCodeableConcept': medicationCodeableConcept?.toMap(),
      'dosageInstruction': Validator.isNullOrEmpty(dosageInstruction)
        ? null
        : List<DosageInstruction>.from(dosageInstruction!.map((x) => x.toMap())),
        'confidentiality': confidentiality,
        'period': period?.toMap(),
        'start': start,
        'end': end,
        'created': created,
        'participant': Validator.isNullOrEmpty(participant)
            ? null
            : List<Participant>.from(
                participant!.map((x) => x.toMap()),
              ),
        'description': description,
        'activity': Validator.isNullOrEmpty(activity)
            ? null
            : List<Activity>.from(activity!.map((x) => x.toMap())),
        'performedDateTime': performedDateTime,
      };
}

enum ResourceType {
  defaultvalue,
  composition,
  patient,
  encounter,
  practitioner,
  organization,
  allergyintolerance,
  medicationrequest,
  procedure,
  careplan,
  condition,
  documentreference,
  diagnosticreport,
  observation,
  specimen,
  servicerequest
}

ResourceType? convertToResourceTypeEnum(String value) {
  List<ResourceType> types = ResourceType.values
      .where((e) => describeEnum(e) == value.toLowerCase())
      .toList();
  if (types.isNotEmpty) {
    return types.first;
  } else {
    return null;
  }
}

class Activity {
  Activity({
    this.outcomeReference,
  });

  List<Encounter>? outcomeReference;

  factory Activity.fromMap(Map<String, dynamic> json) => Activity(
        outcomeReference: List<Encounter>.from(
          json['outcomeReference'].map((x) => Encounter.fromMap(x)),
        ),
      );

  Map<String, dynamic> toMap() => {
        'outcomeReference': Validator.isNullOrEmpty(outcomeReference)
            ? null
            : List<Encounter>.from(
                outcomeReference!.map((x) => x.toMap()),
              ),
      };
}

class Encounter {
  Encounter({
    this.reference,
  });

  String? reference;

  factory Encounter.fromMap(Map<String, dynamic> json) => Encounter(
        reference: json['reference'],
      );

  Map<String, dynamic> toMap() => {
        'reference': reference,
      };
}

class Category {
  Category({
    this.coding,
  });

  List<Coding>? coding;

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        coding: json['coding'] == null
            ? null
            : List<Coding>.from(json['coding'].map((x) => Coding.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'coding': Validator.isNullOrEmpty(coding)
            ? null
            : List<Coding>.from(coding!.map((x) => x.toMap()))
      };
}

class Coding {
  Coding({
    this.system,
    this.display,
  });

  String? system;
  String? display;

  factory Coding.fromMap(Map<String, dynamic> json) => Coding(
        system: json['system'],
        display: json['display'],
      );

  Map<String, dynamic> toMap() => {
        'system': system,
        'display': display,
      };
}

class ResourceCode {
  ResourceCode({
    this.text,
  });

  String? text;

  factory ResourceCode.fromMap(Map<String, dynamic> json) => ResourceCode(
        text: json['text'],
      );

  Map<String, dynamic> toMap() => {
        'text': text,
      };
}

class Content {
  Content({
    this.attachment,
  });

  Attachment? attachment;

  factory Content.fromMap(Map<String, dynamic> json) => Content(
        attachment: json['attachment'] == null
            ? null
            : Attachment.fromMap(json['attachment']),
      );

  Map<String, dynamic> toMap() => {
        'attachment': attachment?.toMap(),
      };
}

class Attachment {
  Attachment({
    this.contentType,
    this.language,
    this.url,
    this.size,
    this.title,
    this.creation,
    this.data,
  });

  String? contentType;
  String? language;
  String? url;
  int? size;
  String? title;
  String? creation;
  String? data;

  factory Attachment.fromMap(Map<String, dynamic> json) => Attachment(
        contentType: json['contentType'],
        language: json['language'],
        url: json['url'],
        size: json['size'],
        title: json['title'],
        creation: json['creation'],
        data: json['data'],
      );

  Map<String, dynamic> toMap() => {
        'contentType': contentType,
        'language': language,
        'url': url,
        'size': size,
        'title': title,
        'creation': creation,
        'data': data,
      };
}

class Participant {
  Participant({
    this.actor,
    this.status,
  });

  Custodian? actor;
  String? status;

  factory Participant.fromMap(Map<String, dynamic> json) => Participant(
        actor: Custodian.fromMap(json['actor']),
        status: json['status'],
      );

  Map<String, dynamic> toMap() => {
        'actor': actor?.toMap(),
        'status': status,
      };
}

class Custodian {
  Custodian({
    this.reference,
    this.display,
  });

  String? reference;
  String? display;

  factory Custodian.fromMap(Map<String, dynamic> json) => Custodian(
        reference: json['reference'],
        display: json['display'],
      );

  Map<String, dynamic> toMap() => {
        'reference': reference,
        'display': display,
      };
}

class IdentifierElement {
  IdentifierElement({
    this.system,
    this.value,
  });

  String? system;
  String? value;

  factory IdentifierElement.fromMap(Map<String, dynamic> json) =>
      IdentifierElement(
        system: json['system'],
        value: json['value'],
      );

  Map<String, dynamic> toMap() => {
        'system': system,
        'value': value,
      };
}

class ResourceMeta {
  ResourceMeta({
    this.versionId,
    this.lastUpdated,
    this.tag,
    this.security,
  });

  String? versionId;
  String? lastUpdated;
  List<Tag>? tag;
  List<Tag>? security;

  factory ResourceMeta.fromMap(Map<String, dynamic> json) => ResourceMeta(
        versionId: json['versionId'],
        lastUpdated: json['lastUpdated'],
        tag: json['tag'] == null
            ? null
            : List<Tag>.from(json['tag'].map((x) => Tag.fromMap(x))),
        security: json['security'] == null
            ? null
            : List<Tag>.from(json['security'].map((x) => Tag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'versionId': versionId,
        'lastUpdated': lastUpdated,
        'tag': Validator.isNullOrEmpty(tag)
            ? null
            : List<Tag>.from(tag!.map((x) => x.toMap())),
        'security': Validator.isNullOrEmpty(security)
            ? null
            : List<Tag>.from(security!.map((x) => x.toMap())),
      };
}

class DiagnosticText {
  DiagnosticText({
    this.status,
    this.div,
  });

  String? status;
  String? div;

  factory DiagnosticText.fromMap(Map<String, dynamic> json) => DiagnosticText(
    status: json['status'],
    div: json['div'],
  );

  Map<String, dynamic> toMap() => {
    'status': status,
    'div': div,
  };
}

class Tag {
  Tag({
    this.system,
    this.code,
    this.display,
  });

  String? system;
  String? code;
  String? display;

  factory Tag.fromMap(Map<String, dynamic> json) => Tag(
        system: json['system'],
        code: json['code'],
        display: json['display'],
      );

  Map<String, dynamic> toMap() => {
        'system': system,
        'code': code,
        'display': display,
      };
}

class NameElement {
  NameElement({
    this.family,
    this.given,
  });

  String? family;
  List<String>? given;

  factory NameElement.fromMap(Map<String, dynamic> json) => NameElement(
        family: json['family'],
        given: json['given'] == null
            ? null
            : List<String>.from(json['given'].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        'family': family,
        'given': Validator.isNullOrEmpty(given)
            ? null
            : List<String>.from(given!.map((x) => x)),
      };
}

class DosageInstruction {
  DosageInstruction({
    this.text,
  });

  String? text;

  factory DosageInstruction.fromMap(Map<String, dynamic> json) => DosageInstruction(
    text: json['text'],
  );

  Map<String, dynamic> toMap() => {
    'text': text,
  };
}

class PresentedForm {
  PresentedForm({
    this.contentType,
    this.data,
    this.language,
    this.url,
  });

  String? contentType;
  String? data;
  String? language;
  String? url;

  factory PresentedForm.fromMap(Map<String, dynamic> json) => PresentedForm(
        contentType: json['contentType'],
    data: json['data'],
        language: json['language'],
        url: json['url'],
      );

  Map<String, dynamic> toMap() => {
        'contentType': contentType,
        'data': data,
        'language': language,
        'url': url,
      };
}

class Section {
  Section({
    this.title,
    this.code,
    this.entry,
  });

  String? title;
  SectionCode? code;
  List<Encounter>? entry;

  factory Section.fromMap(Map<String, dynamic> json) => Section(
        title: json['title'],
        code: json['code'] == null ? null : SectionCode.fromMap(json['code']),
        entry: json['entry'] == null
            ? null
            : List<Encounter>.from(
                json['entry'].map((x) => Encounter.fromMap(x)),
              ),
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'code': code ?? code?.toMap(),
        'entry': Validator.isNullOrEmpty(entry)
            ? null
            : List<Encounter>.from(entry!.map((x) => x.toMap())),
      };
}

class SectionCode {
  SectionCode({
    this.coding,
  });

  List<Tag>? coding;

  factory SectionCode.fromMap(Map<String, dynamic> json) => SectionCode(
        coding: json['coding'] == null
            ? null
            : List<Tag>.from(json['coding'].map((x) => Tag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'coding': Validator.isNullOrEmpty(coding)
            ? null
            : List<Tag>.from(coding!.map((x) => x.toMap())),
      };
}

class Telecom {
  Telecom({
    this.system,
    this.value,
    this.use,
  });

  String? system;
  String? value;
  String? use;

  factory Telecom.fromMap(Map<String, dynamic> json) => Telecom(
        system: json['system'],
        value: json['value'],
        use: json['use'],
      );

  Map<String, dynamic> toMap() => {
        'system': system,
        'value': value,
        'use': use,
      };
}

class HealthType {
  HealthType({
    this.coding,
    this.text,
  });

  List<Tag>? coding;
  String? text;

  factory HealthType.fromMap(Map<String, dynamic> json) => HealthType(
        coding: json['coding'] == null
            ? null
            : List<Tag>.from(json['coding'].map((x) => Tag.fromMap(x))),
        text: json['text'],
      );

  Map<String, dynamic> toMap() => {
        'coding': Validator.isNullOrEmpty(coding)
            ? null
            : List<Tag>.from(coding!.map((x) => x.toMap())),
        'text': text,
      };
}

class ClinicalStatus {
  ClinicalStatus({
    this.coding,
  });

  List<Tag>? coding;

  factory ClinicalStatus.fromMap(Map<String, dynamic> json) => ClinicalStatus(
        coding: List<Tag>.from(json['coding'].map((x) => Tag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'coding': Validator.isNullOrEmpty(coding)
            ? null
            : List<Tag>.from(coding!.map((x) => x.toMap())),
      };
}

class Period {
  Period({
    this.start,
    this.end,
  });

  DateTime? start;
  DateTime? end;

  factory Period.fromMap(Map<String, dynamic> json) => Period(
        start: DateTime.parse(json['start']),
        end: DateTime.parse(json['end']),
      );

  Map<String, dynamic> toMap() => {
        'start': start?.toIso8601String(),
        'end': end?.toIso8601String(),
      };
}

class DataMeta {
  DataMeta({
    this.versionId,
    this.lastUpdated,
    this.tag,
  });

  String? versionId;
  String? lastUpdated;
  List<Tag>? tag;

  factory DataMeta.fromMap(Map<String, dynamic> json) => DataMeta(
        versionId: json['versionId'],
        lastUpdated: json['lastUpdated'],
        tag: json['tag'] == null
            ? null
            : List<Tag>.from(json['tag'].map((x) => Tag.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        'versionId': versionId,
        'lastUpdated': lastUpdated,
        // "tag": Validator.isNullOrEmpty(tag)
        //     ? null
        //     : List<Tag>.from(tag!.map((x) => x.toMap())),
      };
}

class Class {
  Class({
    this.system,
    this.code,
    this.display,
  });

  String? system;
  String? code;
  String? display;

  factory Class.fromMap(Map<String, dynamic> json) => Class(
        system: json['system'],
        code: json['code'],
        display: json['display'],
      );
}
