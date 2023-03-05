#include "include/i2p_flutter/i2p_flutter_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "i2p_flutter_plugin.h"

void I2pFlutterPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  i2p_flutter::I2pFlutterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
