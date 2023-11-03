import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rd_service_flutter_platform_interface.dart';

/// An implementation of [RdServiceFlutterPlatform] that uses method channels.
class MethodChannelRdServiceFlutter extends RdServiceFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rd_service_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getAContact() async {
    final String? contact =
        await methodChannel.invokeMethod<String>('getAContact');
    return contact;
  }

  @override
  Future<String?> getRDServicePID() async {
    final String? pid =
    await methodChannel.invokeMethod<String>('getRDServicePID');
    return pid;
  }


  @override
  Future<bool?> checkIntentPresent({required String action}) async {
    final bool? isAvailable = await methodChannel
        .invokeMethod('checkIntentPresent', {'action': action});
    return isAvailable;
  }
}
