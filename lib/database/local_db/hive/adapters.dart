import 'package:abha/app/health_record/local_data_model/health_record_local_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveAdapters {
  Future<void> initHiveAdapters() async {
    await Hive.initFlutter();
    Hive.registerAdapter(HealthRecordLocalModelAdapter());
    Hive.registerAdapter(EncounterLocalModelAdapter());
    Hive.registerAdapter(HealthRecordTypeLocalModelAdapter());
    Hive.registerAdapter(PresentedFormLocalModelAdapter());
    Hive.registerAdapter(DataEntryLocalModelAdapter());
    Hive.registerAdapter(ContentAttachmentLocalModelAdapter());
  }
}
