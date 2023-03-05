import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'i2p_flutter_platform_interface.dart';

/// An implementation of [I2pFlutterPlatform] that uses method channels.
class MethodChannelI2pFlutter extends I2pFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('i2p_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getBinaryPathNative() async {
    final version =
        await methodChannel.invokeMethod<String>('getBinaryPathNative');
    return version;
  }
}
