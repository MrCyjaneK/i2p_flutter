#ifndef FLUTTER_PLUGIN_I2P_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_I2P_FLUTTER_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace i2p_flutter {

class I2pFlutterPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  I2pFlutterPlugin();

  virtual ~I2pFlutterPlugin();

  // Disallow copy and assign.
  I2pFlutterPlugin(const I2pFlutterPlugin&) = delete;
  I2pFlutterPlugin& operator=(const I2pFlutterPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace i2p_flutter

#endif  // FLUTTER_PLUGIN_I2P_FLUTTER_PLUGIN_H_
