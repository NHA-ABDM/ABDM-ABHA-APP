import 'package:abha/export_packages.dart';

class BaseRepo {
  late Logger abhaLog;
  BaseRepo(type) {
    abhaLog = customLogger(type);
    abhaLog.d(type.toString());
  }

  // Options getV3ApiOptions() {
  //   final Map configData = abhaSingleton.getAppConfig.getConfigData();
  //   Options options = Options(
  //     headers: {
  //       ApiKeys.headersKeys.apikey: configData[AppConfig.apikey],
  //       ApiKeys.headersKeys.requestId: const Uuid().v4(),
  //       ApiKeys.headersKeys.timestamp: DateTime.now().copyWith(microsecond: 0).toUtc().toIso8601String(),
  //     },
  //   );
  //   return options;
  // }
}
