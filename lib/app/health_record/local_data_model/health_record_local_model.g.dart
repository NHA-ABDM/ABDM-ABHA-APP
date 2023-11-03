// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_record_local_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthRecordLocalModelAdapter
    extends TypeAdapter<HealthRecordLocalModel> {
  @override
  final int typeId = 0;

  @override
  HealthRecordLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecordLocalModel()
      ..date = fields[0] as String?
      ..hipName = fields[1] as String?
      ..hipId = fields[2] as String?
      ..consentRequestId = fields[3] as String?
      ..consentArtefactId = fields[4] as String?
      ..status = fields[5] as String?
      ..encounterLocalModel = fields[6] as EncounterLocalModel?
      ..healthRecordType =
          (fields[7] as List?)?.cast<HealthRecordTypeLocalModel>();
  }

  @override
  void write(BinaryWriter writer, HealthRecordLocalModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.hipName)
      ..writeByte(2)
      ..write(obj.hipId)
      ..writeByte(3)
      ..write(obj.consentRequestId)
      ..writeByte(4)
      ..write(obj.consentArtefactId)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.encounterLocalModel)
      ..writeByte(7)
      ..write(obj.healthRecordType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EncounterLocalModelAdapter extends TypeAdapter<EncounterLocalModel> {
  @override
  final int typeId = 1;

  @override
  EncounterLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EncounterLocalModel()
      ..custodianName = fields[0] as String?
      ..status = fields[1] as String?
      ..date = fields[2] as DateTime?;
  }

  @override
  void write(BinaryWriter writer, EncounterLocalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.custodianName)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EncounterLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthRecordTypeLocalModelAdapter
    extends TypeAdapter<HealthRecordTypeLocalModel> {
  @override
  final int typeId = 2;

  @override
  HealthRecordTypeLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthRecordTypeLocalModel()
      ..resourceType = fields[0] as String?
      ..title = fields[1] as String?
      ..medicationCodeAbleConceptText = fields[2] as String?
      ..codeText = fields[3] as String?
      ..notes = (fields[4] as List?)?.cast<String>()
      ..performedDateTime = fields[5] as String?
      ..intent = fields[6] as String?
      ..description = fields[7] as String?
      ..dataEntry = (fields[8] as List?)?.cast<DataEntryLocalModel>()
      ..presentedForm = (fields[9] as List?)?.cast<PresentedFormLocalModel>()
      ..healthRecordContentAttachment =
          (fields[10] as List?)?.cast<ContentAttachmentLocalModel>();
  }

  @override
  void write(BinaryWriter writer, HealthRecordTypeLocalModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.resourceType)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.medicationCodeAbleConceptText)
      ..writeByte(3)
      ..write(obj.codeText)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.performedDateTime)
      ..writeByte(6)
      ..write(obj.intent)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.dataEntry)
      ..writeByte(9)
      ..write(obj.presentedForm)
      ..writeByte(10)
      ..write(obj.healthRecordContentAttachment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthRecordTypeLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataEntryLocalModelAdapter extends TypeAdapter<DataEntryLocalModel> {
  @override
  final int typeId = 3;

  @override
  DataEntryLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataEntryLocalModel()
      ..fullUrl = fields[0] as String?
      ..startDate = fields[1] as String?
      ..endDate = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, DataEntryLocalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.fullUrl)
      ..writeByte(1)
      ..write(obj.startDate)
      ..writeByte(2)
      ..write(obj.endDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataEntryLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PresentedFormLocalModelAdapter
    extends TypeAdapter<PresentedFormLocalModel> {
  @override
  final int typeId = 4;

  @override
  PresentedFormLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PresentedFormLocalModel()
      ..contentType = fields[0] as String?
      ..language = fields[1] as String?
      ..url = fields[2] as String?;
  }

  @override
  void write(BinaryWriter writer, PresentedFormLocalModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.contentType)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PresentedFormLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ContentAttachmentLocalModelAdapter
    extends TypeAdapter<ContentAttachmentLocalModel> {
  @override
  final int typeId = 5;

  @override
  ContentAttachmentLocalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContentAttachmentLocalModel()
      ..contentType = fields[0] as String?
      ..language = fields[1] as String?
      ..url = fields[2] as String?
      ..size = fields[3] as int?
      ..title = fields[4] as String?
      ..creation = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, ContentAttachmentLocalModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.contentType)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.size)
      ..writeByte(4)
      ..write(obj.title)
      ..writeByte(5)
      ..write(obj.creation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContentAttachmentLocalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
