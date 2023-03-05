import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'i2p_flutter_method_channel.dart';

abstract class I2pFlutterPlatform extends PlatformInterface {
  /// Constructs a I2pFlutterPlatform.
  I2pFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static I2pFlutterPlatform _instance = MethodChannelI2pFlutter();

  /// The default instance of [I2pFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelI2pFlutter].
  static I2pFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [I2pFlutterPlatform] when
  /// they register themselves.
  static set instance(I2pFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getBinaryPathNative() {
    throw UnimplementedError('getBinaryPathNative() has not been implemented.');
  }
}
