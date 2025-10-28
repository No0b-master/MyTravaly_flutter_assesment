import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import '../Constants/prefs.dart';
import '../Constants/webservices.dart';
import '../Utils/shared_preferences.dart';
import '../Models/device_model.dart';

class RegisterDeviceService {
  static Future<DeviceModel?> fetchDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return DeviceModel(
        deviceModel: info.model,
        deviceFingerprint: info.fingerprint,
        deviceBrand: info.brand,
        deviceId: info.id,
        deviceName: info.device,
        deviceManufacturer: info.manufacturer,
        deviceProduct: info.product,
        deviceSerialNumber: info.hardware,
      );
    } else {
      final info = await deviceInfo.iosInfo;
      return DeviceModel(
        deviceModel: info.model,
        deviceFingerprint: info.identifierForVendor ?? "",
        deviceBrand: "Apple",
        deviceId: info.identifierForVendor ?? "",
        deviceName: info.name,
        deviceManufacturer: "Apple",
        deviceProduct: info.utsname.machine,
        deviceSerialNumber: "unknown",
      );
    }
  }

  static Future<bool> registerDevice() async {
    try {
      final device = await fetchDeviceInfo();
      if (device == null) return false;

      final url = Uri.parse(Webservices.baseUrl);
      final payload = {
        "action": "deviceRegister",
        "deviceRegister": device.toJson(),
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'authToken': SessionManager.getString(Prefs.authToken),
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse["status"] == true) {
          final token = jsonResponse["data"]["visitorToken"];
          await SessionManager.setString(Prefs.visitorToken, token);
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Register Device Error: $e");
      return false;
    }
  }
}
