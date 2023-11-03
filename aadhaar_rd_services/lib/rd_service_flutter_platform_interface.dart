import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rd_service_flutter_method_channel.dart';

abstract class RdServiceFlutterPlatform extends PlatformInterface {
  /// Constructs a RdServiceFlutterPlatform.
  RdServiceFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static RdServiceFlutterPlatform _instance = MethodChannelRdServiceFlutter();

  /// The default instance of [RdServiceFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelRdServiceFlutter].
  static RdServiceFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RdServiceFlutterPlatform] when
  /// they register themselves.
  static set instance(RdServiceFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getAContact() {
    throw UnimplementedError('getAContact() has not been implemented.');
  }

  Future<String?> getRDServicePID() {
    throw UnimplementedError('getRDServicePID() has not been implemented.');
  }

  Future<bool?> checkIntentPresent({required String action}) {
    throw UnimplementedError('checkIntentPresent() has not been implemented');
  }
}
