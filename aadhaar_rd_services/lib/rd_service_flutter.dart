
import 'rd_service_flutter_platform_interface.dart';

class RdServiceFlutter {
  Future<String?> getPlatformVersion() {
    return RdServiceFlutterPlatform.instance.getPlatformVersion();
  }

  Future<String?> getAContact() {
    return RdServiceFlutterPlatform.instance.getAContact();
  }

  Future<String?> getRDServicePID() {
    return RdServiceFlutterPlatform.instance.getRDServicePID();
  }


  Future<bool?> checkIntentPresent({required String action}) {
    return RdServiceFlutterPlatform.instance.checkIntentPresent(action: action);
  }
}
