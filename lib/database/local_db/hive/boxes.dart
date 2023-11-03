import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:hive/hive.dart';

class HiveBoxes {
  static const String healthRecordBox = 'healthRecordBox'; // boxName (table name)
  static const String linkedHipBox = 'linkedHipBox'; // boxName (table name)
  static const String hipConsentData = 'hipConsentData'; // boxName (table name)
  static const String erroredHipBox = 'erroredHipBox'; // boxName (table name)

  void closeAllBox() => Hive.close();
  // Future<void> deleteDB() async => Hive.deleteFromDisk();

  Future<void> openHealthRecordBox() async =>
      Hive.openBox<HealthRecordLocalModel>(healthRecordBox);
  Future<void> openLinkedHipBox() async => Hive.openBox<Map>(linkedHipBox);
  Future<void> openHipConsentData() async => Hive.openBox<Map>(hipConsentData);
  Future<void> openErroredHipBox() async => Hive.openBox<List>(erroredHipBox);

  Box<HealthRecordLocalModel> getHealthRecords() =>
      Hive.box<HealthRecordLocalModel>(healthRecordBox);
  Box<Map> getLinkedHipBox() => Hive.box<Map>(linkedHipBox);
  Box<Map> getHipConsentData() => Hive.box<Map>(hipConsentData);
  Box<List> getErroredHipBox() => Hive.box<List>(erroredHipBox);

  Future<void> clearHealthRecordBox() async =>
      Hive.box<HealthRecordLocalModel>(healthRecordBox).clear();
  Future<void> clearLinkedHipBox() async =>
      Hive.box<Map>(linkedHipBox).clear();
  Future<void> clearHipConsentData() async =>
      Hive.box<Map>(hipConsentData).clear();
  Future<void> clearErroredHipBox() async =>
      Hive.box<List>(erroredHipBox).clear();
}
