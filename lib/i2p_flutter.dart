import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:i2p_flutter/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i2p_flutter_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class I2pFlutter {
  Future<void> writeCertificateBundle() async {
    final configDir = await getConfigDirectory();
    File("$configDir/certificates/family/gostcoin.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesFamilyGostcoin);
    File("$configDir/certificates/family/i2pd-dev.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesFamilyI2pddev);
    File("$configDir/certificates/family/i2p-dev.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesFamilyI2pdev);
    File("$configDir/certificates/family/mca2-i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesFamilyMcai2p);
    File("$configDir/certificates/family/stormycloud.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesFamilyStormycloud);
    File("$configDir/certificates/family/volatile.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesFamilyVolatile);
    File("$configDir/certificates/reseed/acetone_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedAceroneAtMailI2p);
    File("$configDir/certificates/reseed/creativecowpat_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedCreativecowpatAtMailI2p);
    File("$configDir/certificates/reseed/echelon3_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedEchelon3AtMailI2p);
    File("$configDir/certificates/reseed/hankhill19580_at_gmail.com.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedHankhill19580AtGmailCom);
    File("$configDir/certificates/reseed/hiduser0_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedHiduser0AtMailI2p);
    File("$configDir/certificates/reseed/hottuna_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedHottunaAtMailI2p);
    File("$configDir/certificates/reseed/i2p-reseed_at_mk16.de.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedI2pReseedAtMk16De);
    File("$configDir/certificates/reseed/igor_at_novg.net.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedIgorAtNovgNet);
    File("$configDir/certificates/reseed/lazygravy_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedLazyGravyAtMailI2p);
    File("$configDir/certificates/reseed/orignal_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedOrignalAtMailI2p);
    File("$configDir/certificates/reseed/r4sas-reseed_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedR5sasReseedAtMailI2p);
    File("$configDir/certificates/reseed/rambler_at_mail.i2p.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedRamblerAtMailI2p);
    File("$configDir/certificates/reseed/reseed_at_diva.exchange.crt")
      ..createSync(recursive: true)
      ..writeAsStringSync(certificatesReseedReseedAtDivaExchange);
    return;
  }

  Future<String> getConfigDirectory() async {
    String dir = '';
    if (Platform.isLinux) {
      dir = Platform.environment['HOME']??'/nonexistent';
      dir += "/.config/p3pch4t-i2p";
    } else {
      dir = (await getApplicationDocumentsDirectory()).path;
    }
    final configDir = p.join(dir, ".config-i2p");
    // create the directory
    File("$configDir/.dart_mkdir")
      ..createSync(recursive: true)
      ..deleteSync();
    return configDir;
  }

  Dio dio() {
    Dio dio = Dio();
    dio.httpClientAdapter = IOHttpClientAdapter()
      ..onHttpClientCreate = (client) {
        client.findProxy = (uri) {
          return 'PROXY localhost:4444';
        };
        return client;
      };
    return dio;
  }

  Future<String> getBinaryPath() async {
    if (Platform.isAndroid) {
      return (await I2pFlutterPlatform.instance.getBinaryPathNative())!;
    }
    return "i2pd";
  }

  Future<bool> isBinaryPresent() async {
    return await File(await getBinaryPath()).exists();
  }

  Future<void> ensureDeath() async {
    final configDir = await getConfigDirectory();
    final result = await Process.run(
      "/bin/sh",
      [
        '-c',
        "cd $configDir && kill \$(cat i2pd.pid)",
      ],
    );
    print(result.stdout);
    print(result.stdout);
  }

  Future<void> writeTunnelsConf(String newFile) async {
    await File("${await getConfigDirectory()}/tunnels.conf")
        .writeAsString(newFile);
  }

  Future<String> readTunnelsConf() async {
    final conf = File("${await getConfigDirectory()}/tunnels.conf");
    return await conf.readAsString();
  }

  Future<void> writeI2pdConf(String newFile) async {
    await File("${await getConfigDirectory()}/i2pd.conf")
        .writeAsString(newFile);
  }

  Future<String> readI2pdConf() async {
    final conf = File("${await getConfigDirectory()}/i2pd.conf");
    return await conf.readAsString();
  }

  Future<bool> runI2pd() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("flutter_i2pd.dontrun") == true) return false;

    await ensureDeath();
    await Future.delayed(const Duration(seconds: 1));
    if (await isRunning()) return false;
    final configDir = await getConfigDirectory();
    // return false;
    //final result = await Process.start(
    //  '/bin/sh',
    //  [
    //    '-c',
    //    "cd $configDir && ${await getBinaryPath()} --datadir=$configDir",
    //  ],
    //);

    final result = await Process.start(
      await getBinaryPath(),
      [
        "--datadir=$configDir",
      ],
    );
    result.stdout.transform(utf8.decoder).forEach(print);
    result.stderr.transform(utf8.decoder).forEach(print);
    print(await result.exitCode);

    return false;
  }

  Future<String?> getProcessInfo() async {
    try {
      final configDir = await getConfigDirectory();
      final result1 = await Process.run(
        '/bin/sh',
        [
          '-c',
          "cd $configDir && ps -p \$(cat i2pd.pid)",
        ],
      );
      String output = result1.stdout + "\n" + result1.stderr;
      if (result1.exitCode == 0 && output.contains('libi2pd.so')) {
        // MIUI hack.
        return output;
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  Future<bool> isRunning() async {
    try {
      final response = await Dio().get("http://127.0.0.1:7070/");
      return true;
    } on DioError {
      return false;
    }

    return (await getProcessInfo()) != null;
  }

  Future<int> getUptimeSeconds() async {
    try {
      final response = await Dio().get(
        "http://127.0.0.1:7070/",
      );
      List<String> resp1 = response.toString().split("\n");
      resp1.removeWhere(
        (element) => !element.contains(r'<div class="content"><b>Uptime:</b>'),
      );
      var resp2 = resp1[0]
          .replaceAll(RegExp(' +'), ' ')
          .replaceAll(r'<div class="content"><b>Uptime:</b>', "")
          .replaceAll(r'<br>', '')
          .replaceAll(RegExp(r'[^\w\s]+'), '');
      if (resp2.startsWith(' ')) {
        resp2 = resp2.substring(1);
      }
      final resp3 = resp2.split(" ");
      int secs = 0;
      for (var i = 1; i < resp3.length; i = i + 2) {
        if (resp3[i].startsWith('day')) {
          secs += int.parse(resp3[i - 1]) * 60 * 60 * 24;
        }
        if (resp3[i].startsWith('hour')) {
          secs += int.parse(resp3[i - 1]) * 60 * 60;
        }
        if (resp3[i].startsWith('minute')) secs += int.parse(resp3[i - 1]) * 60;
        if (resp3[i].startsWith('second')) secs += int.parse(resp3[i - 1]);
      }

      return secs;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
    return 3600;
  }

  Future<Map<String, String>> getTunnelsList() async {
    try {
      final response = await Dio().get(
        "http://127.0.0.1:7070/?page=i2p_tunnels",
      );
      List<String> resp1 = response.toString().split("\n");
      resp1.removeWhere(
        (element) => !element.contains(r'<div class="listitem">'),
      );
      Map<String, String> finalResp = {};
      for (var elm in resp1) {
        elm = elm
            .replaceAll(
              r'<div class="listitem"><a href="/?page=local_destination&b32=',
              "",
            )
            .replaceAll(r' &#8658; ', "")
            .replaceAll(r' &#8656; ', "")
            .replaceAll("</div>", "</a>");
        finalResp[elm.split("</a>")[0].split(r'">')[1]] = elm.split("</a>")[1];
      }
      return finalResp;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.headers);
        print(e.response?.requestOptions);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }
    }
    return {};
  }

  Future<String?> getPlatformVersion() {
    return I2pFlutterPlatform.instance.getPlatformVersion();
  }
}

final i2pFlutterPlugin = I2pFlutter();
