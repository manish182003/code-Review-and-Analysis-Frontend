import 'dart:io';

import 'package:code_review_and_analysis/utils/env/enviroment.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DeviceUtils {
  static final _storage = FlutterSecureStorage();

  static Future<String> getorCreateDeviceId() async {
    String? deviceId = await _storage.read(key: AppEnviroment.deviceId);
    if (deviceId != null) return deviceId;
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      deviceId =
          "${androidInfo.serialNumber}_${DateTime.now().millisecondsSinceEpoch}";
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      deviceId =
          "${iosInfo.identifierForVendor}_${DateTime.now().millisecondsSinceEpoch}";
    }
    await _storage.write(key: AppEnviroment.deviceId, value: deviceId);

    return deviceId ?? '';
  }

  static Future<void> storeAppToken(String token) async {
    String? existingToken = await _storage.read(key: AppEnviroment.appToken);
    if (existingToken != null) {
      await _storage.delete(key: AppEnviroment.appToken);
    }

    await _storage.write(key: AppEnviroment.appToken, value: token);
  }

  static Future<String?> getAppToken() async {
    String? token = await _storage.read(key: AppEnviroment.appToken);
    if (token != null) return token;
    return null;
  }

  static Future<void> deleteAppToken() async {
    await _storage.delete(key: AppEnviroment.appToken);
  }
}
