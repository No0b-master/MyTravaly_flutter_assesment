
class DeviceModel {
  final String deviceModel;
  final String deviceFingerprint;
  final String deviceBrand;
  final String deviceId;
  final String deviceName;
  final String deviceManufacturer;
  final String deviceProduct;
  final String deviceSerialNumber;

  DeviceModel({
    required this.deviceModel,
    required this.deviceFingerprint,
    required this.deviceBrand,
    required this.deviceId,
    required this.deviceName,
    required this.deviceManufacturer,
    required this.deviceProduct,
    required this.deviceSerialNumber,
  });

  Map<String, dynamic> toJson() => {
    "deviceModel": deviceModel,
    "deviceFingerprint": deviceFingerprint,
    "deviceBrand": deviceBrand,
    "deviceId": deviceId,
    "deviceName": deviceName,
    "deviceManufacturer": deviceManufacturer,
    "deviceProduct": deviceProduct,
    "deviceSerialNumber": deviceSerialNumber,
  };

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    return DeviceModel(
      deviceModel: json["deviceModel"] ?? '',
      deviceFingerprint: json["deviceFingerprint"] ?? '',
      deviceBrand: json["deviceBrand"] ?? '',
      deviceId: json["deviceId"] ?? '',
      deviceName: json["deviceName"] ?? '',
      deviceManufacturer: json["deviceManufacturer"] ?? '',
      deviceProduct: json["deviceProduct"] ?? '',
      deviceSerialNumber: json["deviceSerialNumber"] ?? '',
    );
  }
}
