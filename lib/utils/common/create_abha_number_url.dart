import 'package:abha/export_packages.dart';

class CreateAbhaNumberUrl {
  static void abhaNumberCreateViaWeb(BuildContext context) {
    Map configData = abhaSingleton.getAppConfig.getConfigData();
    LaunchURLServiceImpl().openInAppWebView(
      context,
      title: configData[AppConfig.appName],
      url: '${configData[AppConfig.abhaUrl]}${ApiPath.createAbhaUrl}',
    );
  }
}
